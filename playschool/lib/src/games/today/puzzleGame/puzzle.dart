import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:playschool/src/common/component/color.dart';

import 'cubit/puzzleCubit.dart';

class PuzzleGame extends StatelessWidget {
  const PuzzleGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: BlocListener<PuzzleCubit, PuzzleState>(
        listener: (context, state) {
          if (state.status == PuzzleStatus.completed) {
            _showVictoryDialog(context);
          }
        },
        child: BlocBuilder<PuzzleCubit, PuzzleState>(
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
                                                  context.read<PuzzleCubit>().pauseBGM();
                                                  Navigator.of(context).pop();
                                                },
                                                child: Image.asset("assets/icon/exit.png",
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text("퍼즐 맞추기 ^o^",
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
                                            child: DragTarget<int>(
                                              onAcceptWithDetails: (details) {},
                                              builder: (context, candidateData, rejectedData) {
                                                return Stack(
                                                  children: List.generate(state.imagePieces!.length, (index) {
                                                    int x = (index % 2) * 150;
                                                    int y = (index ~/ 2) * 150;

                                                    return Positioned(
                                                      left: x.toDouble(),
                                                      top: y.toDouble(),
                                                      child: DragTarget<int>(
                                                        onAcceptWithDetails: (details) {
                                                          int draggedIndex = details.data;
                                                          int originalIndex = state.answerMapping![draggedIndex]!;

                                                          // print("Dragged: $draggedIndex, Should be at: $originalIndex, Dropped at: $index");
                                                          if(originalIndex == index) {
                                                            context.read<PuzzleCubit>().updatePlacedPiece(index);
                                                          }

                                                          context.read<PuzzleCubit>().checkPuzzleCompletion();
                                                        },
                                                        builder: (context, candidateData, rejectedData) {
                                                          if(state.placedPieces![index] == true) {
                                                            return SizedBox(
                                                              width: 150,
                                                              height: 150,
                                                              child: RawImage(
                                                                image: state.imagePieces![state.answerMapping!.keys.firstWhere((k) => state.answerMapping![k] == index)]
                                                              )
                                                            );
                                                          } else {
                                                            return Container(
                                                              width: 150,
                                                              height: 150,
                                                              decoration: BoxDecoration(
                                                                  border: Border.all(color: Colors.orange, width: 1)
                                                              ),
                                                            );
                                                          }
                                                        }
                                                      )
                                                    );
                                                  }),
                                                );
                                              }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Image.asset("assets/icon/pencilKitty.png",
                                        width: 55,
                                        height: 55,
                                      ),
                                      const SizedBox(width: 20),
                                      Image.asset("assets/icon/ducky.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                    ],
                                  ),
                                  Image.asset("assets/icon/kitty2.png",
                                    width: 55,
                                    height: 55,
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange[200],
                                  border: Border.all(color: PLAY_STROKE_COLOR, width: 2),
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ...List.generate(state.imagePieces!.length, (index) {
                                        return Draggable<int>(
                                          data: index,
                                          feedback: Container(
                                            width: 150,
                                            height: 150,
                                            child: RawImage(image: state.imagePieces![index]),
                                          ),
                                          childWhenDragging: Container(
                                            width: 65,
                                            height: 65,
                                            decoration: BoxDecoration(
                                                border: Border.all(color: Colors.black, width: 1)
                                            ),
                                          ),
                                          child: Container(
                                            width: 65,
                                            height: 65,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.black, width: 1),
                                            ),
                                            child: RawImage(image: state.imagePieces![index]),
                                          )
                                        );
                                      })
                                    ]
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 200,
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<PuzzleCubit>().loadImageUrl();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(color: Y_STROKE_COLOR, width: 1),
                                    backgroundColor: PLAY_CARD_COLOR,
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset("assets/icon/refresh2.png",
                                        width: 35,
                                        height: 35,
                                      ),
                                      const SizedBox(width: 10),
                                      Text("다시 맞추기~~",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Y_TEXT_COLOR
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                  Lottie.asset("assets/lottie/celebrate_cat.json",
                    width: 150,
                    height: 150,
                  ),
                  const SizedBox(height: 10),
                  Text("🎉 축하해~!! 🎉",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Y_TEXT_COLOR
                    ),
                  ),
                  Text("오늘의 게임 1단계를 통과했어!!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Y_TEXT_COLOR
                    ),
                  ),
                  Text("🧩퍼즐 맞추기",
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
                        context.read<PuzzleCubit>().loadImageUrl();
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
                        context.read<PuzzleCubit>().puzzleDone();
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
}

class PuzzlePainter extends CustomPainter {
  final ui.Image image;
  final double x, y, width, height;

  PuzzlePainter(this.image, this.x, this.y, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(x, y, width, height),  // 원본 이미지에서 잘라낼 영역
      Rect.fromLTWH(0, 0, size.width, size.height),  // Container 크기에 맞게 조정
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}