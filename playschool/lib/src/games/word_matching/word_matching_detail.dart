import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'dart:math';
import 'package:playschool/src/games/word_matching/card_data.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';

class WordMatchingDetail extends StatefulWidget {
  final String label;
  final String img;

  const WordMatchingDetail({super.key, required this.label, required this.img});

  @override
  State<WordMatchingDetail> createState() => _WordMatchingDetailState();
}

// 효과음
final AudioPlayer _audioPlayer = AudioPlayer();

Future<void> playSound(String path) async {
  await _audioPlayer.play(AssetSource(path));
}

class WordImagePair {
  final String word;
  final String imagePath;

  WordImagePair({required this.word, required this.imagePath});
}

class _GameCardData {
  final String type;
  final String value;
  final String pairKey;
  bool isMatched = false;

  _GameCardData({required this.type, required this.value, required this.pairKey});
}

class _WordMatchingDetailState extends State<WordMatchingDetail> {
  late List<WordImagePair> selectedData;
  late List<_GameCardData> shuffledData;

  _GameCardData? firstSelected;
  int score = 0;
  int lives = 3;

  void _selectRandomCards() {
    final all = wordDataMap[widget.label] ?? [];
    selectedData = List.of(all)..shuffle();       // 전체 복사 후 섞기
    selectedData = selectedData.take(6).toList(); // 상위 6개만 선택
  }

  @override
  void initState() {
    super.initState();
    _selectRandomCards();
    shuffledData = _generateShuffledData();
  }

  List<_GameCardData> _generateShuffledData() {
    final cards = <_GameCardData>[];
    for (var pair in selectedData) {
      cards.add(_GameCardData(type: 'word', value: pair.word, pairKey: pair.word));
      cards.add(_GameCardData(type: 'image', value: pair.imagePath, pairKey: pair.word));
    }
    cards.shuffle(Random());
    return cards;
  }

  void _onCardTap(_GameCardData card) {
    if (card.isMatched || card == firstSelected) return;

    setState(() {
      if (firstSelected == null) {
        firstSelected = card;
      } else {
        if (firstSelected!.pairKey == card.pairKey &&
            firstSelected!.type != card.type) {
          firstSelected!.isMatched = true;
          card.isMatched = true;
          score++;
          playSound("bgm/sonido-correcto.mp3");
          if (score == selectedData.length) {
            _showVictoryDialog(context, () {
              setState(() {
                score = 0;
                lives = 3;
                firstSelected = null;
                _selectRandomCards();
                shuffledData = _generateShuffledData();
              });
            });
          }
        } else {
          lives--;
          playSound("bgm/incorrect.mp3");
          if (lives <= 0) {
            _showFailedDialog(context, () {
              setState(() {
                score = 0;
                lives = 3;
                firstSelected = null;
                _selectRandomCards();
                shuffledData = _generateShuffledData();
              });
            });
          }
        }
        firstSelected = null;
      }


    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Column(
            children: [
              _MyPageHeader(label: widget.label, img: widget.img),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("점수: $score", style: const TextStyle(fontSize: 30)),
                    buildLifeBar(lives), // lives UI 직접 배치
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    children: shuffledData
                        .map((card) => GestureDetector(
                      onTap: () => _onCardTap(card),
                      child: AnimatedOpacity(
                        opacity: card.isMatched || card == firstSelected ? 1.0 : 0.3,
                        duration: const Duration(milliseconds: 300),
                        child: _GameCard(
                          child: card.type == 'word'
                              ? Text(
                            card.value,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                              : Image.asset(card.value, width: 60, height: 60),
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MyPageHeader extends StatelessWidget {
  final String label;
  final String img;

  const _MyPageHeader({super.key, required this.label, required this.img});

  @override
  Widget build(BuildContext context) {
    bool hasSafeArea(BuildContext context) {
      final padding = MediaQuery.of(context).padding;
      return padding.top > 20;
    }

    final needsSafeArea = hasSafeArea(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: PLAY_HEADER_COLOR,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 26.0,
            vertical: needsSafeArea ? 0 : 18.0,
          ),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => GoRouter.of(context).pop(),
                child: Image.asset("assets/icon/exit.png", width: 40, height: 40),
              ),


              Column(
                children: [
                  const SizedBox(height: 45),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset( img, width: 100, height: 100),
                        const SizedBox(height: 30),
                        Text(
                          '$label을(를) 찾아줄게!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildLifeBar(int lives) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(
            Icons.favorite,
            color: index < lives ? Colors.red : Colors.grey,
          ),
        );
      }),
    ),
  );
}

class _GameCard extends StatelessWidget {
  final Widget child;

  const _GameCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Center(child: child),
    );
  }
}


void _showVictoryDialog(BuildContext context, VoidCallback onRestart) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Lottie.asset("assets/lottie/fireworks2.json"),
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // 모서리 둥글게
              ),
              backgroundColor: BG_COLOR,
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset("assets/lottie/celebrate_nuguri.json",
                    width: 180,
                    height: 180,
                  ),
                  const SizedBox(height: 10),
                  Text("🎉 친구를 찾아줘서 고마워~!! 🎉",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Y_TEXT_COLOR
                    ),
                  ),

                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onRestart();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "다시하기",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.orangeAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "확인",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      }
  );
}

void _showFailedDialog(BuildContext context, VoidCallback onRestart) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          if(Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // 모서리 둥글게
          ),
          backgroundColor: BG_COLOR,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset("assets/lottie/failed_animal.json",
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 10),
              Text("😢 내 친구가 아니야 😢",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Y_TEXT_COLOR
                ),
              ),
              Text("내 친구를 다시 찾아줄래?!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Y_TEXT_COLOR
                ),
              ),

            ],


          ),

          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRestart();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "다시하기",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10,),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "확인",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        );
      }
  );
}
