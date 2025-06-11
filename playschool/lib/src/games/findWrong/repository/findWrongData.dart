import 'package:flutter/material.dart';
import 'package:playschool/src/games/findWrong/model/findWrong.dart';

Offset scaleOffsetForFill(Offset originalOffset, Size originalSize, Size displayedSize) {
  double scaleX = displayedSize.width / originalSize.width;
  double scaleY = displayedSize.height / originalSize.height;

  return Offset(originalOffset.dx * scaleX, originalOffset.dy * scaleY);
}


// 난이도 쉬움 이미지 5장
final List<FindWrongImageData> easyImages = [
  FindWrongImageData(
    topImagePath: 'assets/findWrong/easy/top01.jpg',
    bottomImagePath: 'assets/findWrong/easy/bottom01.png',
    differences: [
      Offset(257, 50),
      Offset(220, 275),
      Offset(340, 95),
    ],
    originalSize: Size(393, 393), // 예시: 원본 이미지 사이즈 입력
  ),
  FindWrongImageData(
    topImagePath: 'assets/findWrong/easy/top02.jpg',
    bottomImagePath: 'assets/findWrong/easy/bottom02.png',
    differences: [
      Offset(335, 40),
      Offset(185, 185),
      Offset(85, 392),
    ],
    originalSize: Size(400, 400),
  ),
  FindWrongImageData(
    topImagePath: 'assets/findWrong/easy/top03.jpg',
    bottomImagePath: 'assets/findWrong/easy/bottom03.png',
    differences: [
      Offset(157, 233),
      Offset(35, 95),
      Offset(370, 33),
    ],
    originalSize: Size(393, 393),
  ),
  FindWrongImageData(
    topImagePath: 'assets/findWrong/easy/top04.jpg',
    bottomImagePath: 'assets/findWrong/easy/bottom04.png',
    differences: [
      Offset(230, 67),
      Offset(57, 370),
      Offset(372, 270),
    ],
    originalSize: Size(393, 393),
  ),
  FindWrongImageData(
    topImagePath: 'assets/findWrong/easy/top05.png',
    bottomImagePath: 'assets/findWrong/easy/bottom05.png',
    differences: [
      Offset(190, 35),
      Offset(340, 295),
      Offset(330, 50),
    ],
    originalSize: Size(393, 393),
  ),
];

// 난이도 중간
final List<FindWrongImageData> mediumImages = [
  FindWrongImageData(
    topImagePath: 'assets/findWrong/medium/top01.png',
    bottomImagePath: 'assets/findWrong/medium/bottom01.png',
    differences: [
      Offset(210, 215),
      Offset(48, 185),
      Offset(330, 78),
      Offset(385, 285),
    ],
    originalSize: Size(393, 393),
  ),
  FindWrongImageData(
    topImagePath: 'assets/findWrong/medium/top02.png',
    bottomImagePath: 'assets/findWrong/medium/bottom02.png',
    differences: [
      Offset(185, 100),
      Offset(315, 250),
      Offset(345, 135),
      Offset(360, 340),
    ],
    originalSize: Size(393, 393),
  ),
  FindWrongImageData(
    topImagePath: 'assets/findWrong/medium/top03.jpg',
    bottomImagePath: 'assets/findWrong/medium/bottom03.png',
    differences: [
      Offset(33, 103),
      Offset(327, 300),
      Offset(365, 113),
      Offset(348, 148),
    ],
    originalSize: Size(393, 393),
  ),
];

// 난이도 어려움
final List<FindWrongImageData> hardImages = [
  FindWrongImageData(
    topImagePath: 'assets/findWrong/hard/top01.jpg',
    bottomImagePath: 'assets/findWrong/hard/bottom01.jpg',
    differences: [
      Offset(340, 45),
      Offset(378, 315),
      Offset(202, 280),
      Offset(110, 310),
      Offset(40, 280),
    ],
    originalSize: Size(393, 393),
  ),
];
