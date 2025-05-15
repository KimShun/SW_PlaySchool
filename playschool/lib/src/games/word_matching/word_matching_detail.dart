import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'dart:math';

class WordMatchingDetail extends StatefulWidget {
  final String label;

  const WordMatchingDetail({super.key, required this.label});

  @override
  State<WordMatchingDetail> createState() => _WordMatchingDetailState();
}

class _WordMatchingDetailState extends State<WordMatchingDetail> {
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
                minHeight: MediaQuery.of(context).size.height + 100,
              ),
              child: Column(
                children: [
                  _MyPageHeader(label: widget.label), // ✅ label 전달
                  const SizedBox(height: 30),
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
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
  final String label;

  const _MyPageHeader({super.key, required this.label});

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
                top: 16,
                right: 18,
                child: buildLifeBar(),
              ),


              Column(
                children: [
                  const SizedBox(height: 45),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icon/draw.png",
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          '$label을(를) 찾아줄게!', // ✅ 여기서 사용
                          style: const TextStyle(
                            color: Colors.white,
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

Widget buildLifeBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Image.asset(
            'assets/icon/heart.png',
            width: 24,
            height: 24,
          ),
        );
      }),
    ),
  );
}

