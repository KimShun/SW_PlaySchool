import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class PuzzleCubit extends Cubit<PuzzleState> {
  final String imageUrl = "https://th.bing.com/th/id/OIP.W_jE3Gz7KaX_EeHEbW4FqwAAAA?rs=1&pid=ImgDetMain";
  final AudioPlayer _player = AudioPlayer();

  PuzzleCubit() : super(PuzzleState()) {
    playBGM();
    loadImageUrl();
  }

  void puzzleDone() {
    emit(state.copyWith(status: PuzzleStatus.done));
  }

  void updatePlacedPiece(int index) {
    final newPlacedPieces = Map<int, bool>.from(state.placedPieces!);
    newPlacedPieces[index] = true;

    emit(state.copyWith(placedPieces: newPlacedPieces));
  }

  void checkPuzzleCompletion() {
    if(state.placedPieces!.values.every((pieces) => pieces == true)) {
      emit(state.copyWith(status: PuzzleStatus.completed));
    }
  }

  void playBGM() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.play(AssetSource("bgm/puzzleBGM.mp3"));
  }

  void playPause() {
    _player.dispose();
  }

  Future<void> loadImageUrl() async {
    print("실행됨!!");
    emit(state.copyWith(status: PuzzleStatus.loading));

    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final Uint8List data = response.bodyBytes;
        final ui.Codec codec = await ui.instantiateImageCodec(data, targetWidth: 300, targetHeight: 300);
        final ui.FrameInfo frame = await codec.getNextFrame();

        emit(state.copyWith(image: frame.image));

        final pieces = await _splitImage();
        emit(state.copyWith(
          status: PuzzleStatus.loaded,
          imagePieces: pieces.shfflePieces,
          answerMapping: pieces.answerMapping,
          placedPieces: {0: false, 1: false, 2: false, 3: false}
        ));
      }
    } catch(e) {
      emit(state.copyWith(status: PuzzleStatus.error, error: e.toString()));
    }
  }

  Future<_PuzzlePieces> _splitImage() async {
    int imageWidth = state.image!.width;
    int imageHeight = state.image!.height;

    int pieceWidth = imageWidth ~/ 2;
    int pieceHeight = imageHeight ~/ 2;

    List<int> originalIndexes = [0, 1, 2, 3];
    List<ui.Image> pieces = [];

    Future<void> cutPiece(int left, int top) async {
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(pieceWidth.toDouble(), pieceHeight.toDouble())));

      final src = Rect.fromLTWH(left.toDouble(), top.toDouble(), pieceWidth.toDouble(), pieceHeight.toDouble());
      final dst = Rect.fromLTWH(0, 0, pieceWidth.toDouble(), pieceHeight.toDouble());

      canvas.drawImageRect(state.image!, src, dst, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(pieceWidth, pieceHeight);

      pieces.add(img);
    }

    await cutPiece(0, 0);
    await cutPiece(pieceWidth, 0);
    await cutPiece(0, pieceHeight);
    await cutPiece(pieceWidth, pieceHeight);

    List<int> shuffleIndexes = List.from(originalIndexes)..shuffle();

    List<ui.Image> shuffledPieces = List.generate(4, (index) => pieces[shuffleIndexes[index]]);
    Map<int, int> answerMapping = { for (int i=0; i<4; i++) originalIndexes[i] : shuffleIndexes[i] };

    return _PuzzlePieces(shfflePieces: shuffledPieces, answerMapping: answerMapping);
  }
}

class _PuzzlePieces {
  final List<ui.Image> shfflePieces;
  final Map<int, int> answerMapping;

  _PuzzlePieces({required this.shfflePieces, required this.answerMapping});
}

enum PuzzleStatus {
  init,
  loading,
  loaded,
  completed,
  done,
  error
}

class PuzzleState extends Equatable {
  final PuzzleStatus status;
  final ui.Image? image;
  final List<ui.Image>? imagePieces;
  final Map<int, bool>? placedPieces;
  final Map<int, int>? answerMapping;
  final String? error;

  const PuzzleState({
    this.status = PuzzleStatus.init,
    this.image,
    this.imagePieces = const [],
    this.placedPieces = const {},
    this.answerMapping = const {},
    this.error
  });

  PuzzleState copyWith({
    PuzzleStatus? status,
    ui.Image? image,
    List<ui.Image>? imagePieces,
    Map<int, bool>? placedPieces,
    Map<int, int>? answerMapping,
    String? error,
  }) {
    return PuzzleState(
      status: status ?? this.status,
      image: image ?? this.image,
      imagePieces: imagePieces ?? this.imagePieces,
      placedPieces: placedPieces ?? this.placedPieces,
      answerMapping: answerMapping ?? this.answerMapping,
      error: error ?? this.error
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [status, image, imagePieces, placedPieces, answerMapping, error];
}