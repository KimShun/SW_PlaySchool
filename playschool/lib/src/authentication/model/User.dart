import 'package:playschool/src/authentication/model/GamePlay.dart';

class User {
  final String userUID;
  final String email;
  final String password;
  final String nickname;
  final DateTime birthDate;
  final String gender;
  final String createdAt;
  final bool todayGame1;
  final bool todayGame2;
  final int exp;
  final int level;
  final GamePlay gamePlay;

  const User({
    required this.userUID,
    required this.email,
    required this.password,
    required this.nickname,
    required this.birthDate,
    required this.gender,
    required this.createdAt,
    required this.todayGame1,
    required this.todayGame2,
    required this.exp,
    required this.level,
    required this.gamePlay
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userUID: json['userUID'],
      email: json['email'],
      password: json['password'],
      nickname: json['nickname'],
      birthDate: DateTime.parse(json['birthDate']),
      gender: json['gender'],
      createdAt: json["createdAt"],
      todayGame1: json['todayGame1'],
      todayGame2: json['todayGame2'],
      exp: json['exp'],
      level: json['level'],
      gamePlay: GamePlay.fromJson(json["gamePlay"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userUID" : userUID,
      'email': email,
      'password': password,
      'nickname': nickname,
      'birthDate': birthDate.toString().split(" ").first,
      'gender': gender,
      'todayGame1': todayGame1,
      'todayGame2': todayGame2,
      'exp': exp,
      'level': level,
      'gamePlay': gamePlay,
    };
  }
}