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
  double brushWidth = 8.0;     // 선의 굵기
  double eraserWidth = 25.0;   // 지우개의 반지름
  double get strokeWidth => isErasing ? eraserWidth : brushWidth;
  void setStrokeWidth(double val) {
    setState(() {
      if (isErasing) {
        eraserWidth = val;
      } else {
        brushWidth = val;
      }
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
        strokes.add(
          Stroke(
            points: [point, point], // 짧은 선
            color: Colors.transparent,
            width: eraserWidth,
          ),
        );
      });
    } else {
      currentPoints.add(point);
    }
  }


  void endStroke() {
    if (currentPoints.isNotEmpty) {
      strokes.add(Stroke(
        points: List.from(currentPoints),
        color: selectedColor,
        width: strokeWidth,
      ));
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
                  if (isErasing) {
                    setState(() => _cursorPosition = event.localPosition);
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
                    painter: _DrawingPainter(
                      strokes,
                      currentPoints,
                      selectedColor,
                      isErasing ? eraserWidth : brushWidth,
                    ),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.transparent,
                    ),
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

  const BrushSizeSlider({
    super.key,
    required this.strokeWidth,
    required this.onValueChanged,
  });

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
            print("버튼 눌림!");

            DrawingCanvasState? canvasState = canvasKey.currentState;
            if (canvasState == null) {
              print("canvasState가 null임");
              return;
            }

            int retry = 0;
            while (canvasState == null && retry < 5) {
              await Future.delayed(const Duration(milliseconds: 100));
              canvasState = canvasKey.currentState;
              retry++;
            }

            final referenceImage = await loadUiImage(imagePath);
            print("✅ reference image loaded");

            final userImage = await canvasState!.captureCanvasImage();
            print("✅ user image captured");

            final similarity = await compareWithOpenCV(referenceImage, userImage);
            print("✅ similarity: $similarity");

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("유사도 결과"),
                content: Text("유사도: ${(similarity * 100).toStringAsFixed(2)}%"),
              ),
            );
          },
          child: Image.asset("assets/icon/exhibition.png", width: 85, height: 85),
        ),


      ],
    );
  }
}


Future<ui.Image> loadUiImage(String assetPath) async {
  final byteData = await rootBundle.load(assetPath);
  final codec = await ui.instantiateImageCodec(byteData.buffer.asUint8List());
  final frame = await codec.getNextFrame();
  return frame.image;
}

Future<double> compareWithOpenCV(ui.Image referenceImage, ui.Image userImage) async {
  Future<Uint8List> imageToBytes(ui.Image image) async {
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<String> saveTemp(Uint8List bytes, String filename) async {
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/$filename.png';
    final file = File(path);
    await file.writeAsBytes(bytes);
    return path;
  }

  // 1. 이미지 → 바이트 → 파일로 저장
  final refBytes = await imageToBytes(referenceImage);
  final userBytes = await imageToBytes(userImage);
  final refPath = await saveTemp(refBytes, 'reference');
  final userPath = await saveTemp(userBytes, 'user');

  // 2. 이미지 로드 (컬러로)
  final refMat = cv.imread(refPath, flags: cv.IMREAD_COLOR);
  final userMat = cv.imread(userPath, flags: cv.IMREAD_COLOR);

  // 3. 그레이스케일 변환
  final refGray = cv.cvtColor(refMat, cv.COLOR_BGR2GRAY);
  final userGray = cv.cvtColor(userMat, cv.COLOR_BGR2GRAY);

  // 4. Canny 엣지 감지
  final refEdge = cv.canny(refGray, 50, 150);
  final userEdge = cv.canny(userGray, 50, 150);

  // 5. 사용자 이미지 크기 맞추기
  final resizedUser = cv.resize(userEdge, (refEdge.size[0], refEdge.size[1]));

  // 6. 차이 계산 후 norm 비교 (L2 거리 → 유사도 계산)
  final diffMat = cv.subtract(refEdge, resizedUser);
  final diff = cv.norm(diffMat, normType: cv.NORM_L2);
  final max = refEdge.size[0] * refEdge.size[1] * 255;
  final similarity = (1.0 - (diff / max)).clamp(0.0, 1.0);

  return similarity;
}

