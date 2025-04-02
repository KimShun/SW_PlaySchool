import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            // 배경 이미지
            Opacity(
              opacity: 0.3,
              child: Image.asset("assets/background/login_bg.png"),
            ),

            // 로고 이미지
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Image.asset(
                "assets/icon/logo.png",
                height: 400,
              ),
            ),

            // 마법사 아이콘
            Positioned(
              left: MediaQuery.of(context).size.width * 0.12,
              top: MediaQuery.of(context).size.width * 0.81,
              child: Transform.rotate(
                angle: -10 * 3.1415927 / 180,
                child: Image.asset(
                  "assets/icon/wizard.png",
                  width: 60,
                  height: 60,
                ),
              ),
            ),

            // 입력 필드 + 버튼 영역
            Positioned(
              top: 380,
              left: 20,
              right: 20,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 아이디 입력칸
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        suffixIcon: Icon(Icons.close),
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey[500]),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: 'ID',
                      ),
                    ),
                    SizedBox(height: 30),

                    // 패스워드 입력칸
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: Icon(Icons.visibility_off),
                        fillColor: Colors.white,
                        filled: true,
                        labelStyle: TextStyle(color: Colors.grey[500]),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelText: 'PASSWORD',
                      ),
                    ),

                    SizedBox(height: 10),

                    // 회원가입 & 비밀번호 찾기
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            context.go('/signup');
                          },
                          child: Text(
                            "회원가입",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(" | ", style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,)),
                        GestureDetector(
                          onTap: () {
                            print("비밀번호 찾기 클릭");
                          },
                          child: Text(
                            "비밀번호 찾기",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 70),

                    // 로그인 버튼
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: Container(
                        height: 55,
                        width: 320,
                        padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Color(0xFFB386FF),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            "로그인",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 요정 아이콘
            Positioned(
              right: MediaQuery.of(context).size.width * 0.08,  // 오른쪽 여백 조정
              bottom: MediaQuery.of(context).size.width * 0.45, // 하단 위치 조정
              child: Transform.translate(
                offset: Offset(0, -25),
                child: Transform.rotate(
                  angle: -10 * 3.1415927 / 180,
                  child: Image.asset(
                    "assets/icon/fairy.png",
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
