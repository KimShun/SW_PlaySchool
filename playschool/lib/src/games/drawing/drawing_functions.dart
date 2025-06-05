// ✅ opencv_dart 1.4.1 버전 기준
// Imgproc, Imgcodecs, Core 명시적 import 없이 사용 가능

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'package:lottie/lottie.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  Stroke({required this.points, required this.color, required this.width});
}

class _DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentWidth;

  _DrawingPainter(this.strokes, this.currentPoints, this.currentColor, this.currentWidth);

  @override
  void paint(Canvas canvas, ui.Size size) {
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    for (var stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.width
        ..blendMode = stroke.color == Colors.transparent ? BlendMode.clear : BlendMode.srcOver;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        canvas.drawLine(stroke.points[i], stroke.points[i + 1], paint);
      }
    }

    final currentPaint = Paint()
      ..color = currentColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = currentWidth;

    for (int i = 0; i < currentPoints.length - 1; i++) {
      canvas.drawLine(currentPoints[i], currentPoints[i + 1], currentPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final List<Stroke> strokes = [];
  final List<Offset> currentPoints = [];
  final GlobalKey _repaintKey = GlobalKey();

  Color selectedColor = Colors.black;
  double brushWidth = 8.0;
  double eraserWidth = 25.0;

  double get strokeWidth => isErasing ? eraserWidth : brushWidth;

  void setStrokeWidth(double val) {
    setState(() {
      isErasing ? eraserWidth = val : brushWidth = val;
    });
  }

  bool isErasing = false;
  double eraserRadius = 20.0;
  Offset? _cursorPosition;
  bool _isPointerDown = false;

  bool _isInBounds(Offset point, ui.Size size) {
    return point.dx >= 0 && point.dy >= 0 && point.dx <= size.width && point.dy <= size.height;
  }

  void addPoint(Offset point) {
    if (isErasing) {
      setState(() {
        strokes.add(Stroke(points: [point, point], color: Colors.transparent, width: eraserWidth));
      });
    } else {
      currentPoints.add(point);
    }
  }

  void endStroke() {
    if (currentPoints.isNotEmpty) {
      strokes.add(Stroke(points: List.from(currentPoints), color: selectedColor, width: strokeWidth));
      currentPoints.clear();
    }
  }

  void erase() {
    setState(() {
      isErasing = true;
      selectedColor = Colors.transparent;
    });
  }

  void changeColor(Color color) {
    setState(() {
      selectedColor = color;
      isErasing = false;
    });
  }

  void clear() {
    setState(() {
      strokes.clear();
      currentPoints.clear();
      debugPrint("✅ Canvas cleared!");
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = constraints.biggest;
        return MouseRegion(
          cursor: isErasing ? SystemMouseCursors.precise : SystemMouseCursors.basic,
          child: Stack(
            children: [
              Listener(
                onPointerHover: (event) {
                  if (isErasing) setState(() => _cursorPosition = event.localPosition);
                },
                onPointerDown: (event) {
                  setState(() {
                    _isPointerDown = true;
                    _cursorPosition = event.localPosition;
                  });
                },
                onPointerMove: (event) {
                  final localPos = event.localPosition;
                  if (_isInBounds(localPos, canvasSize)) {
                    setState(() {
                      addPoint(localPos);
                      _cursorPosition = localPos;
                    });
                  }
                },
                onPointerUp: (_) {
                  setState(() {
                    endStroke();
                    _isPointerDown = false;
                    _cursorPosition = null;
                  });
                },
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: CustomPaint(
                    painter: _DrawingPainter(strokes, currentPoints, selectedColor, strokeWidth),
                    child: Container(width: double.infinity, height: double.infinity, color: Colors.transparent),
                  ),
                ),
              ),
              if (isErasing && _cursorPosition != null && _isPointerDown)
                Positioned(
                  left: _cursorPosition!.dx - eraserRadius,
                  top: _cursorPosition!.dy - eraserRadius,
                  child: Container(
                    width: eraserRadius * 2,
                    height: eraserRadius * 2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.3),
                      border: Border.all(color: Colors.black26),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<ui.Image> captureCanvasImage() async {
    final boundary = _repaintKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    return await boundary.toImage(pixelRatio: 1.0);
  }
}

class BrushSizeSlider extends StatefulWidget {
  final double strokeWidth;
  final ValueChanged<double> onValueChanged;

  const BrushSizeSlider({super.key, required this.strokeWidth, required this.onValueChanged});

  @override
  State<BrushSizeSlider> createState() => _BrushSizeSliderState();
}

class _BrushSizeSliderState extends State<BrushSizeSlider> {
  late double _currentSliderValue;

  @override
  void initState() {

    super.initState();
    _currentSliderValue = widget.strokeWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("붓 크기", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Expanded(
          child: Slider(
            min: 1.0,
            max: 30.0,
            divisions: 29,
            label: _currentSliderValue.round().toString(),
            value: _currentSliderValue,
            onChanged: (value) {
              setState(() {
                _currentSliderValue = value;
                widget.onValueChanged(value);
              });
            },
          ),
        ),
      ],
    );
  }
}

class DrawingToolBar extends StatelessWidget {
  final VoidCallback onErase;
  final ValueChanged<Color> onChangeColor;
  final String imagePath;
  final GlobalKey<DrawingCanvasState> canvasKey;

  const DrawingToolBar({
    super.key,
    required this.onErase,
    required this.onChangeColor,
    required this.imagePath,
    required this.canvasKey,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red, Colors.green, Colors.blue,
      Colors.purple, Colors.orange, Colors.black, Colors.brown,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onErase,
          child: Image.asset("assets/icon/eraser1.png", width: 85, height: 85),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("색상 선택"),
                  content: SingleChildScrollView(
                    child: Wrap(
                      children: colors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            onChangeColor(color);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            );
          },
          child: Image.asset("assets/icon/crayons.png", width: 85, height: 85),
        ),
        GestureDetector(
          onTap: () async {
            final canvasState = canvasKey.currentState;
            if (canvasState == null) return;

            final referenceImage = await loadUiImage(imagePath);
            final userImage = await canvasState.captureCanvasImage();

            final paintedReference = await flattenToWhiteBackground(referenceImage);
            final paintedUser = await flattenToWhiteBackground(userImage);

            final tempDir = await getTemporaryDirectory();
            final timestamp = DateTime.now().millisecondsSinceEpoch;

            final referencePath = "${tempDir.path}/ref_flattened_$timestamp.png";
            final userPath = "${tempDir.path}/user_flattened_$timestamp.png";

            await saveUiImageToFile(paintedReference, referencePath);
            await saveUiImageToFile(paintedUser, userPath);

            final similarityPercent = await compareWithMatchShapes(referencePath, userPath);

            final canvasWidth = userImage.width;
            final canvasHeight = userImage.height;

            showLoadingDialog(context);
            await Future.delayed(const Duration(seconds: 2));
            Navigator.of(context).pop(); // 로딩 다이얼로그 닫기



            context.push(
              '/drawingResult',
              extra: {
                'similarityPercent': similarityPercent,
                'userDrawingPath': userPath,
                'canvasWidth': canvasWidth,
                'canvasHeight': canvasHeight,
              },
            );

            canvasKey.currentState?.clear();

          },
          child: Image.asset("assets/icon/exhibition.png", width: 85, height: 85),
        ),
      ],
    );
  }
}

Future<ui.Image> flattenToWhiteBackground(ui.Image original) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  canvas.drawRect(
    Rect.fromLTWH(0, 0, original.width.toDouble(), original.height.toDouble()),
    Paint()..color = Colors.white,
  );
  canvas.drawImage(original, Offset.zero, Paint());

  final picture = recorder.endRecording();
  return await picture.toImage(original.width, original.height);
}

Future<void> saveUiImageToFile(ui.Image image, String path) async {
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  final buffer = byteData!.buffer.asUint8List();
  final file = File(path);
  await file.writeAsBytes(buffer);
}

Future<ui.Image> loadUiImage(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<double> compareWithMatchShapes(String imgPath1, String imgPath2) async {
  final img1 = cv.imread(imgPath1, flags: cv.IMREAD_GRAYSCALE);
  final img2 = cv.imread(imgPath2, flags: cv.IMREAD_GRAYSCALE);

  final (_, thresh1) = cv.threshold(img1, 127, 255, cv.THRESH_BINARY_INV);
  final (_, thresh2) = cv.threshold(img2, 127, 255, cv.THRESH_BINARY_INV);

  final (contours1, _) = cv.findContours(thresh1, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);
  final (contours2, _) = cv.findContours(thresh2, cv.RETR_EXTERNAL, cv.CHAIN_APPROX_SIMPLE);

  if (contours1.isEmpty || contours2.isEmpty) return 0.0;

  final cnt1 = contours1.reduce((a, b) => cv.contourArea(a) > cv.contourArea(b) ? a : b);
  final cnt2 = contours2.reduce((a, b) => cv.contourArea(a) > cv.contourArea(b) ? a : b);

  final rawScore = cv.matchShapes(cnt1, cnt2, cv.CONTOURS_MATCH_I1, 0.0);
  const maxThreshold = 0.3;
  final similarityPercent = (1.0 - (rawScore / maxThreshold).clamp(0.0, 1.0)) * 100;

  return similarityPercent;
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: BG_COLOR, // 예쁜 배경색 (기존 스타일 유지)
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/lottie/loading.json",
              width: 120,
              height: 120,
              repeat: true,
            ),
            const SizedBox(height: 20),
            Text(
              "✨ 감정 중이에요... ✨",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Y_TEXT_COLOR,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "내 그림을 감정받고 있어요!\n잠깐만 기다려줘요 💫",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Y_TEXT_COLOR,
              ),
            ),
          ],
        ),
      );
    },
  );
}
