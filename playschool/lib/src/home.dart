import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/authentication/cubit/authCubit.dart';
import 'package:playschool/src/authentication/cubit/userCubit.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:playschool/src/common/detailGame/gameInfo.dart';

import 'authentication/model/User.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, User?>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        setState(() {});
      },
      child: _buildHomeScreen(context),
    );
  }

  bool showToolTip = false;
  bool iconClicked = false;

  void handleAskTap() {
    setState(() {
      showToolTip = true;
      iconClicked = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          showToolTip = false;
          iconClicked = false;
        });
      }
    });
  }

  @override
  Widget _buildHomeScreen(BuildContext context) {
    final userData = context.read<UserCubit>().state!;
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
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: needsSafeArea ? 0 : 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _mainHeaderTop(userData: userData),
                              _mainHeaderBottom(userData: userData),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 클리어 시에 메달 아이콘 표시
                    if(userData.todayGame1 == true)
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0.30,
                        bottom: MediaQuery.of(context).size.width * 0.025,
                        child: Image.asset("assets/icon/award.png",
                          width: 45,
                          height: 45,
                        )
                      ),
                    if(userData.todayGame2 == true)
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
                          SizedBox(
                            height: 130,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              itemCount: playTypeList.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                return _gamePlayBtn(gameData: playTypeList[index]);
                              }
                            ),
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
                          SizedBox(
                            height: 130,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              itemCount: entTypeList.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                return _gamePlayBtn(gameData: entTypeList[index]);
                              }
                            ),
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
                          SizedBox(
                            height: 130,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              physics: const ClampingScrollPhysics(),
                              itemCount: makeTypeList.length,
                              separatorBuilder: (context, index) => const SizedBox(width: 20),
                              itemBuilder: (context, index) {
                                return _gamePlayBtn(gameData: makeTypeList[index]);
                              }
                            ),
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
}

class _gamePlayBtn extends StatefulWidget {
  final GameData gameData;
  const _gamePlayBtn({
    super.key,
    required this.gameData,
  });

  @override
  State<_gamePlayBtn> createState() => _gamePlayBtnState();
}

class _gamePlayBtnState extends State<_gamePlayBtn> {
  bool showToolTip = false;
  bool iconClicked = false;

  void handleAskTap() {
    setState(() {
      showToolTip = true;
      iconClicked = true;
    });

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showToolTip = false;
          iconClicked = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 150, // 살짝 높게 잡음
      child: Stack(
        clipBehavior: Clip.none, // Positioned로 넘치는 말풍선 허용
        children: [
          // 기존 Column 내용
          Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: handleAskTap,
                  child: Image.asset(
                    iconClicked
                        ? "assets/icon/click_ask.png"
                        : "assets/icon/ask.png",
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              // const SizedBox(height: 4),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push("/detailGame", extra: widget.gameData);
                    },
                    child: DottedBorder(
                      color: const Color(0xFF000000),
                      borderType: BorderType.Circle,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                        AssetImage(widget.gameData.gameIconPath),
                      ),
                    ),
                  ),
                  if (!widget.gameData.isAvailable)
                    DottedBorder(
                      color: const Color(0xFF000000),
                      borderType: BorderType.Circle,
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        child: Image.asset("assets/icon/padlock.png",
                            width: 45, height: 45),
                      ),
                    )
                ],
              ),
              const SizedBox(height: 5),
              Text(
                widget.gameData.name,
                style: TextStyle(
                  color: TEXT_COLOR,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600),
              )
            ],
          ),

          if (showToolTip)
            Positioned(
              right: -150,
              top: -30,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 📦 말풍선 본체
                  Container(
                    constraints: const BoxConstraints(maxWidth: 140),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      border: Border.all(color: Colors.brown.shade200, width: 1),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.brown.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.gameData.shortDetail,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF444444),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),

                  // 🔺 왼쪽 꼬리
                  Positioned(
                    left: 10,
                    bottom: -6,
                    child: ClipPath(
                      clipper: _LeftTailClipper(),
                      child: Container(
                        width: 12,
                        height: 8,
                        color: Colors.amber[100],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _LeftTailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, 0);     // top center
    path.lineTo(0, size.height);        // bottom left
    path.lineTo(size.width, size.height); // bottom right
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class _mainHeaderTop extends StatelessWidget {
  final User userData;

  const _mainHeaderTop({
    super.key,
    required this.userData,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  context.push("/myPage");
                },
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Y_STROKE_COLOR, width:1),
                  ),
                  child: CircleAvatar(
                      radius: 33,
                      backgroundImage: userData.gender == "여"
                          ? const AssetImage("assets/icon/IMG_3332.jpg") : const AssetImage("assets/icon/IMG_3332 2.jpg")
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userData.nickname,
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
  final User userData;

  const _mainHeaderBottom({
    super.key,
    required this.userData,
  });

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
                  child: GestureDetector(
                    onTap: () {
                      context.push("/puzzleGame");
                    },
                    child: Container(
                      width: 132,
                      height: 89,
                      decoration: BoxDecoration(
                          color: PLAY_CARD_COLOR,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("퍼즐 맞추기",
                            style: TextStyle(
                              color: Y_TEXT_COLOR,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          Image.asset("assets/icon/childHappy.png",
                            width: 45,
                            height: 45,
                          )
                        ],
                      ),
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
                  child: GestureDetector(
                    onTap: () {
                      if (userData.todayGame1) {
                        context.push("/wordGame");
                      }
                    },
                    child: Container(
                      width: 132,
                      height: 89,
                      decoration: BoxDecoration(
                          color: PLAY_CARD_COLOR,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("단어 맞추기",
                                style: TextStyle(
                                  color: Y_TEXT_COLOR,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Image.asset("assets/icon/childHappy2.png",
                                width: 45,
                                height: 45,
                              )
                            ],
                          ),
                          if(!userData.todayGame1)
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(20)
                              ),
                            )
                        ],
                      ),
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
