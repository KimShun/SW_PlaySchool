import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawingGameScreen extends StatelessWidget {
  const DrawingGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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

          ],
        ),
      ),
    );
  }
}
