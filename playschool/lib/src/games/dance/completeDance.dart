import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: needsSafeArea ? 0 : 15.0),
              child: Column(
                children: [
                  _Header(danceInfo: DanceInfo(
                    iconPath: "assets/dance/icon/bunny.png",
                    danceName: "산토끼 토끼야",
                    videoPath: "",
                    copyRight: "",
                  )),
                  const SizedBox(height: 15),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final DanceInfo danceInfo;

  const _Header({
    super.key,
    required this.danceInfo
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
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
    );
  }
}