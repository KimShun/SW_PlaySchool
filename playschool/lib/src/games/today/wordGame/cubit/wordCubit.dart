import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:playschool/src/games/today/configure.dart';

class WordCubit extends Cubit<WordState> {
  final String imageUrl = todayImage;
  final String answer = todayAnswer;

  WordCubit() : super(WordState()) {
    loadGame();
  }

  void loadGame() {
    final shuffleList = List.of(todayAnswerList)..shuffle();
    emit(state.copyWith(status: WordStatus.init, answerList: shuffleList, tryCount: 0));
  }

  void checking(String select) {
    if(select == answer) {
      emit(state.copyWith(status: WordStatus.completed, tryCount: state.tryCount + 1));
    } else {
      emit(state.copyWith(status: WordStatus.failed, tryCount: state.tryCount + 1));
    }
  }
}

enum WordStatus {
  init,
  completed,
  failed
}

class WordState extends Equatable {
  final int tryCount;
  final WordStatus status;
  final List<String> answerList;

  const WordState({
    this.tryCount = 0,
    this.status = WordStatus.init,
    this.answerList = const [],
  });

  WordState copyWith({
    int? tryCount,
    WordStatus? status,
    List<String>? answerList,
  }) {
    return WordState(
      tryCount: tryCount ?? this.tryCount,
      status: status ?? this.status,
      answerList: answerList ?? this.answerList,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [tryCount, status, answerList];
}