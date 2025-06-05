import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';

class DrawingResult extends StatelessWidget {
  final double similarityPercent;
  final String userDrawingPath;
  final int canvasWidth;
  final int canvasHeight;

  const DrawingResult({
    super.key,
    required this.similarityPercent,
    required this.userDrawingPath,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _CommonResultView(
        similarityPercent: similarityPercent,
        userDrawingPath: userDrawingPath,
        canvasWidth: canvasWidth,
        canvasHeight: canvasHeight,
      ),
    );
  }
}

String _getMessageBySimilarity(double percent) {
  if (percent >= 80.0) {
    return "🎨 와우! 진짜 예술가 같아요!\n불꽃놀이처럼 멋져요!";
  } else if (percent >= 40.0) {
    return "🌟 분위기 제대로~!\n조금만 더 해볼까요?";
  } else {
    return "🌈 개성 뿜뿜! 정말 귀여워요!\n다시 도전해볼래요?";
  }
}






class _CommonResultView extends StatelessWidget {
  final double similarityPercent;
  final String userDrawingPath;
  final int canvasWidth;
  final int canvasHeight;

  const _CommonResultView({
    required this.similarityPercent,
    required this.userDrawingPath,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // 배경 이미지
        Positioned.fill(
          child: Opacity(
            opacity: 0.15,
            child: Image.asset(
              "assets/background/main_bg.png",
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 메인 콘텐츠
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight + 300,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 110),

                Text(
                  "그림의 점수는 ${similarityPercent.toStringAsFixed(0)}점",
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset("assets/icon/frame.png"),
                    if (userDrawingPath.isEmpty)
                      const Positioned(
                        top: 30,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: CircularProgressIndicator(), // 또는 아무것도 안 보이게 하고 싶다면 SizedBox.shrink()
                        ),
                      )
                    else
                      Positioned(
                        top: 30,
                        child: Image.file(
                          File(userDrawingPath),
                          width: canvasWidth.toDouble(),
                          height: canvasHeight.toDouble(),
                          fit: BoxFit.cover,
                          gaplessPlayback: true, // 캐시 무효화 도움
                        ),
                      ),

                  ],
                ),

                const SizedBox(height: 30),
                Text(
                  _getMessageBySimilarity(similarityPercent),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                )

              ],
            ),
          ),
        ),

        // 🎇 파이어워크 (하이 유사도에만 표시)
        if (similarityPercent >= 80.0)
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Lottie.asset(
              "assets/lottie/fireworks2.json",
              width: 300,
              repeat: true,
            ),
          ),

        // 하단 버튼 (도전 / 떠날래~)
        Positioned(
          bottom: 60,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () => GoRouter.of(context).go('/drawingGame'),
                child: Column(
                  children: [
                    Lottie.asset("assets/lottie/draw.json", width: 100),
                    const SizedBox(height: 8),
                    const Text("도전!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => GoRouter.of(context).go('/'),
                child: Column(
                  children: [
                    Lottie.asset("assets/lottie/leave.json", width: 100),
                    const SizedBox(height: 8),
                    const Text("아니야 떠날래~", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
