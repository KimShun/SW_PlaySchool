import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playschool/src/games/fairyTale/model/FairyTaleResult.dart';

class FairyTaleCubit extends Cubit<FairyTaleState> {
  FairyTaleCubit() : super(FairyTaleState());


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