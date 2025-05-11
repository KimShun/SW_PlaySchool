import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:playschool/src/games/dance/repository/DanceRepository.dart';
import 'package:video_player/video_player.dart';

class DanceCubit extends Cubit<DanceState> {
  final DanceRepository danceRepository;

  DanceCubit({
    required this.danceRepository,
  }) : super(DanceState()) {}

  late Timer _countdownTimer;
  int _countdown = 5;

  void initVideo(String videoPath) async {
    final _controller = VideoPlayerController.asset(videoPath);
    await _controller.initialize();
    _controller.setVolume(1.0);

    _controller.addListener(() async {
      if (_controller.value.position >= _controller.value.duration) {
        final videoFile = await state.cameraController!.stopVideoRecording();
        emit(state.copyWith(isFinish: true, recordVideo: videoFile));
      }
    });

    emit(state.copyWith(videoController: _controller, isVideoInitialized: true));
  }

  void initCamera() async {
    List<CameraDescription> _cameras = await availableCameras();
    final _cameraController = CameraController(
        _cameras[1],
        ResolutionPreset.medium
    );
    await _cameraController.initialize();

    emit(state.copyWith(cameraController: _cameraController, isCameraInitialized: true));
  }

  void startCountdown() {
    emit(state.copyWith(isReadyToStart: true));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        emit(state.copyWith(countdown: _countdown));
        _countdown--;
      } else {
        _countdownTimer.cancel();
        _startDance();
      }
    });
  }

  void _startDance() async {
    emit(state.copyWith(isStart: true));
    await state.videoController!.play();
    await state.cameraController!.startVideoRecording();
  }

  Future<void> close() async {
    // if (state.recordVideo != null) {
    //   await File(state.recordVideo!.path).delete();
    // }

    _countdownTimer.cancel();
    state.videoController?.dispose();
    state.cameraController?.dispose();
    return super.close();
  }

  void resetState() {
    _countdown = 5;
    emit(DanceState());
  }

  void changeIsShowing() {
    if (state.isShowing) {
      emit(state.copyWith(isShowing: false));
      allResume();
    } else {
      emit(state.copyWith(isShowing: true));
      allPause();
    }
  }

  void allPause() async {
    state.cameraController!.pauseVideoRecording();
    state.videoController!.pause();
  }

  void allResume() async {
    state.cameraController!.resumeVideoRecording();
    state.videoController!.play();
  }

  void assessmentStart() async {
    await danceRepository.fetchDanceResult(state.videoController!.dataSource, state.recordVideo!);
  }
}

class DanceState extends Equatable {
  final VideoPlayerController? videoController;
  final CameraController? cameraController;
  final bool isShowing;
  final bool isCameraInitialized;
  final bool isVideoInitialized;
  final bool isReadyToStart;
  final bool isStart;
  final int countdown;
  final bool isFinish;
  final XFile? recordVideo;
  final Timer? countdownTimer;

  const DanceState({
    this.videoController,
    this.cameraController,
    this.isShowing = false,
    this.isCameraInitialized = false,
    this.isVideoInitialized = false,
    this.isReadyToStart = false,
    this.isStart = false,
    this.countdown = 5,
    this.isFinish = false,
    this.recordVideo,
    this.countdownTimer
  });

  DanceState copyWith ({
    VideoPlayerController? videoController,
    CameraController? cameraController,
    bool? isShowing,
    bool? isCameraInitialized,
    bool? isVideoInitialized,
    bool? isReadyToStart,
    bool? isStart,
    int? countdown,
    bool? isFinish,
    XFile? recordVideo,
    Timer? countdownTimer,
  }) {
    return DanceState(
      videoController: videoController ?? this.videoController,
      cameraController: cameraController ?? this.cameraController,
      isShowing: isShowing ?? this.isShowing,
      isCameraInitialized: isCameraInitialized ?? this.isCameraInitialized,
      isVideoInitialized: isVideoInitialized ?? this.isVideoInitialized,
      isReadyToStart: isReadyToStart ?? this.isReadyToStart,
      isStart: isStart ?? this.isStart,
      countdown: countdown ?? this.countdown,
      isFinish: isFinish ?? this.isFinish,
      recordVideo: recordVideo ?? this.recordVideo,
      countdownTimer: countdownTimer ?? this.countdownTimer,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [videoController, cameraController, isShowing, isCameraInitialized, isVideoInitialized, isReadyToStart, isStart, countdown, isFinish, recordVideo, countdownTimer];
}