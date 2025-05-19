import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/games/fairyTale/cubit/fairyTaleCubit.dart';

class CompleteFairyTaleScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const CompleteFairyTaleScreen({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> fairyResults = context.read<FairyTaleCubit>().state.fairyTaleResult!.fairyResults;

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
            child: Image.asset("assets/background/main_bg.png")
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: needsSafeArea ? 0 : 15.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _CompleteHeaderScreen(fairyResults: fairyResults),
                  Column(
                    children: [
                      Text("내가 선택한 항목들",
                        style: TextStyle(
                          color: Y_TEXT_COLOR,
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Image.asset("assets/icon/fairyDragon.png",
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(height: 5.0),
                              Text("용과의 모험",
                                style: TextStyle(
                                    color: MAKE_TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset("assets/icon/kitty.png",
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(height: 5.0),
                              Text("고양이",
                                style: TextStyle(
                                    color: MAKE_TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset("assets/icon/talking.png",
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(height: 5.0),
                              Text("대화하기",
                                style: TextStyle(
                                    color: MAKE_TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Image.asset("assets/icon/trees.png",
                                width: 70,
                                height: 70,
                              ),
                              const SizedBox(height: 5.0),
                              Text("숲",
                                style: TextStyle(
                                  color: MAKE_TEXT_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _bottomBtns(needsSafeArea: needsSafeArea),
    );
  }
}

class _CompleteHeaderScreen extends StatelessWidget {
  final List<Map<String, String>> fairyResults;

  const _CompleteHeaderScreen({
    super.key,
    required this.fairyResults
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Stack(
        children: [
          Container(
            height: 420,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset("assets/icon/shareIcon.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            GestureDetector(
                              onTap: () {},
                              child: Image.asset("assets/icon/downloadIcon.png",
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    child: CardSwiper(
                        isLoop: true,
                        backCardOffset: const Offset(30, 0),
                        allowedSwipeDirection: const AllowedSwipeDirection.symmetric(horizontal: true, vertical: false),
                        cardsCount: fairyResults.length,
                        cardBuilder: (context, index, percentThresholdX, percentThresholdY) {
                          return Container(
                            decoration: BoxDecoration(
                                color: MAKE_CARD_COLOR,
                                border: Border.all(color: MAKE_STROKE_COLOR, width: 2),
                                borderRadius: BorderRadius.circular(20)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                    child: Image.network(
                                      fairyResults[index]["image"]!,
                                      fit: BoxFit.cover
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(fairyResults[index]["content"]!,
                                        style: TextStyle(
                                            color: MAKE_TEXT_COLOR,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0
                                        ),
                                      ),
                                      const SizedBox(height: 3.0),
                                      Text("${index+1} / ${fairyResults.length}",
                                        style: TextStyle(
                                            color: TEXT_COLOR,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _bottomBtns extends StatelessWidget {
  final bool needsSafeArea;

  const _bottomBtns({
    super.key,
    required this.needsSafeArea
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(
                        color: MAKE_STROKE_COLOR,
                        width: 1
                    ),
                    backgroundColor: MAKE_BTN_COLOR,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white, size: 23),
                        SizedBox(width: 5),
                        Text("확인 및 저장하기",
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
                        color: MAKE_STROKE_COLOR,
                        width: 1
                    ),
                    backgroundColor: MAKE_MORE_COLOR,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: [
                        Icon(Icons.refresh_outlined,
                          color: Colors.white,
                          size: 23,
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
          SizedBox(height: needsSafeArea ? 20.0 : 10.0),
        ],
      ),
    );
  }
}
