import 'package:flutter/material.dart';

class CompleteFairyTaleScreen extends StatelessWidget {
  final Map<String, dynamic> args;

  const CompleteFairyTaleScreen({
    super.key,
    required this.args,
  });

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
