import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'dart:math';

class WordMatching extends StatelessWidget {
  const WordMatching({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: Image.asset(
                "assets/background/main_bg.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height +100,
              ),
              child: Column(
                children: [
                  const _MyPageHeader(),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 0.8,
                      ),

                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return GestureDetector(
                          onTap: () {
                            context.push(
                              '/word_matching_detail',
                              extra: {'label': item['label'],
                                      'img': item['img']},
                            );
                          },

                          child: buildItemCard(item['img'], item['color'], item['label']),
                        );
                      },

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

class _MyPageHeader extends StatelessWidget {
  const _MyPageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    bool hasSafeArea(BuildContext context) {
      final padding = MediaQuery.of(context).padding;
      return padding.top > 20;
    }

    final needsSafeArea = hasSafeArea(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: PLAY_HEADER_COLOR,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 26.0,
            vertical: needsSafeArea ? 0 : 18.0,
          ),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => GoRouter.of(context).pop(),
                child: Image.asset("assets/icon/exit.png", width: 40, height: 40),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.3,
                left: MediaQuery.of(context).size.width * 0.02,
                child: Image.asset(
                  "assets/icon/puzzle.png",
                  width: 70,
                  height: 70,
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).size.width * 0,
                right: MediaQuery.of(context).size.width * 0.05,
                child: Image.asset(
                  "assets/icon/puzzle (1).png",
                  width: 70,
                  height: 70,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0,
                left: MediaQuery.of(context).size.width * 0.15,
                child: Transform.rotate(
                  angle: -15 * 3.1415927 / 180,
                  child: Image.asset(
                    "assets/icon/puzzle (2).png",
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.35,
                left: MediaQuery.of(context).size.width * 0.7,
                child: Transform.rotate(
                  angle: 30 * 3.1415927 / 180,
                  child: Image.asset(
                    "assets/icon/puzzle (3).png",
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 45),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icon/link.png",
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "나의 짝꿍을 찾아줘~!!",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildItemCard(String imagePath, Color bgColor, [String? label]) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        height: 90, // 카드 높이 고정 (필요시 조정)
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
      const SizedBox(height: 8),
      if (label != null)
        Text(
          label!,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
    ],
  );
}


final List<Map<String, dynamic>> items = [
  {"img": "assets/icon/house.png", "color": Colors.pink.shade100, "label": "우리 집"},
  {"img": "assets/icon/healthy-food.png", "color": Colors.orange.shade100, "label": "과일 & 채소나라"},
  {"img": "assets/icon/livestock.png", "color": Colors.lightBlue.shade100, "label": "동물"},
  {"img": "assets/icon/star1.png", "color": Colors.green.shade100, "label": "색 & 모양"},
  {"img": "assets/icon/number-blocks.png", "color": Colors.yellow.shade100, "label": "숫자"},
  {"img": "assets/icon/job.png", "color": Colors.purple.shade100, "label": "직업 탐험"},
  {"img": "assets/icon/public-transport.png", "color": Colors.teal.shade100, "label": "교통수단"},
  {"img": "assets/icon/body.png", "color": Colors.orange.shade100, "label": "몸"},

];





