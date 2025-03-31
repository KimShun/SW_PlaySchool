import 'dart:math';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:playschool/src/common/component/color.dart';

class PuzzleGame extends StatefulWidget {
  const PuzzleGame({super.key});

  @override
  State<PuzzleGame> createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  ui.Image? _image;
  List<ui.Image> _imagePieces = [];
  Map<int, bool> _placedPieces = {};
  Map<int, int> _answerMapping = {};

  final String imageUrl = "https://th.bing.com/th/id/OIP.W_jE3Gz7KaX_EeHEbW4FqwAAAA?rs=1&pid=ImgDetMain";
  bool _puzzleCompleted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _puzzleCompleted = false;
    _loadImageUrl();
  }

  Future<void> _loadImageUrl() async {
    final response = await http.get(Uri.parse(imageUrl));

    if(response.statusCode == 200) {
      final Uint8List data = response.bodyBytes;
      final ui.Codec codec = await ui.instantiateImageCodec(data,
        targetWidth: 300, targetHeight: 300
      );
      final ui.FrameInfo frame = await codec.getNextFrame();

      setState(() {
        _image = frame.image;
        _splitImage();
      });
    }
  }

  Future<void> _splitImage() async {
    if(_image == null) return;

    int imageWidth = _image!.width;
    int imageHeight = _image!.height;

    int pieceWidth = imageWidth ~/ 2;
    int pieceHeight = imageHeight ~/ 2;

    List<int> originalIndexes = [0, 1, 2, 3];
    List<ui.Image> pieces = [];

    Future<void> cutPiece(int left, int top) async {
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder, Rect.fromPoints(Offset(0, 0), Offset(pieceWidth.toDouble(), pieceHeight.toDouble())));

      final src = Rect.fromLTWH(left.toDouble(), top.toDouble(), pieceWidth.toDouble(), pieceHeight.toDouble());
      final dst = Rect.fromLTWH(0, 0, pieceWidth.toDouble(), pieceHeight.toDouble());

      canvas.drawImageRect(_image!, src, dst, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(pieceWidth, pieceHeight);

      pieces.add(img);
    }

    await cutPiece(0, 0);
    await cutPiece(pieceWidth, 0);
    await cutPiece(0, pieceHeight);
    await cutPiece(pieceWidth, pieceHeight);

    List<int> shuffleIndexes = List.from(originalIndexes)..shuffle();

    List<ui.Image> shuffledPieces = List.generate(4, (index) => pieces[shuffleIndexes[index]]);
    Map<int, int> answerMapping = { for (int i=0; i<4; i++) originalIndexes[i] : shuffleIndexes[i] };

    setState(() {
      _imagePieces = shuffledPieces;
      _placedPieces = {0: false, 1: false, 2: false, 3: false};
      _answerMapping = answerMapping;

      print(originalIndexes);
      print(shuffleIndexes);
      print(answerMapping);
    });
  }

  void _checkPuzzleCompletion() {
    if(_placedPieces.values.every((piece) => piece == true)) {
      setState(() {
        _puzzleCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.15,
            child: Image.asset("assets/background/main_bg.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: SafeArea(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Y_HEADER_COLOR,
                            borderRadius: BorderRadius.circular(30)
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                  top: MediaQuery.of(context).size.width * 0.18,
                                  left: MediaQuery.of(context).size.width * 0.22,
                                  child: Transform.rotate(
                                    angle: 10 * 3.1415927 / 180,
                                    child: Transform.flip(
                                      flipX: true,
                                      child: Image.asset("assets/icon/searching.png",
                                        width: 50,
                                        height: 50,
                                      ),
                                    ),
                                  )
                              ),
                              Positioned(
                                  top: MediaQuery.of(context).size.width * 0.18,
                                  right: MediaQuery.of(context).size.width * 0.15,
                                  child: Transform.rotate(
                                    angle: 0 * 3.1415927 / 180,
                                    child: Image.asset("assets/icon/detective.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  )
                              ),
                              Padding(
                                padding: const EdgeInsets.all(26.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset("assets/icon/exit.png",
                                          width: 40,
                                          height: 40,
                                        ),
                                        Expanded(
                                          child: Text("퍼즐 맞추기 ^o^",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Y_TEXT_COLOR,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 50),
                                    Container(
                                      width: 300,
                                      height: 300,
                                      decoration: BoxDecoration(
                                        color: PLAY_CARD_COLOR,
                                        border: Border.all(color: PLAY_STROKE_COLOR, width: 2)
                                      ),
                                      child: DragTarget<int>(
                                        onAcceptWithDetails: (details) {},
                                        builder: (context, candidateData, rejectedData) {
                                          return Stack(
                                            children: List.generate(_imagePieces.length, (index) {
                                              int x = (index % 2) * 150;
                                              int y = (index ~/ 2) * 150;

                                              return Positioned(
                                                left: x.toDouble(),
                                                top: y.toDouble(),
                                                child: DragTarget<int>(
                                                  onAcceptWithDetails: (details) {
                                                    int draggedIndex = details.data;
                                                    int originalIndex = _answerMapping[draggedIndex]!;

                                                    // print("Dragged: $draggedIndex, Should be at: $originalIndex, Dropped at: $index");
                                                    if(originalIndex == index) {
                                                      setState(() {
                                                        _placedPieces[index] = true;
                                                      });
                                                    }

                                                    _checkPuzzleCompletion();
                                                  },
                                                  builder: (context, candidateData, rejectedData) {
                                                    if(_placedPieces[index] == true) {
                                                      return SizedBox(
                                                        width: 150,
                                                        height: 150,
                                                        child: RawImage(
                                                          image: _imagePieces[_answerMapping.keys.firstWhere((k) => _answerMapping[k] == index)]
                                                        )
                                                      );
                                                    } else {
                                                      return Container(
                                                        width: 150,
                                                        height: 150,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.orange, width: 1)
                                                        ),
                                                      );
                                                    }
                                                  }
                                                )
                                              );
                                            }),
                                          );
                                        }
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.asset("assets/icon/pencilKitty.png",
                                  width: 55,
                                  height: 55,
                                ),
                                const SizedBox(width: 20),
                                Image.asset("assets/icon/ducky.png",
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                            Image.asset("assets/icon/kitty2.png",
                              width: 55,
                              height: 55,
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[200],
                            border: Border.all(color: PLAY_STROKE_COLOR, width: 2),
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ...List.generate(_imagePieces.length, (index) {
                                  return Draggable<int>(
                                    data: index,
                                    feedback: Container(
                                      width: 150,
                                      height: 150,
                                      child: RawImage(image: _imagePieces[index]),
                                    ),
                                    childWhenDragging: Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: Colors.black, width: 1)
                                      ),
                                    ),
                                    child: Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black, width: 1),
                                      ),
                                      child: RawImage(image: _imagePieces[index]),
                                    )
                                  );
                                })
                              ]
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              side: BorderSide(color: Y_STROKE_COLOR, width: 1),
                              backgroundColor: PLAY_CARD_COLOR,
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("assets/icon/refresh2.png",
                                  width: 35,
                                  height: 35,
                                ),
                                const SizedBox(width: 10),
                                Text("다시 맞추기~~",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Y_TEXT_COLOR
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_puzzleCompleted == true)
            Stack(
              children: [
                Opacity(opacity: 0.3, child: Container(color: Colors.black),),
                Lottie.asset("assets/lottie/fireworks2.json"),
              ],
            )
        ],
      ),
    );
  }
}

class PuzzlePainter extends CustomPainter {
  final ui.Image image;
  final double x, y, width, height;

  PuzzlePainter(this.image, this.x, this.y, this.width, this.height);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(x, y, width, height),  // 원본 이미지에서 잘라낼 영역
      Rect.fromLTWH(0, 0, size.width, size.height),  // Container 크기에 맞게 조정
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}