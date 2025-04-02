import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:playschool/src/common/component/color.dart';

class DetailGameScreen extends StatelessWidget {
  const DetailGameScreen({super.key});

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
          SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    _detailHeader(),
                    const SizedBox(height: 15),
                    _detailButtons(),
                    const SizedBox(height: 15),
                    _detailDescription(),
                    const SizedBox(height: 15),
                    _detailPreview(),
                    const SizedBox(height: 15),
                    _detailDifficult(),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _detailHeader extends StatelessWidget {
  const _detailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: PLAY_HEADER_COLOR
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
                            border: Border.all(color: PLAY_STROKE_COLOR, width:1),
                          ),
                          child: const CircleAvatar(
                            radius: 45,
                            backgroundImage: AssetImage("assets/icon/wrongPicture.jpg"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("틀린그림찾기",
                              style: TextStyle(
                                  color: Y_TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0
                              ),
                            ),
                            Text("두 그림을 보고, 다른 부분을 찾아봐~!!",
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
                    color: PLAY_STROKE_COLOR,
                    borderType: BorderType.RRect,
                    radius: const Radius.circular(30),
                    child: Container(
                      height: 210,
                      decoration: BoxDecoration(
                          color: PLAY_CARD_COLOR,
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
          child: Image.asset("assets/icon/exit.png",
            width: 40,
            height: 40,
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
    );
  }
}

class _detailButtons extends StatelessWidget {
  const _detailButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // 모서리 둥글게
                      ),
                      side: BorderSide(color: PLAY_STROKE_COLOR, width: 1),
                      backgroundColor: PLAY_BTN_COLOR
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow,
                          color: Colors.white,
                          size: 23,
                        ),
                        const SizedBox(width: 5),
                        Text("놀이하기",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                          ),
                        ),
                      ],
                    ),
                  )
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 모서리 둥글게
                    ),
                    side: BorderSide(color: PLAY_STROKE_COLOR, width: 1),
                    backgroundColor: PLAY_MORE_COLOR
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  child: const Row(
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
        Text("⚠️ 안전을 위해, 부모님의 조언과 지도가 필요할 수 있습니다.",
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
  const _detailDescription({super.key});

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
                  color: Y_TEXT_COLOR,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        const SizedBox(height: 10),
        Text("'틀린그림찾기' 게임에 대해서 알려줄게~! \n위 아래 화면에 그림이 나타는데, 위에 화면을 보고 아래 화면에서 틀린 부분을 찾으면 되는 게임이야.",
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
  const _detailPreview({super.key});

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
                  color: Y_TEXT_COLOR,
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
              physics: ClampingScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                return Container(
                  width: 110,
                  decoration: BoxDecoration(
                      color: PLAY_CARD_COLOR,
                      border: Border.all(color: PLAY_STROKE_COLOR, width: 1),
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
  const _detailDifficult({super.key});

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
                  color: Y_TEXT_COLOR,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            ...List.generate(1, (index) =>
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Image.asset("assets/icon/favourite (1).png",
                    width: 45, height: 45,
                  ),
                )),
            ...List.generate(5-1, (index) =>
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
              color: PLAY_STROKE_COLOR,
              fontSize: 13.0,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    );
  }
}
