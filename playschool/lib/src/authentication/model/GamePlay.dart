class GamePlay {
  final String userUID;
  final int wordGame;
  final int findWrongGame;
  final int danceGame;
  final int paintGame;
  final int makeBookGame;

  const GamePlay({
    required this.userUID,
    required this.wordGame,
    required this.findWrongGame,
    required this.danceGame,
    required this.paintGame,
    required this.makeBookGame,
  });

  factory GamePlay.fromJson(Map<String, dynamic> json) {
    return GamePlay(
      userUID: json["userUID"],
      wordGame: json["wordGame"],
      findWrongGame: json["findWrongGame"],
      danceGame: json["danceGame"],
      paintGame: json["paintGame"],
      makeBookGame: json["makeBookGame"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "userUID" : userUID,
      "wordGame" : wordGame,
      "findWrongGame" : findWrongGame,
      "danceGame" : danceGame,
      "paintGame" : paintGame,
      "makeBookGame" : makeBookGame
    };
  }
}