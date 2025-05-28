// 놀이터 게임
GameData wordCard = GameData(
  gameIconPath: "assets/icon/cardGame.jpg",
  name: "단어그림맞추기",
  gameType: GameType.play,
  shortDetail: "그림이랑 단어를 잘 보고 짝을 맞춰보자!!",
  longDetail: """
    이 게임은 단어와 그림을 짝 맞추는 재미있는 게임이야!
    알맞은 단어와 그림을 찾아서 찰칵! 서로 연결해줘~!
  """,
  howToPlay: """
    1. 화면에 그림과 단어 카드가 섞여 나와요.
    2. 그림을 보고 어떤 단어랑 짝인지 잘 생각해요!
    3. 알맞다고 생각하는 단어랑 그림을 차례로 눌러서 짝을 맞춰요.
    4. 맞으면 칭찬! 틀리면 다시 도전~!
  """,
  detailImagePath: [
    "assets/detail/wordgame/wordgameBanner1.png",
  ],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: true,
);

GameData findWrongPicture = GameData(
  gameIconPath: "assets/icon/wrongPicture.jpg",
  name: "틀린그림찾기",
  gameType: GameType.play,
  shortDetail: "똑같은 그림?? 잘 보면 달라요~!!",
  longDetail: """
    이 게임은 화면에 나오는 두 그림을 잘~ 보고,
    서로 다른 부분을 찾아서 콕! 찍는 게임이야!
  """,
  howToPlay: """
    1. 위 아래에 두 그림이 나와요!
    2. 얼핏 보면 똑같지만, 어디가 다를까?
    3. 다른 곳을 찾으면 손가락으로 콕! 눌러봐요! 
    4. 맞으면 ‘딩동댕~!’ 소리와 함께 점수 UP!
    5. 모든 다른 부분을 다 찾으면 게임 성공! 🎉
  """,
  detailImagePath: [
    "assets/detail/findwrong/findwrongBanner1.png"
  ],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: true,
);

// 예체능 게임
GameData followDance = GameData(
  gameIconPath: "assets/icon/dance.jpg",
  name: "율동 따라하기",
  gameType: GameType.ent,
  shortDetail: "화면 속 친구들과 함께 신나게 춤춰요!!",
  longDetail: """
    이 게임은 화면에 나오는 율동을 보고 따라하는 재미있는 게임이야!
  """,
  howToPlay: """
    1. 노래가 나오면 화면 속 친구들이 춤을 춰요!
    2. 친구들이 하는 동작을 따라 해보세요.
    3. 율동이 끝나면, 어떻게 잘 따라했는지 점수가 나와요!
    4. 칭찬도 받고 별점도 받을 수 있어요!
  """,
  detailImagePath: [
    "assets/detail/dance/danceGame1.png",
    "assets/detail/dance/danceGame2.png",
    "assets/detail/dance/danceGame3.png",
  ],
  gameLevel: 1,
  difficultMsg: "연령에 상관없이 누구나 재미있게 즐길 수 있어요~!",
  isAvailable: true
);

GameData drawPicture = GameData(
  gameIconPath: "assets/icon/drawPainting.webp",
  name: "그림 그리기",
  gameType: GameType.ent,
  shortDetail: "멋진 그림을 따라 그려보자!!",
  longDetail: """
    이 게임은 마음에 드는 그림을 골라서,
    밑그림을 따라 예쁘게 그리는 재미있는 게임이야!
  """,
  howToPlay: """
    1. 먼저, 그리고 싶은 그림을 하나 골라요!
    2. 화면에 보이는 밑그림을 따라 그려요!
    3. 색도 칠하고, 모양도 예쁘게~ 천천히 그려보세요!
    4. 다 그리면 게임이 그림을 보고 점수를 알려줘요!
    5. 잘 그렸다고 칭찬도 해줘요! 🌟
  """,
  detailImagePath: [
    "assets/detail/paint/paintBanner1.png"
  ],
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
  howToPlay: "",
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
  shortDetail: "내가 만든 이야기로 동화가 뚝딱!!",
  longDetail: """
    이 게임은 아이들이 직접 동화를 만드는 신나는 놀이예요!
    주제를 고르고, 나오는 인물과 배경, 행동을 정하면
    자동으로 4칸짜리 귀여운 동화책이 만들어진답니다! 🎉   
  """,
  howToPlay: """
    1. 먼저 하고 싶은 이야기 주제를 골라요!
    2. 나만의 주인공 캐릭터와 배경, 이야기 내용을 정해요!
    3. 짜잔! 선택한 걸 바탕으로 4컷 동화가 자동으로 완성돼요!
  """,
  detailImagePath: [
    "assets/detail/fairytale/fairytaleBanner1.png"
  ],
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
  howToPlay: "",
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
  final String howToPlay;
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
    required this.howToPlay,
    required this.detailImagePath,
    required this.gameLevel,
    required this.difficultMsg,
    required this.isAvailable,
  });
}