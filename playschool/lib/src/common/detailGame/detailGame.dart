import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/common/detailGame/gameInfo.dart';
import 'package:go_router/go_router.dart';

class DetailGameScreen extends StatelessWidget {
  final GameData gameData;

  const DetailGameScreen({
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
                  _detailHeader(gameData: gameData),
                  const SizedBox(height: 15),
                  _detailButtons(gameData: gameData),
                  const SizedBox(height: 15),
                  _detailDescription(gameData: gameData),
                  const SizedBox(height: 15),
                  _detailPreview(gameData: gameData),
                  const SizedBox(height: 15),
                  _detailDifficult(gameData: gameData),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _detailHeader extends StatelessWidget {
  final GameData gameData;

  const _detailHeader({
    super.key,
    required this.gameData
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
              color: gameData.gameType == GameType.play
                ? PLAY_HEADER_COLOR : gameData.gameType == GameType.ent
                ? EXERCISE_HEADER_COLOR : MAKE_HEADER_COLOR,
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
                                color: gameData.gameType == GameType.play
                                  ? PLAY_STROKE_COLOR : gameData.gameType == GameType.ent
                                  ? EXERCISE_STROKE_COLOR : MAKE_STROKE_COLOR,
                                width:1
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: AssetImage(gameData.gameIconPath),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(gameData.name,
                                style: TextStyle(
                                    color: gameData.gameType == GameType.play
                                      ? Y_TEXT_COLOR : gameData.gameType == GameType.ent
                                      ? EXERCISE_TEXT_COLOR : MAKE_TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0
                                ),
                              ),
                              Text(gameData.shortDetail,
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
                      color: gameData.gameType == GameType.play
                          ? PLAY_STROKE_COLOR : gameData.gameType == GameType.ent
                          ? EXERCISE_STROKE_COLOR : MAKE_STROKE_COLOR,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(30),
                      child: Container(
                        height: 210,
                        decoration: BoxDecoration(
                            color: gameData.gameType == GameType.play
                                ? PLAY_CARD_COLOR : gameData.gameType == GameType.ent
                                ? EXERCISE_CARD_COLOR : MAKE_CARD_COLOR,
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
                Navigator.of(context).pop();
              },
              child: Image.asset("assets/icon/exit.png",
                width: 40,
                height: 40,
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.width * 0.28,
            right: MediaQuery.of(context).size.width * 0.015,
            child: Transform.rotate(
              angle: 30 * 3.1415927 / 180,
              child: Image.asset("assets/icon/ribbon.png",
                width: 50,
                height: 50,
              ),
            )
          )
        ],
      ),
    );
  }
}

class _detailButtons extends StatelessWidget {
  final GameData gameData;
  const _detailButtons({
    super.key,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  final Map<String, String> gameRouteMap = {
                    "그림 그리기": "/drawingGame",
                    "단어 맞추기": "/word_matching",
                    "틀린그림찾기": "",
                    "율동 따라하기": "/selectDance",
                    "동화책 만들기": "/makeFairyTaleBook",
                  };

                  final route = gameRouteMap[gameData.name];
                  if (route != null) {
                    context.push(route, extra: gameData);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("이 게임은 아직 준비 중이에요!")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  side: BorderSide(
                      color: gameData.gameType == GameType.play
                          ? PLAY_STROKE_COLOR : gameData.gameType == GameType.ent
                          ? EXERCISE_STROKE_COLOR : MAKE_STROKE_COLOR,
                      width: 1
                  ),
                  backgroundColor: gameData.gameType == GameType.play
                      ? PLAY_BTN_COLOR : gameData.gameType == GameType.ent
                      ? EXERCISE_BTN_COLOR : MAKE_BTN_COLOR,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow, color: Colors.white, size: 23),
                      SizedBox(width: 5),
                      Text("놀이하기",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // 모서리 둥글게
                  ),
                  side: BorderSide(
                    color: gameData.gameType == GameType.play
                        ? PLAY_STROKE_COLOR : gameData.gameType == GameType.ent
                        ? EXERCISE_STROKE_COLOR : MAKE_STROKE_COLOR,
                    width: 1
                  ),
                  backgroundColor: gameData.gameType == GameType.play
                    ? PLAY_MORE_COLOR : gameData.gameType == GameType.ent
                    ? EXERCISE_MORE_COLOR : MAKE_MORE_COLOR,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Row(
                    children: [
                      Icon(Icons.more_horiz,
                        color: Colors.white,
                        size: 23,
                      ),
                    ],
                  ),
                )
            )
          ],
        ),
        const SizedBox(height: 10),
        const Text("⚠️ 안전을 위해, 부모님의 조언과 지도가 필요할 수 있습니다.",
          style: TextStyle(
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}

class _detailDescription extends StatelessWidget {
  final GameData gameData;
  const _detailDescription({
    super.key,
    required this.gameData
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset("assets/icon/game.png",
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 15),
            Text("게임설명",
              style: TextStyle(
                color: gameData.gameType == GameType.play
                  ? Y_TEXT_COLOR : gameData.gameType == GameType.ent
                  ? EXERCISE_TEXT_COLOR : MAKE_TEXT_COLOR,
                fontSize: 25.0,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Text(gameData.longDetail,
          style: TextStyle(
              color: TEXT_COLOR,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}

class _detailPreview extends StatelessWidget {
  final GameData gameData;
  const _detailPreview({
    super.key,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset("assets/icon/search.png",
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 15),
            Text("미리보기",
              style: TextStyle(
                  color: gameData.gameType == GameType.play
                    ? Y_TEXT_COLOR : gameData.gameType == GameType.ent
                    ? EXERCISE_TEXT_COLOR : MAKE_TEXT_COLOR,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Container(
                  width: 110,
                  decoration: BoxDecoration(
                      color: gameData.gameType == GameType.play
                        ? PLAY_CARD_COLOR : gameData.gameType == GameType.ent
                        ? EXERCISE_CARD_COLOR : MAKE_CARD_COLOR,
                      border: Border.all(
                        color: gameData.gameType == GameType.play
                          ? PLAY_STROKE_COLOR : gameData.gameType == GameType.ent
                          ? EXERCISE_STROKE_COLOR : MAKE_STROKE_COLOR,
                        width: 1
                      ),
                      borderRadius: BorderRadius.circular(20)
                  ),
                );
              }
          ),
        )
      ],
    );
  }
}

class _detailDifficult extends StatelessWidget {
  final GameData gameData;
  const _detailDifficult({
    super.key,
    required this.gameData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Image.asset("assets/icon/difficulty.png",
              width: 50,
              height: 50,
            ),
            const SizedBox(width: 15),
            Text("게임 난이도",
              style: TextStyle(
                color: gameData.gameType == GameType.play
                  ? Y_TEXT_COLOR : gameData.gameType == GameType.ent
                  ? EXERCISE_TEXT_COLOR : MAKE_TEXT_COLOR,
                fontSize: 25.0,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            ...List.generate(gameData.gameLevel, (index) =>
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.asset("assets/icon/favourite (1).png",
                    width: 45, height: 45,
                  ),
                )),
            ...List.generate(5-gameData.gameLevel, (index) =>
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.asset("assets/icon/favourite.png",
                    width: 45, height: 45,
                  ),
                ))
          ],
        ),
        const SizedBox(height: 10),
        Text("연령에 관계없이 누구나 재미있게 즐길 수 있어요!!",
          style: TextStyle(
              color: gameData.gameType == GameType.play
                ? PLAY_STROKE_COLOR : gameData.gameType == GameType.ent
                ? EXERCISE_STROKE_COLOR : MAKE_STROKE_COLOR,
              fontSize: 13.0,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}
