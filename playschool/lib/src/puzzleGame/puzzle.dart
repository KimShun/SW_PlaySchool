import 'package:flutter/material.dart';
import 'package:playschool/src/common/component/color.dart';

class PuzzleGame extends StatelessWidget {
  const PuzzleGame({super.key});

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
                                        Image.asset("assets/icon/exit.png",
                                          width: 40,
                                          height: 40,
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
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFD9D9D9),
                                    border: Border.all(color: Colors.black, width: 1)
                                  ),
                                ),
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFD9D9D9),
                                      border: Border.all(color: Colors.black, width: 1)
                                  ),
                                ),
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFD9D9D9),
                                      border: Border.all(color: Colors.black, width: 1)
                                  ),
                                ),
                                Container(
                                  width: 65,
                                  height: 65,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFD9D9D9),
                                      border: Border.all(color: Colors.black, width: 1)
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {},
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
      ),
    );
  }
}