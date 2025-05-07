import 'package:flutter/cupertino.dart';

DanceInfo singFrog = DanceInfo(
  iconPath: "assets/dance/icon/frog.png",
  danceName: "개굴 개굴 개구리",
  videoPath: "assets/dance/video/frogSong.mov",
  copyRight: "유튜브: 초코초코"
);

DanceInfo baduk = DanceInfo(
  iconPath: "assets/dance/icon/shiba.png",
  danceName: "바둑이 방울",
  videoPath: "assets/dance/video/badukSong.mov",
  copyRight: "유튜브: 초코초코"
);

DanceInfo mountainRabbit = DanceInfo(
  iconPath: "assets/dance/icon/bunny.png",
  danceName: "산토끼 토끼야",
  videoPath: "assets/dance/video/mountainRabbitSong.mov",
  copyRight: "유튜브: 초코초코"
);

DanceInfo numberSong = DanceInfo(
  iconPath: "assets/dance/icon/numbers.png",
  danceName: "숫자송",
  videoPath: "assets/dance/video/numberSong.mov",
  copyRight: "유튜브: 초코초코"
);

List<DanceInfo> danceList = [singFrog, baduk, mountainRabbit, numberSong];

class DanceInfo {
  final String iconPath;
  final String danceName;
  final String videoPath;
  final String copyRight;

  const DanceInfo({
    required this.iconPath,
    required this.danceName,
    required this.videoPath,
    required this.copyRight,
  });
}