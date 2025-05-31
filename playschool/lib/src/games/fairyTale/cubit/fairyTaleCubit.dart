import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playschool/src/games/fairyTale/model/FairyTaleResult.dart';
import 'package:playschool/src/games/fairyTale/repository/FairyTaleRepository.dart';

class FairyTaleCubit extends Cubit<FairyTaleState> {
  final FairyTaleRepository fairyTaleRepository;

  FairyTaleCubit({
    required this.fairyTaleRepository
  }) : super(FairyTaleState());

  Future<void> createFairy(String content, String userUID, {XFile? img}) async {
    emit(state.copyWith(fairyTaleStatus: FairyTaleStatus.loading));

    try {
      final fairyTaleResult = await fairyTaleRepository.createFairyBook(content, userUID, img);
      print("non-error!!");
      emit(state.copyWith(fairyTaleResult: fairyTaleResult, fairyTaleStatus: FairyTaleStatus.complete));
    } catch(e) {
      print("error!!");
      print(e);
      emit(state.copyWith(fairyTaleStatus: FairyTaleStatus.error));
    }
  }

  Future<String> formatScene(String template, {
    required String character,
    required String background,
    required String action,
  }) async {
    return template
      .replaceAll("{character}", character)
      .replaceAll("{background}", background)
      .replaceAll("{action}", action);
  }
}

enum FairyTaleStatus {
  init,
  loading,
  complete,
  error
}

class FairyTaleState extends Equatable {
  final FairyTaleStatus fairyTaleStatus;
  final FairyTaleResult? fairyTaleResult;

  const FairyTaleState ({
    this.fairyTaleStatus = FairyTaleStatus.init,
    this.fairyTaleResult
  });

  FairyTaleState copyWith ({
    FairyTaleStatus? fairyTaleStatus,
    FairyTaleResult? fairyTaleResult,
  }) {
    return FairyTaleState(
      fairyTaleStatus: fairyTaleStatus ?? this.fairyTaleStatus,
      fairyTaleResult: fairyTaleResult ?? this.fairyTaleResult
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [fairyTaleStatus, fairyTaleResult];
}