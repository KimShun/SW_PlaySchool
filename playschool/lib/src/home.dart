import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:playschool/src/common/component/color.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                // Header 영역
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Y_HEADER_COLOR,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30)
                        ),
                      ),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _mainHeaderTop(),
                            _mainHeaderBottom()
                          ],
                        ),
                      ),
                    ),

                    // 클리어 시에 메달 아이콘 표시
                    Positioned(
                      left: MediaQuery.of(context).size.width * 0.30,
                      bottom: MediaQuery.of(context).size.width * 0.025,
                      child: Image.asset("assets/icon/award.png",
                        width: 45,
                        height: 45,
                      )
                    ),
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.13,
                      bottom: MediaQuery.of(context).size.width * 0.025,
                      child: Image.asset("assets/icon/award.png",
                        width: 45,
                        height: 45,
                      )
                    ),
                  ]
                ),

                // Search 영역
                Stack(
                  children: [
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.03,
                      top: MediaQuery.of(context).size.width * 0.015,
                      child: Transform.rotate(
                        angle: 10 * 3.1415927 / 180,
                        child: Image.asset("assets/icon/searchKids.png",
                          width: 60,
                          height: 60,
                        ),
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0, top: 40.0, bottom: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0ECDE),
                          border: Border.all(color: Y_STROKE_COLOR),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                          // controller: _controller,
                          style: const TextStyle(
                            color: Color(0xFF4A4A4A),
                            fontSize: 12,
                          ),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search,
                              size: 30,
                            ),
                            hintText: "찾고 싶은게 있으면 검색해봐~",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                // Content 영역
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, bottom: 32),
                  child: Column(
                    children: [
                      // 놀이터 영역
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("놀이터",
                            style: TextStyle(
                              color: Y_TEXT_COLOR,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              _gamePlayBtn("assets/icon/cardGame.jpg", "단어 맞추기", true),
                              const SizedBox(width: 20),
                              _gamePlayBtn("assets/icon/wrongPicture.jpg", "틀린그림찾기", true),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      // 예체능 영역
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("예체능",
                            style: TextStyle(
                              color: Y_TEXT_COLOR,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              _gamePlayBtn("assets/icon/dance.jpg", "율동 따라하기", true),
                              const SizedBox(width: 20),
                              _gamePlayBtn("assets/icon/drawPainting.webp", "그림 그리기", true),
                              const SizedBox(width: 20),
                              _gamePlayBtn("assets/icon/colorPaper.jpg", "색종이 접기", false),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      // 창작활동 영역
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("창작활동",
                            style: TextStyle(
                              color: Y_TEXT_COLOR,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              _gamePlayBtn("assets/icon/fairyTaleBook.jpg", "동화책 만들기", true),
                              const SizedBox(width: 20),
                              _gamePlayBtn("assets/icon/kidsSong.jpg", "동요 만들기", false),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }

  Widget _gamePlayBtn(String iconPath, String titleName, bool available) {
    return SizedBox(
      width: 90,
      height: 130,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {},
              child: Image.asset("assets/icon/ask.png",
                width: 20,
                height: 20,
              ),
            )
          ),
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
              if(!available)
                DottedBorder(
                  color: const Color(0xFF000000),
                  borderType: BorderType.Circle,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.withOpacity(0.5),
                    child: Image.asset("assets/icon/padlock.png",
                      width: 45,
                      height: 45
                    )
                  ),
                )
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

class _mainHeaderTop extends StatelessWidget {
  const _mainHeaderTop({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Y_STROKE_COLOR, width:1),
                ),
                child: const CircleAvatar(
                    radius: 33,
                    backgroundImage: AssetImage("assets/icon/IMG_3332.jpg")
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("아기토끼짱",
                    style: TextStyle(
                        color: Y_TEXT_COLOR,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text("안녕?! 오늘도 재밌게 놀아보자~!",
                    style: TextStyle(
                        color: TEXT_COLOR,
                        fontSize: 12.0,
                        fontWeight: FontWeight.normal
                    ),
                  )
                ],
              )
            ],
          ),

        ],
      ),
    );
  }
}

class _mainHeaderBottom extends StatelessWidget {
  const _mainHeaderBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 34, right: 34, top: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("오늘의 놀이",
            style: TextStyle(
              color: Y_TEXT_COLOR,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text("오늘은 어떤 놀이가 기다리고 있을까~?",
            style: TextStyle(
              color: TEXT_COLOR,
              fontSize: 12.0,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DottedBorder(
                  color: Y_STROKE_COLOR,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(20),
                  child: Container(
                    width: 132,
                    height: 89,
                    decoration: BoxDecoration(
                        color: PLAY_CARD_COLOR,
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
                Image.asset("assets/icon/right-arrow.png",
                  width: 20,
                  height: 20,
                ),
                DottedBorder(
                  color: Y_STROKE_COLOR,
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(20),
                  child: Container(
                    width: 132,
                    height: 89,
                    decoration: BoxDecoration(
                        color: PLAY_CARD_COLOR,
                        borderRadius: BorderRadius.circular(20)
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
