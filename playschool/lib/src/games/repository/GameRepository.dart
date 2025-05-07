import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playschool/src/authentication/cubit/userCubit.dart';

class GameRepository {
  final String baseUrl;

  const GameRepository({
    required this.baseUrl
  });

  Future<void> updateTodayGame(BuildContext context, int selectToday, String token) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/api/game/todayclear?selectToday=$selectToday"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      context.read<UserCubit>().updateTodayGame(selectToday);
      print(context.read<UserCubit>().state!.todayGame1);
      print(context.read<UserCubit>().state!.todayGame2);
    }
  }
}