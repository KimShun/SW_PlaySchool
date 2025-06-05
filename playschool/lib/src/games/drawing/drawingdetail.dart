import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'drawing_functions.dart';
import 'package:playschool/src/games/drawing/drawing_functions.dart';

class DrawingDetailScreen extends StatefulWidget {
  final String name;
  final String imagePath;

  const DrawingDetailScreen({

    super.key,
    required this.name,
    required this.imagePath,
  });

  @override
  State<DrawingDetailScreen> createState() => _DrawingDetailScreenState();
}

class _DrawingDetailScreenState extends State<DrawingDetailScreen> {
  final GlobalKey<DrawingCanvasState> _canvasKey = GlobalKey();
  double _strokeWidth = 8.0;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _canvasKey.currentState?.clear(); //
    });
  }


  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.3,
              child: Image.asset(
                "assets/background/main_bg.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox.expand(
            child: SingleChildScrollView(
              child: SizedBox(
                height: screenHeight,
                child: Stack(
                  children: [
                    // 장식 이미지
                    Positioned(
                      top: screenHeight * 0.13,
                      left: screenWidth * 0.02,
                      child: Transform.rotate(
                        angle: -80 * 3.1415927 / 180,
                        child: Image.asset(
                          "assets/icon/paint.png",
                          width: screenWidth * 0.5,
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.4,
                      right: screenWidth * 0.01,
                      child: Transform.rotate(
                        angle: -10 * 3.1415927 / 180,
                        child: Image.asset(
                          "assets/icon/splash.png",
                          width: screenWidth * 0.45,
                        ),
                      ),
                    ),

                    // 이젤 이미지
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.11),
                        child: Image.asset(
                          "assets/icon/easel (2).png",
                          width: screenWidth,
                          height: screenHeight * 0.7,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),

                    // 캔버스
                    Positioned(
                      top: screenHeight * 0.22,
                      left: screenWidth * 0.16,
                      child: SizedBox(
                        width: screenWidth * 0.65,
                        height: screenHeight * 0.37,
                        child: DrawingCanvas(
                          key: _canvasKey,
                        ),
                      ),
                    ),

                    // 오버레이 이미지
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.28),
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              widget.imagePath,
                              width: screenWidth,
                              height: screenHeight * 0.28,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // 단어 이름 텍스트
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.61),
                        child: Text(
                          widget.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // 상단 툴바
                    Column(
                      children: [
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _canvasKey.currentState?.clear();
                                  GoRouter.of(context).pop();
                                },
                                child: Image.asset(
                                  "assets/icon/exit.png",
                                  width: 50,
                                  height: 50,
                                ),
                              ),
                              const Spacer(),

                              GestureDetector(
                                onTap: () {
                                  _canvasKey.currentState?.clear();
                                  setState(() {});
                                },
                                child: Image.asset(
                                  "assets/icon/undo.png",
                                  width: 50,
                                  height: 50,
                                ),
                              ),



                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),

                    // 하단 툴바
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BrushSizeSlider(
                              strokeWidth: _strokeWidth,
                              onValueChanged: (val) {
                                setState(() {
                                  _strokeWidth = val;
                                  _canvasKey.currentState?.setStrokeWidth(val);

                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            DrawingToolBar(
                              canvasKey: _canvasKey,
                              onErase: () => _canvasKey.currentState?.erase(),
                              onChangeColor: (color) => _canvasKey.currentState?.changeColor(color),
                              imagePath: widget.imagePath,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
