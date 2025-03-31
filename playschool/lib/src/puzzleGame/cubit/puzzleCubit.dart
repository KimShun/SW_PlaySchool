import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class PuzzleCubit extends Cubit<PuzzleState> {
  PuzzleCubit() : super(PuzzleState()) {

  }
}

class PuzzleState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}