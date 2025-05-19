import 'package:bloc/bloc.dart';
import 'package:playschool/src/authentication/model/User.dart';
import 'package:playschool/src/games/today/wordGame/word.dart';

class UserCubit extends Cubit<User?> {
  UserCubit() : super(null);

  void setUser(User user) {
    emit(user);
  }

  void updateTodayGame(int selectToday) async {
    late User updatedUser;

    if (selectToday == 1) {
      updatedUser = state!.copyWith(todayGame1: true);
    } else if (selectToday == 2) {
      updatedUser = state!.copyWith(todayGame2: true);
    }

    emit(updatedUser);
  }

  void updateGame(int gameNumber) async {
    late User updatedUser;

    if (gameNumber == 1) {
      final selectCount = state!.gamePlay.wordGame;
      updatedUser = state!.copyWith(gamePlay: state!.gamePlay.copyWith(wordGame: selectCount + 1));
    } else if (gameNumber == 2) {
      final selectCount = state!.gamePlay.findWrongGame;
      updatedUser = state!.copyWith(gamePlay: state!.gamePlay.copyWith(findWrongGame: selectCount + 1));
    } else if (gameNumber == 3) {
      final selectCount = state!.gamePlay.danceGame;
      updatedUser = state!.copyWith(gamePlay: state!.gamePlay.copyWith(danceGame: selectCount + 1));
    } else if (gameNumber == 4) {
      final selectCount = state!.gamePlay.paintGame;
      updatedUser = state!.copyWith(gamePlay: state!.gamePlay.copyWith(paintGame: selectCount + 1));
    } else if (gameNumber == 5) {
      final selectCount = state!.gamePlay.makeBookGame;
      updatedUser = state!.copyWith(gamePlay: state!.gamePlay.copyWith(makeBookGame: selectCount + 1));
    }

    emit(updatedUser);
  }

  void userExpUp() async {
    late User updatedUser;

    updatedUser = state!.copyWith(exp: state!.exp + 1);
    emit(updatedUser);
  }

  void userLevelUp() async {
    late User updatedUser;

    updatedUser = state!.copyWith(level: state!.level + 1, exp: 0);
    emit(updatedUser);
  }
}