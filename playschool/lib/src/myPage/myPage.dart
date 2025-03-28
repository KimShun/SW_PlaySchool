import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:playschool/src/common/component/color.dart';

class MyPageScreen extends StatelessWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.15,
            child: Image.asset("assets/background/main_bg.png"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                // Header 영역
                _MyPageHeader(),
                // Level 영역
                _MyPageLevelPart(),
                // 경계선
                Divider(
                  color: MYPAGE_STROKE_COLOR,
                  indent: 26,
                  endIndent: 26,
                ),
                // 많이 플레이 영역
                
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MyPageHeader extends StatelessWidget {
  const _MyPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MYPAGE_HEADER_COLOR,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30)
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 18.0),
          child: Stack(
            children: [
              Image.asset("assets/icon/exit.png",
                width: 40,
                height: 40,
              ),
              Center(
                child: Image.asset("assets/icon/kitty.png",
                  width: 50,
                  height: 50,
                ),
              ),
              Positioned(
                  top: MediaQuery.of(context).size.width * 0.05,
                  left: MediaQuery.of(context).size.width * 0.23,
                  child: Transform.rotate(
                    angle: 330 * 3.1415927 / 180,
                    child: Image.asset("assets/icon/dog.png",
                      width: 50,
                      height: 50,
                    ),
                  )
              ),
              Column(
                children: [
                  const SizedBox(height: 33),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: MYPAGE_STROKE_COLOR, width:1),
                        ),
                        child: const CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage("assets/icon/IMG_3332.jpg"),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("아기토끼짱",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/icon/happy-birthday.png",
                            width: 52,
                            height: 52,
                          ),
                          const SizedBox(width: 10),
                          Text("2001년 8월 18일",
                            style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MyPageLevelPart extends StatelessWidget {
  const _MyPageLevelPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.width * 0.05,
            left: MediaQuery.of(context).size.width * 0.17,
            child: Image.asset("assets/icon/shooting-star.png",
              width: 45,
              height: 45,
            )
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 0.006,
            right: MediaQuery.of(context).size.width * 0.05,
            child: Image.asset("assets/icon/unicorn.png",
              width: 40,
              height: 40,
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: MYPAGE_STROKE_COLOR, width:1),
                ),
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
              ),
              SizedBox(
                width: 130,
                height: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Lv.1",
                            style: TextStyle(
                                color: MYPAGE_STROKE_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0
                            ),
                          ),
                          Text("5 / 5",
                            style: TextStyle(
                                color: MYPAGE_TEXT_S_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Container(
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(color: MYPAGE_STROKE_COLOR, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: LinearProgressBar(
                        maxSteps: 5,
                        progressType: LinearProgressBar.progressTypeLinear,
                        currentStep: 2,
                        progressColor: MYPAGE_TEXT_S_COLOR,
                        backgroundColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        valueColor: AlwaysStoppedAnimation<Color>(MYPAGE_TEXT_S_COLOR),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text("병아리~ 삐약! 삐약!",
                      style: TextStyle(
                          color: TEXT_COLOR,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: MYPAGE_STROKE_COLOR, width: 1),
                      borderRadius: BorderRadius.circular(15),
                      color: MYPAGE_TEXT_S_COLOR
                  ),
                  child: const Center(
                    child: Text("UP!!",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
