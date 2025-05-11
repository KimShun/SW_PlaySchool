import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/games/dance/repository/danceList.dart';

class CompleteDanceScreen extends StatelessWidget {
  // final DanceInfo danceInfo;

  const CompleteDanceScreen({
    super.key,
    // required this.danceInfo,
  });

  @override
  Widget build(BuildContext context) {
    bool hasSafeArea(BuildContext context) {
      final padding = MediaQuery.of(context).padding;
      return padding.top > 20;
    }

    bool needsSafeArea = hasSafeArea(context);

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
                // 상단 영역
                _Header(needsSafeArea: needsSafeArea, danceInfo: DanceInfo(
                  iconPath: "assets/dance/icon/bunny.png",
                  danceName: "산토끼 토끼야",
                  videoPath: "",
                  copyRight: "",
                )),
                const SizedBox(height: 10),
                // 별 점수 영역
                _StarScore(),
                const SizedBox(height: 15),
                // 평가 내용
                _AssessmentContent(),
                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final bool needsSafeArea;
  final DanceInfo danceInfo;

  const _Header({
    super.key,
    required this.needsSafeArea,
    required this.danceInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: needsSafeArea ? 0 : 15.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: EXERCISE_HEADER_COLOR,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: EXERCISE_STROKE_COLOR,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(danceInfo.iconPath),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(danceInfo.danceName,
                                  style: TextStyle(
                                    color: EXERCISE_TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0
                                  ),
                                ),
                                Text("신나게 춤을 따라해보자!!",
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.0
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    DottedBorder(
                        color: EXERCISE_STROKE_COLOR,
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(30),
                        child: Container(
                          height: 210,
                          decoration: BoxDecoration(
                            color: EXERCISE_CARD_COLOR,
                            borderRadius: BorderRadius.circular(30)
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.035,
              right: MediaQuery.of(context).size.width * 0.035,
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: Image.asset("assets/icon/exit.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StarScore extends StatelessWidget {
  const _StarScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _StarIconThree(),
            const SizedBox(height: 10.0),
            Text("💕 점수: 80점 💕",
              style: TextStyle(
                  color: EXERCISE_TEXT_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            Text("굉장해!! 너 소질이 있구나~!!",
              style: TextStyle(
                  color: TEXT_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0
              ),
            )
          ],
        ),
        Positioned(
          top: -30,
          left: -40,
          child: Lottie.asset("assets/lottie/confetti.json",
              width: 160,
              height: 160
          ),
        ),
        Positioned(
          top: -10,
          right: -40,
          child: Transform.rotate(
            angle: 275 * 3.1415927 / 180,
            child: Lottie.asset("assets/lottie/confetti.json",
                width: 160,
                height: 160
            ),
          ),
        ),
      ],
    );
  }

  Widget _StarIconOne() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Transform.rotate(
            angle: 270 * 3.1415927 / 180,
            child: Image.asset("assets/icon/favourite (1).png",
              width: 65,
              height: 65,
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Image.asset("assets/icon/favourite.png",
          width: 65,
          height: 65,
        ),
        const SizedBox(width: 20.0),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Transform.rotate(
            angle: 90 * 3.1415927 / 180,
            child: Image.asset("assets/icon/favourite.png",
              width: 65,
              height: 65,
            ),
          ),
        ),
      ],
    );
  }

  Widget _StarIconTwo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Transform.rotate(
            angle: 270 * 3.1415927 / 180,
            child: Image.asset("assets/icon/favourite (1).png",
              width: 65,
              height: 65,
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Image.asset("assets/icon/favourite (1).png",
          width: 65,
          height: 65,
        ),
        const SizedBox(width: 20.0),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Transform.rotate(
            angle: 90 * 3.1415927 / 180,
            child: Image.asset("assets/icon/favourite.png",
              width: 65,
              height: 65,
            ),
          ),
        ),
      ],
    );
  }

  Widget _StarIconThree() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Transform.rotate(
            angle: 270 * 3.1415927 / 180,
            child: Image.asset("assets/icon/favourite (1).png",
              width: 65,
              height: 65,
            ),
          ),
        ),
        const SizedBox(width: 20.0),
        Image.asset("assets/icon/favourite (1).png",
          width: 65,
          height: 65,
        ),
        const SizedBox(width: 20.0),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Transform.rotate(
            angle: 90 * 3.1415927 / 180,
            child: Image.asset("assets/icon/favourite (1).png",
              width: 65,
              height: 65,
            ),
          ),
        ),
      ],
    );
  }
}

class _AssessmentContent extends StatelessWidget {
  const _AssessmentContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/icon/good-feedback.png",
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Text("평가 내용",
                style: TextStyle(
                  color: Y_TEXT_COLOR,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 20.0),
          // 정확도
          _percentAssessment(1.0, "100점", "정확도", "자세가 아주 정확해~ 대단해!!"),
          const SizedBox(height: 20.0),
          // 열정적
          _percentAssessment(0.7, "70점", "열정적", "훌륭하게 춤을 췄어!! 멋있당~"),
        ],
      ),
    );
  }

  Widget _percentAssessment(double percent, String percentName, String name, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 15.0),
        CircularPercentIndicator(
          radius: 50.0,
          animation: true,
          animationDuration: 1200,
          lineWidth: 8.0,
          percent: percent,
          center: Text(percentName,
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: EXERCISE_TEXT_COLOR,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          circularStrokeCap: CircularStrokeCap.butt,
          backgroundColor: Colors.black12,
          progressColor: EXERCISE_HEADER_COLOR,
        ),
        const SizedBox(width: 15.0),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
              style: TextStyle(
                color: Y_TEXT_COLOR,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Text(content,
              style: TextStyle(
                color: TEXT_COLOR,
                fontSize: 15.0,
              ),
            )
          ],
        )
      ],
    );
  }
}
