import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/games/dance/cubit/danceCubit.dart';
import 'package:playschool/src/games/dance/repository/danceList.dart';
import 'package:video_player/video_player.dart';

import '../../common/component/color.dart';
import '../../common/detailGame/gameInfo.dart';

class SelectDanceScreen extends StatelessWidget {
  final GameData gameData;

  const SelectDanceScreen({
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
                _SelectDanceHeader(gameData: gameData,),
                _danceListPart(gameData: gameData,),
                Divider(
                  color: EXERCISE_STROKE_COLOR,
                  indent: 26,
                  endIndent: 26,
                ),
                _SelfDancePart()
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SelectDanceHeader extends StatelessWidget {
  final GameData gameData;

  const _SelectDanceHeader({
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
                  const SizedBox(height: 40),
                  Center(
                    child: Image.asset("assets/icon/dance.png",
                      width: 90,
                      height: 90,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("신나게 춤을 따라해보자!",
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

class _danceListPart extends StatelessWidget {
  final GameData gameData;

  const _danceListPart({
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
              Text("율동 목록",
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
                itemCount: danceList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await context.read<DanceCubit>().loadVideo(danceList[index].videoPath);
                      bool? check = await _showCheckDialog(context, danceList[index].danceName, danceList[index].videoPath, danceList[index].copyRight);

                      if (check == true) {
                        context.push("/playDance", extra: danceList[index]);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: gameData.gameType == GameType.play
                              ? PLAY_STROKE_COLOR : gameData.gameType == GameType.ent
                              ? EXERCISE_STROKE_COLOR : MAKE_STROKE_COLOR, width: 2),
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset("assets/icon/spotlight.png",
                                  width: 100,
                                  height: 100,
                                ),
                                Positioned(
                                  top: 27,
                                  left: 15,
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.white10,
                                    backgroundImage: AssetImage(danceList[index].iconPath),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 5.0),
                            Text(danceList[index].danceName,
                              style: TextStyle(
                                color: EXERCISE_TEXT_COLOR,
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

  Future<bool?> _showCheckDialog(BuildContext context, String danceName, String videoPath, String copyRight) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // 모서리 둥글게
          ),
          backgroundColor: BG_COLOR,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 400,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: VideoPlayer(context.read<DanceCubit>().state.videoController!),
              ),
              const SizedBox(height: 20),
              Text(danceName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: EXERCISE_TEXT_COLOR
                ),
              ),
              const SizedBox(height: 10),
              Text("이 율동으로 놀아볼까??",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: TEXT_COLOR
                ),
              ),
              Text(copyRight,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                  color: TEXT_COLOR
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.read<DanceCubit>().videoDispose();
                Navigator.of(context).pop(false);
              },
              child: Text("취소", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("확인", style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      }
    );
  }
}

class _SelfDancePart extends StatelessWidget {
  const _SelfDancePart({super.key});

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
                Text("원하는 춤이 없어?? \n가지고 있는 영상으로 놀아보자~!",
                  style: TextStyle(
                    color: EXERCISE_TEXT_COLOR,
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
