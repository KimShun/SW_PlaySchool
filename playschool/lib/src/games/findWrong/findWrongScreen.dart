import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:math';
import 'package:lottie/lottie.dart';
import 'package:playschool/src/games/findWrong/model/findWrong.dart';
import 'package:playschool/src/games/findWrong/repository/findWrongData.dart';
import 'package:playschool/src/authentication/repository/AuthRepository.dart';
import 'package:playschool/src/authentication/cubit/authCubit.dart';

class FindWrongGameScreen extends StatefulWidget {
  const FindWrongGameScreen({super.key});

  @override
  State<FindWrongGameScreen> createState() => _FindWrongGameScreenState();
}

class _FindWrongGameScreenState extends State<FindWrongGameScreen> {
  FindWrongImageData? _currentImageData;
  late Difficulty _selectedDifficulty;

  final List<Offset> _foundSpots = [];
  final List<_FadingWrongMark> _wrongSpots = [];

  int _score = 0;
  int _hearts = 3;

  bool _showBackButton = false;
  Timer? _backButtonTimer;
  bool _gameStarted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDifficultyDialog(context);
    });
  }

  // 좌표 스케일링 함수 (핵심 추가)
  Offset scaleOffsetForFill(
      Offset originalOffset, Size originalSize, Size displayedSize) {
    double scaleX = displayedSize.width / originalSize.width;
    double scaleY = displayedSize.height / originalSize.height;
    return Offset(originalOffset.dx * scaleX, originalOffset.dy * scaleY);
  }

  void showDifficultyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.yellow[100],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/dog_loading.json', height: 120),
              const SizedBox(height: 8),
              const Text('난이도를 선택하세요',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _difficultyButton(context, '쉬움', () => startGame(Difficulty.easy)),
              const SizedBox(height: 8),
              _difficultyButton(context, '중간', () => startGame(Difficulty.medium)),
              const SizedBox(height: 8),
              _difficultyButton(context, '어려움', () => startGame(Difficulty.hard)),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultyButton(BuildContext context, String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 18)),
    );
  }

  FindWrongImageData getRandomImage(Difficulty difficulty, FindWrongImageData? currentImage) {
    final random = Random();
    List<FindWrongImageData> selectedList;

    switch (difficulty) {
      case Difficulty.easy:
        selectedList = easyImages;
        break;
      case Difficulty.medium:
        selectedList = mediumImages;
        break;
      case Difficulty.hard:
        selectedList = hardImages;
        break;
    }

    if (selectedList.length <= 1) return selectedList.first;

    FindWrongImageData newImage;
    do {
      newImage = selectedList[random.nextInt(selectedList.length)];
    } while (newImage == currentImage);

    return newImage;
  }

  void startGame(Difficulty difficulty) {
    setState(() {
      _isLoading = true;
      _selectedDifficulty = difficulty;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final newImage = getRandomImage(difficulty, null);
      setState(() {
        _currentImageData = newImage;
        _foundSpots.clear();
        _wrongSpots.clear();
        _score = 0;
        _hearts = 3;
        _showBackButton = false;
        _gameStarted = true;
        _isLoading = false;
      });
    });
  }

  void _restartWithSameImage() {
    setState(() {
      _foundSpots.clear();
      _wrongSpots.clear();
      _score = 0;
      _hearts = 3;
      _showBackButton = false;
      _gameStarted = true;
    });
  }

  void _restartWithNextImage() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      final newImage = getRandomImage(_selectedDifficulty, _currentImageData);
      setState(() {
        _currentImageData = newImage;
        _foundSpots.clear();
        _wrongSpots.clear();
        _score = 0;
        _hearts = 3;
        _showBackButton = false;
        _gameStarted = true;
        _isLoading = false;
      });
    });
  }

  void _handleTap(TapDownDetails details, Size displayedSize) {
    if (!_gameStarted || _currentImageData == null) return;

    final localPosition = details.localPosition;
    bool found = false;

    _showBackButtonTemporarily();

    for (final spot in _currentImageData!.differences) {
      final scaledSpot = scaleOffsetForFill(
          spot, _currentImageData!.originalSize, displayedSize);
      if ((localPosition - scaledSpot).distance < 50 &&
          !_foundSpots.contains(spot)) {
        setState(() {
          _foundSpots.add(spot);
          _score++;
        });
        found = true;
        break;
      }
    }

    if (found) {
      if (_foundSpots.length == _currentImageData!.differences.length) {
        Future.delayed(const Duration(milliseconds: 300), _showSuccessDialog);
        context.read<AuthRepository>().userExpUp(context, context.read<AuthCubit>().state.token!);
      }
    } else {
      final wrongMark = _FadingWrongMark(position: localPosition, opacity: 1.0);
      setState(() {
        _wrongSpots.add(wrongMark);
        _hearts = max(0, _hearts - 1);
      });

      Timer.periodic(const Duration(milliseconds: 300), (timer) {
        int index = _wrongSpots.indexOf(wrongMark);
        if (index != -1 && mounted) {
          setState(() {
            _wrongSpots[index] = _wrongSpots[index].fadeOut();
          });
          if (_wrongSpots[index].opacity <= 0) {
            setState(() {
              _wrongSpots.removeAt(index);
            });
            timer.cancel();
          }
        } else {
          timer.cancel();
        }
      });

      if (_hearts == 0) {
        Future.delayed(const Duration(milliseconds: 300), _showGameOverDialog);
      }
    }
  }

  void _showBackButtonTemporarily() {
    setState(() {
      _showBackButton = true;
    });
    _backButtonTimer?.cancel();
    _backButtonTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showBackButton = false;
        });
      }
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('아쉬워요 😢'),
        content: const Text('기회를 모두 사용하셨습니다.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartWithSameImage();
            },
            child: const Text('다시 시작'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 축하합니다!'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('모든 차이를 찾아냈어요!', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('경험치가 1 상승했습니다.', style: TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _restartWithNextImage();
            },
            child: const Text('다음'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _backButtonTimer?.cancel();
    super.dispose();
  }

  Widget _buildImage(String imagePath, BoxFit fitMode, {bool showBackButton = false}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final displayedSize = Size(constraints.maxWidth, constraints.maxHeight);

        return GestureDetector(
          onTapDown: (details) {
            _showBackButtonTemporarily();
            _handleTap(details, displayedSize);
          },
          child: Stack(
            children: [
              Image.asset(
                imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: fitMode,
              ),
              ..._foundSpots.map((originalSpot) {
                final scaledSpot = scaleOffsetForFill(
                    originalSpot, _currentImageData!.originalSize, displayedSize);
                return Positioned(
                  left: scaledSpot.dx - 25,
                  top: scaledSpot.dy - 25,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.red, width: 6),
                    ),
                  ),
                );
              }),
              ..._wrongSpots.map((wrong) => Positioned(
                left: wrong.position.dx - 15,
                top: wrong.position.dy - 15,
                child: Opacity(
                  opacity: wrong.opacity,
                  child: const Icon(Icons.close, color: Colors.red, size: 30),
                ),
              )),
              if (showBackButton && _showBackButton)
                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Image.asset(
                      'assets/icon/exit.png',
                      width: 48,
                      height: 48,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEDDDD),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.orange))
            : _currentImageData == null
            ? const SizedBox()
            : Column(
          children: [
            Expanded(
              child: _buildImage(
                _currentImageData!.topImagePath,
                BoxFit.fill,
                showBackButton: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      _hearts,
                          (index) => const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.favorite, color: Colors.red, size: 28),
                      ),
                    ),
                  ),
                  Text(
                    '$_score / ${_currentImageData!.differences.length}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildImage(
                _currentImageData!.bottomImagePath,
                BoxFit.fill,
                showBackButton: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FadingWrongMark {
  final Offset position;
  final double opacity;

  _FadingWrongMark({required this.position, required this.opacity});

  _FadingWrongMark fadeOut() {
    return _FadingWrongMark(position: position, opacity: opacity - 0.3);
  }
}
