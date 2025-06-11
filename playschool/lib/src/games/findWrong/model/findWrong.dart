import 'package:flutter/material.dart';

enum Difficulty {
  easy,
  medium,
  hard,
}

class FindWrongImageData {
  final String topImagePath;    // 상단 원본 이미지 경로
  final String bottomImagePath; // 하단 틀린 이미지 경로
  final List<Offset> differences; // 틀린 좌표

  FindWrongImageData({
    required this.topImagePath,
    required this.bottomImagePath,
    required this.differences,
  });
}