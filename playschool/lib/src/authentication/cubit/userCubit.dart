import 'package:bloc/bloc.dart';
import 'package:playschool/src/authentication/model/User.dart';

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
}