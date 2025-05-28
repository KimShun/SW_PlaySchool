import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:playschool/src/authentication/cubit/userCubit.dart';
import 'package:playschool/src/authentication/model/User.dart';

class AuthRepository {
  final String baseUrl;

  const AuthRepository({
    required this.baseUrl,
  });

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/login"),
      headers: {
        "Content-Type" : "application/json"
      },
      body: json.encode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final token = data["token"];
      return token;
    } else {
      throw Exception("존재하지 않는 아이디 또는 비밀번호 입니다.");
    }
  }

  Future<User> fetchUserInfo(String token) async {
    final response = await http.get(
      Uri.parse("$baseUrl/api/auth/validate"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return User.fromJson(data["user"]);
    } else {
      throw Exception("토큰이 유효하지 않습니다.");
    }
  }

  Future<String> SignUp(String email, String password, String nickname, String birthDate, String gender) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/signup"),
      headers: {
        "Content-Type" : "application/json"
      },
      body: json.encode({
        "email" : email,
        "password" : password,
        "nickname" : nickname,
        "birthDate" : birthDate,
        "gender" : gender
      }),
    );

    if(response.statusCode == 201) {
      return "회원가입 성공";
    } else {
      throw Exception("회원가입 실패: ${response.body}");
    }
  }

  Future<void> userExpUp(BuildContext context, String token) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/api/auth/expup"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      context.read<UserCubit>().userExpUp();
    }
  }

  Future<String> userLevelUp(BuildContext context, String token) async {
    final response = await http.patch(
      Uri.parse("$baseUrl/api/auth/levelup"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      context.read<UserCubit>().userLevelUp();
      return "Success";
    } else {
      return "Failed";
    }
  }
}