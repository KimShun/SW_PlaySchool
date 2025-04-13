import 'package:flutter/material.dart';

class CompletefairytaleScreen extends StatelessWidget {
  const CompletefairytaleScreen({super.key});

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
        ],
      ),
    );
  }
}
