import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:playschool/src/authentication/cubit/authCubit.dart';
import 'package:playschool/src/authentication/repository/AuthRepository.dart';

import '../common/component/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [

            Positioned.fill(
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/background/login_bg.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// 전체 내용
            SingleChildScrollView(
              child: SizedBox(
                height: screenHeight,
                child: Stack(
                  children: [
                    /// 로고
                    Positioned(
                      top: screenHeight * 0.02,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Image.asset(
                          "assets/icon/logo.png",
                          height: screenHeight * 0.45,
                        ),
                      ),
                    ),

                    ///마법사 + 입력 필드 + 버튼 묶음
                    Positioned(
                      top: screenHeight * 0.3,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          /// 마법사 아이콘
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: 55,
                                left: 20,
                                child: Transform.rotate(
                                  angle: -10 * 3.1415927 / 180,
                                  child: Image.asset(
                                    "assets/icon/wizard.png",
                                    width: screenWidth * 0.18,
                                  ),
                                ),
                              ),


                              /// 입력 필드 묶음
                              Padding(
                                padding: const EdgeInsets.only(top: 120.0),
                                child: Column(
                                  children: [
                                    /// ID
                                    FractionallySizedBox(
                                      widthFactor: 0.85,
                                      child: TextField(
                                        controller: _emailTextController,
                                        decoration: InputDecoration(
                                          prefixIcon:
                                          const Icon(Icons.account_circle),
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'ID',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    /// Password
                                    FractionallySizedBox(
                                      widthFactor: 0.85,
                                      child: TextField(
                                        controller: _passwordTextController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          filled: true,
                                          fillColor: Colors.white,
                                          labelText: 'PASSWORD',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 15),

                                    /// 회원가입 / 비밀번호 찾기
                                    FractionallySizedBox(
                                      widthFactor: 0.85,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () => context.go('/signup'),
                                            child: Text("회원가입",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ),
                                          Text(" | "),
                                          GestureDetector(
                                            onTap: () {
                                              print("비밀번호 찾기 클릭");
                                            },
                                            child: Text("비밀번호 찾기",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 80),

                                    /// 로그인 버튼
                                    GestureDetector(
                                      onTap: () async {
                                        print(_emailTextController.text);
                                        print(_passwordTextController.text);
                                        await context.read<AuthCubit>().login(
                                          _emailTextController.text,
                                          _passwordTextController.text
                                        );

                                        print(context.read<AuthCubit>().state.authStatus);

                                        if(context.read<AuthCubit>().state.authStatus == AuthStatus.complete) {
                                          context.go("/");
                                        } else if(context.read<AuthCubit>().state.authStatus == AuthStatus.error) {
                                          _showFailedDialog(context);
                                        }
                                      },
                                      child: FractionallySizedBox(
                                        widthFactor: 0.85,
                                        child: Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFB386FF),
                                            borderRadius:
                                            BorderRadius.circular(20.0),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              "로그인",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 310,
                                right: 20,
                                child: Transform.rotate(
                                  angle: -10 * 3.1415927 / 180,
                                  child: Image.asset(
                                    "assets/icon/fairy.png",
                                    width: screenWidth * 0.18,
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFailedDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          Future.delayed(const Duration(seconds: 3), () {
            if(Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          });

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // 모서리 둥글게
            ),
            backgroundColor: BG_COLOR,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset("assets/lottie/failed.json",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text(" 로그인 실패 ",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Y_TEXT_COLOR
                  ),
                ),
                Text("힝.. 로그인에 실패했어...",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: TEXT_COLOR
                  ),
                ),
                Text("다시 시도해봐!!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: TEXT_COLOR
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}
