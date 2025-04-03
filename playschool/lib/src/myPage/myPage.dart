import 'package:dotted_border/dotted_border.dart';
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
                _BestPlayShow(),
                // 추천하는 게임 영역
                _RecommendGameContent()
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
    bool hasSafeArea(BuildContext context) {
      final padding = MediaQuery.of(context).padding;
      return padding.top > 20;
    }

    bool needsSafeArea = hasSafeArea(context);

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
          padding: EdgeInsets.symmetric(horizontal: 26.0, vertical: needsSafeArea ? 0 : 18.0),
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
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.width * 0.1,
          left: MediaQuery.of(context).size.width * 0.25,
          child: Image.asset("assets/icon/shooting-star.png",
            width: 45,
            height: 45,
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.075,
          right: MediaQuery.of(context).size.width * 0.14,
          child: Image.asset("assets/icon/unicorn.png",
            width: 40,
            height: 40,
          )
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 26.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage("assets/icon/duck.png"),
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
                        backgroundColor: const Color(0xFFD9D9D9),
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
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.17,
          left: MediaQuery.of(context).size.width * -0.08,
          child: Transform.rotate(
            angle: 20 * 3.1415927 / 180,
            child: Image.asset("assets/icon/star.png",
              width: 60,
              height: 60,
            ),
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.05,
          left: MediaQuery.of(context).size.width * 0.45,
          child: Transform.rotate(
            angle: 340 * 3.1415927 / 180,
            child: Image.asset("assets/icon/star.png",
              width: 40,
              height: 40,
            ),
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.23,
          right: MediaQuery.of(context).size.width * -0.07,
          child: Transform.rotate(
            angle: 340 * 3.1415927 / 180,
            child: Image.asset("assets/icon/star.png",
              width: 65,
              height: 65,
            ),
          )
        )
      ],
    );
  }
}

class _BestPlayShow extends StatelessWidget {
  const _BestPlayShow({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 3.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // 2등
                  Column(
                    children: [
                      DottedBorder(
                        color: const Color(0xFF4A4A4A),
                        borderType: BorderType.Circle,
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: Color(0xFFD9D9D9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("8 게임",
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                  // 1등
                  Column(
                    children: [
                      DottedBorder(
                        color: const Color(0xFF4A4A4A),
                        borderType: BorderType.Circle,
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFD9D9D9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("10 게임",
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                  // 3등
                  Column(
                    children: [
                      DottedBorder(
                        color: const Color(0xFF4A4A4A),
                        borderType: BorderType.Circle,
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundColor: Color(0xFFD9D9D9),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("5 게임",
                        style: TextStyle(
                          color: TEXT_COLOR,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              Text("'-------'를 제일 많이 놀았어~! ^^",
                style: TextStyle(
                  color: MYPAGE_TEXT_S_COLOR,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.08,
          left: MediaQuery.of(context).size.width * 0.23,
          child: Image.asset("assets/icon/medal (1).png",
            width: 43,
            height: 43,
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.06,
          left: MediaQuery.of(context).size.width * 0.54,
          child: Image.asset("assets/icon/medal.png",
            width: 45,
            height: 45,
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.11,
          right: MediaQuery.of(context).size.width * 0.085,
          child: Image.asset("assets/icon/medal (2).png",
            width: 40,
            height: 40,
          )
        ),
        Positioned(
          top: MediaQuery.of(context).size.width * 0.3,
          left: MediaQuery.of(context).size.width * -0.02,
          child: Transform.rotate(
            angle: 10 * 3.1415927 / 180,
            child: Image.asset("assets/icon/confetti.png",
              width: 60,
              height: 60,
            ),
          )
        ),
        Positioned(
            top: MediaQuery.of(context).size.width * 0.02,
            right: MediaQuery.of(context).size.width * -0.05,
            child: Transform.flip(
              flipX: true,
              child: Transform.rotate(
                angle: 10 * 3.1415927 / 180,
                child: Image.asset("assets/icon/confetti.png",
                  width: 60,
                  height: 60,
                ),
              ),
            )
        )
      ],
    );
  }
}

class _RecommendGameContent extends StatelessWidget {
  const _RecommendGameContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset("assets/icon/recommend.png",
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Text("추천하는 게임",
                style: TextStyle(
                  color: MYPAGE_STROKE_COLOR,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _gamePlayBtn("assets/icon/dance.jpg", "율동 따라하기"),
              const SizedBox(width: 20),
              _gamePlayBtn("assets/icon/drawPainting.webp", "그림 그리기"),
            ],
          )
        ],
      ),
    );
  }

  Widget _gamePlayBtn(String iconPath, String titleName) {
    return SizedBox(
      width: 90,
      height: 130,
      child: Column(
        children: [
          Stack(
            children: [
              DottedBorder(
                color: const Color(0xFF000000),
                borderType: BorderType.Circle,
                child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(iconPath)
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(titleName,
            style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 14.0,
                fontWeight: FontWeight.w600
            ),
          )
        ],
      ),
    );
  }
}