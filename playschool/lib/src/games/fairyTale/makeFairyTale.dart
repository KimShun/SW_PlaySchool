import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/games/fairyTale/repository/fairyTaleList.dart';

import '../../common/component/color.dart';
import '../../common/detailGame/gameInfo.dart';

class MakeFairyTaleScreen extends StatelessWidget {
  final GameData gameData;

  const MakeFairyTaleScreen({
    super.key,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.15,
            child: Image.asset("assets/background/main_bg.png")
          ),
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                _MakeFairyTaleHeader(gameData: gameData,),
                _fairyListPart(gameData: gameData,),
                Divider(
                  color: MAKE_STROKE_COLOR,
                  indent: 26,
                  endIndent: 26,
                ),
                _SelfFairyTalePart()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _MakeFairyTaleHeader extends StatelessWidget {
  final GameData gameData;

  const _MakeFairyTaleHeader({
    super.key,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    bool hasSafeArea(BuildContext context) {
      final padding = MediaQuery.of(context).padding;
      return padding.top > 20;
    }

    bool needsSafeArea = hasSafeArea(context);

    return Container(
      decoration: BoxDecoration(
        color: gameData.gameType == GameType.play
            ? PLAY_HEADER_COLOR : gameData.gameType == GameType.ent
            ? EXERCISE_HEADER_COLOR : MAKE_HEADER_COLOR,
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
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset("assets/icon/exit.png",
                  width: 40,
                  height: 40,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 15),
                  Center(
                    child: Image.asset("assets/icon/black-cat.png",
                      width: 45,
                      height: 45,
                    ),
                  ),
                  Image.asset("assets/icon/fairytale.png",
                    width: 90,
                    height: 90,
                  ),
                  const SizedBox(height: 20),
                  Text("나만의 이야기, 모험을 만들어 보자!",
                    style: TextStyle(
                        color: gameData.gameType == GameType.play
                            ? Y_TEXT_COLOR : gameData.gameType == GameType.ent
                            ? EXERCISE_TEXT_COLOR : MAKE_TEXT_COLOR,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _fairyListPart extends StatelessWidget {
  final GameData gameData;

  const _fairyListPart({
    super.key,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset("assets/icon/reading.png",
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Text("동화 목록",
                style: TextStyle(
                  color: Y_TEXT_COLOR,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: SizedBox(
              height: 350,
              child: GridView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.2
                ),
                itemCount: fairyTaleList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.push("/selectFairyTaleBook", extra: fairyTaleList[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: MAKE_STROKE_COLOR, width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            Image.asset(fairyTaleList[index].iconPath,
                              width: 70,
                              height: 70,
                            ),
                            Align(
                              alignment: Alignment.center,
                              heightFactor: 0.5,
                              child: Image.asset("assets/icon/open-book-side-view.png",
                                width: 70,
                                height: 70,
                              ),
                            ),
                            Text(fairyTaleList[index].fiaryName,
                              style: TextStyle(
                                color: MAKE_TEXT_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _SelfFairyTalePart extends StatelessWidget {
  const _SelfFairyTalePart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 20.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset("assets/icon/father.png",
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Text("직접 만들기",
                style: TextStyle(
                  color: Y_TEXT_COLOR,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 15.0),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icon/question.png",
                  width: 85,
                  height: 85,
                ),
                const SizedBox(width: 10.0),
                Text("원하는 주제가 없어?? \n직접 동화의 주제를 만들 수 있어!!",
                  style: TextStyle(
                      color: MAKE_TEXT_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
