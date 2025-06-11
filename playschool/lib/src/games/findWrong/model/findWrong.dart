import 'package:flutter/material.dart';

enum Difficulty {
  easy,
  medium,
  hard,
}

class FindWrongImageData {
  final String topImagePath;
  final String bottomImagePath;
  final List<Offset> differences;
  final Size originalSize;

  FindWrongImageData({
    required this.topImagePath,
    required this.bottomImagePath,
    required this.differences,
    required this.originalSize,
  });
}
