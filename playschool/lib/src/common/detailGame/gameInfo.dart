// 놀이터 게임
GameData wordCard = GameData(
  gameIconPath: "assets/icon/cardGame.jpg",
  name: "단어 맞추기",
  gameType: GameType.play,
  shortDetail: "",
  longDetail: "",
  detailVideoPath: "",
  detailImagePath: [],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: true,
);

GameData findWrongPicture = GameData(
  gameIconPath: "assets/icon/wrongPicture.jpg",
  name: "틀린그림찾기",
  gameType: GameType.play,
  shortDetail: "두 그림을 보고, 다른 부분을 찾아봐~!",
  longDetail: "'틀린그림찾기' 게임에 대해서 알려줄게~! \n위 아래 화면에 그림이 나타는데, 위에 화면을 보고 아래 화면에서 틀린 부분을 찾으면 되는 게임이야.",
  detailVideoPath: "",
  detailImagePath: [],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: true,
);

// 예체능 게임
GameData followDance = GameData(
  gameIconPath: "assets/icon/dance.jpg",
  name: "율동 따라하기",
  gameType: GameType.ent,
  shortDetail: "",
  longDetail: "",
  detailVideoPath: "",
  detailImagePath: [],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: true
);

GameData drawPicture = GameData(
  gameIconPath: "assets/icon/drawPainting.webp",
  name: "그림 그리기",
  gameType: GameType.ent,
  shortDetail: "",
  longDetail: "",
  detailVideoPath: "",
  detailImagePath: [],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: true
);

GameData colorPaper = GameData(
  gameIconPath: "assets/icon/colorPaper.jpg",
  name: "색종이 접기",
  gameType: GameType.ent,
  shortDetail: "",
  longDetail: "",
  detailVideoPath: "",
  detailImagePath: [],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: false,
);

// 창작활동 게임
GameData makeFTBook = GameData(
  gameIconPath: "assets/icon/fairyTaleBook.jpg",
  name: "동화책 만들기",
  gameType: GameType.make,
  shortDetail: "",
  longDetail: "",
  detailVideoPath: "",
  detailImagePath: [],
  gameLevel: 3,
  difficultMsg: "유치원 친구들부터 즐길 수 있는 게임이에요~!",
  isAvailable: true
);

GameData makeKidSong = GameData(
  gameIconPath: "assets/icon/kidsSong.jpg",
  name: "동요 만들기",
  gameType: GameType.make,
  shortDetail: "",
  longDetail: "",
  detailVideoPath: "",
  detailImagePath: [],
  gameLevel: 1,
  difficultMsg: "유치원 친구들부터 즐길 수 있는 게임이에요~!",
  isAvailable: false
);

List<GameData> playTypeList = [wordCard, findWrongPicture];
List<GameData> entTypeList = [followDance, drawPicture, colorPaper];
List<GameData> makeTypeList = [makeFTBook, makeKidSong];

enum GameType {
  play, // 놀이
  ent, // 예체능
  make // 창작활동
}

class GameData {
  final String gameIconPath;
  final String name;
  final GameType gameType;
  final String shortDetail;
  final String longDetail;
  final String detailVideoPath;
  final List<String> detailImagePath;
  final int gameLevel;
  final String difficultMsg;
  final bool isAvailable;

  const GameData({
    required this.gameIconPath,
    required this.name,
    required this.gameType,
    required this.shortDetail,
    required this.longDetail,
    required this.detailVideoPath,
    required this.detailImagePath,
    required this.gameLevel,
    required this.difficultMsg,
    required this.isAvailable,
  });
}