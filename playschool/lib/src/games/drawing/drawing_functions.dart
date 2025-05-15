// ✅ opencv_dart 1.4.1 버전 기준
// Imgproc, Imgcodecs, Core 명시적 import 없이 사용 가능

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:opencv_dart/opencv_dart.dart' as cv;

/// 하나의 선
class Stroke {
  final List<Offset> points;
  final Color color;
  final double width;

  Stroke({
    required this.points,
    required this.color,
    required this.width,
  });
}

/// 기능 클래스: 로직 상태 저장
class DrawingFunctions {
  static List<Stroke> strokes = [];
  static List<Offset> currentPoints = [];
  static List<Stroke> referenceStrokes = [];
  static Color selectedColor = Colors.black;
  static double strokeWidth = 8.0;
  static bool isErasing = false;
  static double eraserRadius = 20.0;

  static void addPoint(Offset point) {
    if (isErasing) {
      _erasePoint(point);
    } else {
      currentPoints.add(point);
    }
  }

  static void _erasePoint(Offset point) {
    for (var stroke in strokes) {
      stroke.points.removeWhere((p) => (p - point).distance <= eraserRadius);
    }
    strokes.removeWhere((s) => s.points.length <= 1);
  }

  static void endStroke() {
    if (!isErasing && currentPoints.isNotEmpty) {
      strokes.add(
        Stroke(
          points: List.from(currentPoints),
          color: selectedColor,
          width: strokeWidth,
        ),
      );
      currentPoints.clear();
    }
  }

  static void undo() {
    if (strokes.isNotEmpty) {
      strokes.removeLast();
    }
  }

  static void erase() {
    isErasing = true;
  }

  static void changeColor(Color color) {
    selectedColor = color;
    isErasing = false;
  }

  static void clear() {
    strokes.clear();
    currentPoints.clear();
  }

  static CustomPainter getPainter() {
    return _DrawingPainter(
      List.from(strokes),
      List.from(currentPoints),
      selectedColor,
      strokeWidth,
    );
  }
}

/// 실제로 그려주는 painter
class _DrawingPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color currentColor;
  final double currentWidth;

  _DrawingPainter(this.strokes, this.currentPoints, this.currentColor, this.currentWidth);

  @override
  void paint(Canvas canvas, ui.Size size) {
    for (var stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.width;

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  State<DrawingCanvas> createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  Offset? _cursorPosition;
  bool _isPointerDown = false;
  final GlobalKey _repaintKey = GlobalKey();

  bool _isInBounds(Offset point, ui.Size size) {
    return point.dx >= 0 && point.dy >= 0 && point.dx <= size.width && point.dy <= size.height;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = constraints.biggest;

        return MouseRegion(
          cursor: DrawingFunctions.isErasing
              ? SystemMouseCursors.precise
              : SystemMouseCursors.basic,
          child: Stack(
            children: [
              Listener(
                onPointerHover: (event) {
                  if (DrawingFunctions.isErasing) {
                    setState(() {
                      _cursorPosition = event.localPosition;
                    });
                  }
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
                      DrawingFunctions.addPoint(localPos);
                      _cursorPosition = localPos;
                    });
                  }
                },
                onPointerUp: (_) {
                  setState(() {
                    DrawingFunctions.endStroke();
                    _isPointerDown = false;
                    _cursorPosition = null;
                  });
                },
                child: RepaintBoundary(
                  key: _repaintKey,
                  child: CustomPaint(
                    painter: DrawingFunctions.getPainter(),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
              if (DrawingFunctions.isErasing && _cursorPosition != null && _isPointerDown)
                Positioned(
                  left: _cursorPosition!.dx - DrawingFunctions.eraserRadius,
                  top: _cursorPosition!.dy - DrawingFunctions.eraserRadius,
                  child: Container(
                    width: DrawingFunctions.eraserRadius * 2,
                    height: DrawingFunctions.eraserRadius * 2,
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

class DrawingToolBar extends StatelessWidget {
  final VoidCallback setStateCallback;

  const DrawingToolBar({super.key, required this.setStateCallback});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red, Colors.green, Colors.blue,
      Colors.purple, Colors.orange, Colors.black, Colors.brown
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            DrawingFunctions.erase();
            setStateCallback();
          },
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
                            DrawingFunctions.changeColor(color);
                            Navigator.of(context).pop();
                            setStateCallback();
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
          onTap: () {},
          child: Image.asset("assets/icon/exhibition.png", width: 85, height: 85),
        ),
      ],
    );
  }
}

class BrushSizeSlider extends StatefulWidget {
  final VoidCallback onValueChanged;

  const BrushSizeSlider({super.key, required this.onValueChanged});

  @override
  State<BrushSizeSlider> createState() => _BrushSizeSliderState();
}

class _BrushSizeSliderState extends State<BrushSizeSlider> {
  double _currentSliderValue = DrawingFunctions.strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text("붓 크기",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold),),
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
                DrawingFunctions.strokeWidth = value;
                widget.onValueChanged();
              });
            },
          ),
        ),
      ],
    );
  }
}
//
// Future<double> compareWithOpenCV(ui.Image referenceImage, ui.Image userImage) async {
//   Future<Uint8List> imageToBytes(ui.Image image) async {
//     final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData!.buffer.asUint8List();
//   }
//
//   Future<String> saveTemp(Uint8List bytes, String filename) async {
//     final dir = await getTemporaryDirectory();
//     final path = '${dir.path}/$filename.png';
//     final file = File(path);
//     await file.writeAsBytes(bytes);
//     return path;
//   }
//
//   // 1. 이미지 → 바이트 → 파일로 저장
//   final refBytes = await imageToBytes(referenceImage);
//   final userBytes = await imageToBytes(userImage);
//   final refPath = await saveTemp(refBytes, 'reference');
//   final userPath = await saveTemp(userBytes, 'user');
//
//   // 2. 이미지 로드 (컬러로)
//   final refMat = cv.imread(refPath, flags: cv.IMREAD_COLOR);
//   final userMat = cv.imread(userPath, flags: cv.IMREAD_COLOR);
//
//   // 3. 그레이스케일 변환
//   final refGray = cv.cvtColor(refMat, cv.COLOR_BGR2GRAY);
//   final userGray = cv.cvtColor(userMat, cv.COLOR_BGR2GRAY);
//
//   // 4. Canny 엣지 감지
//   final refEdge = cv.canny(refGray, 50, 150);
//   final userEdge = cv.canny(userGray, 50, 150);
//
//   // 5. 사용자 이미지 크기 맞추기
//   final resizedUser = cv.resize(userEdge, (refEdge.size[0], refEdge.size[1]));
//
//   // 6. norm 비교 (L2 거리 → 유사도 계산)
//   final diff = cv.norm(refEdge, mask: resizedUser, normType: cv.NORM_L2);
//   final max = refEdge.size[0] * refEdge.size[1] * 255;
//   final similarity = (1.0 - (diff / max)).clamp(0.0, 1.0);
//
//   return similarity;
// }