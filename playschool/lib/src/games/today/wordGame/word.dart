import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:playschool/src/authentication/cubit/userCubit.dart';
import 'package:playschool/src/authentication/repository/AuthRepository.dart';
import 'package:playschool/src/games/today/configure.dart';
import 'package:playschool/src/games/today/wordGame/cubit/wordCubit.dart';

import '../../../authentication/cubit/authCubit.dart';
import '../../../common/component/color.dart';
import '../../repository/GameRepository.dart';

class WordGameScreen extends StatelessWidget {
  const WordGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocListener<WordCubit, WordState>(
        listener: (context, state) async {
          if (state.status == WordStatus.completed) {
            if(!context.read<UserCubit>().state!.todayGame2) {
              await context.read<AuthRepository>().userExpUp(context, context.read<AuthCubit>().state.token!);
            }

            _showVictoryDialog(context);
            await context.read<GameRepository>().updateTodayGame(context, 2, context.read<AuthCubit>().state.token!);
          } else if (state.status == WordStatus.failed) {
            _showFailedDialog(context);
          }
        },
        child: BlocBuilder<WordCubit, WordState>(
          builder: (context, state) {
            return Stack(
              children: [
                Opacity(
                  opacity: 0.15,
                  child: Image.asset("assets/background/main_bg.png"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Y_HEADER_COLOR,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: MediaQuery.of(context).size.width * 0.18,
                                        left: MediaQuery.of(context).size.width * 0.22,
                                        child: Transform.rotate(
                                          angle: 10 * 3.1415927 / 180,
                                          child: Transform.flip(
                                            flipX: true,
                                            child: Image.asset("assets/icon/searching.png",
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                                        )
                                    ),
                                    Positioned(
                                        top: MediaQuery.of(context).size.width * 0.18,
                                        right: MediaQuery.of(context).size.width * 0.15,
                                        child: Transform.rotate(
                                          angle: 0 * 3.1415927 / 180,
                                          child: Image.asset("assets/icon/detective.png",
                                            width: 50,
                                            height: 50,
                                          ),
                                        )
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(26.0),
                                      child: Column(
                                        children: [
                                          Row(
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
                                              Expanded(
                                                child: Text("단어 맞추기 ^m^",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 25.0,
                                                      color: Y_TEXT_COLOR,
                                                      fontWeight: FontWeight.bold
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 50),
                                          Container(
                                            width: 300,
                                            height: 300,
                                            decoration: BoxDecoration(
                                                color: PLAY_CARD_COLOR,
                                                border: Border.all(color: PLAY_STROKE_COLOR, width: 2)
                                            ),
                                            child: Image.network(todayImage)
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 300,
                                child: GridView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 25,
                                      childAspectRatio: 2.7,
                                  ),
                                  itemCount: state.answerList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        context.read<WordCubit>().checking(state.answerList[index]);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: PLAY_CARD_COLOR,
                                          border: Border.all(color: Y_STROKE_COLOR, width: 2),
                                          borderRadius: BorderRadius.circular(30)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                                          child: Column(
                                            children: [
                                              Text(state.answerList[index],
                                                style: TextStyle(
                                                  color: Y_TEXT_COLOR,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }

  void _showVictoryDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Lottie.asset("assets/lottie/fireworks2.json"),
              AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16), // 모서리 둥글게
                ),
                backgroundColor: BG_COLOR,
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset("assets/lottie/celebrate_nuguri.json",
                      width: 180,
                      height: 180,
                    ),
                    const SizedBox(height: 10),
                    Text("🎉 축하해~!! 🎉",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Y_TEXT_COLOR
                      ),
                    ),
                    Text("오늘의 게임 2단계를 통과했어!!",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Y_TEXT_COLOR
                      ),
                    ),
                    Text("🃏단어 맞추기",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: TEXT_COLOR
                      ),
                    ),
                    Text("👍시도 횟수 : ${context.read<WordCubit>().state.tryCount}회",
                      style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          color: TEXT_COLOR
                      ),
                    )
                  ],
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.read<WordCubit>().loadGame();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "다시하기",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.orangeAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "확인",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        }
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
                Lottie.asset("assets/lottie/failed_animal.json",
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 10),
                Text("😢 틀렸어... ㅠㅠ 😢",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Y_TEXT_COLOR
                  ),
                ),
                Text("다시 한번 시도해봐!! 맞출 수 있어!!",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Y_TEXT_COLOR
                  ),
                ),
                Text("👍시도 횟수 : ${context.read<WordCubit>().state.tryCount}회",
                  style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.normal,
                      color: TEXT_COLOR
                  ),
                )
              ],
            ),
          );
        }
    );
  }
}
