import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:playschool/src/common/component/color.dart';
import 'dart:math';

class DrawingGameScreen extends StatelessWidget {
  const DrawingGameScreen({super.key});

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

          SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  const _MyPageHeader(),
                  const SizedBox(height: 30),
                  DrawingCategoryPage(),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class _MyPageHeader extends StatelessWidget {
  const _MyPageHeader({super.key});

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
        color: EXERCISE_HEADER_COLOR,
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
              Positioned(
                top: MediaQuery.of(context).size.width * 0.15,
                left: MediaQuery.of(context).size.width * 0.1,
                child: Image.asset(
                  "assets/icon/paint.png",
                  width: 100,
                  height: 100,
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.1,
                child: Image.asset(
                  "assets/icon/splash.png",
                  width: 100,
                  height: 100,
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 45),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icon/draw.png",
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(height: 30),
                        const Text(
                          "쓱싹쓱싹, 오늘부터 나도 화가!",
                          style: TextStyle(
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

// ================== Drawing 관련 클래스 ==================

class DrawingItem {
  final String name;
  final String imagePath;

  DrawingItem({required this.name, required this.imagePath});
}

class DrawingCard extends StatelessWidget {
  final DrawingItem item;

  const DrawingCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).go(
          '/drawingDetail',
          extra: {
            'name': item.name,
            'imagePath': item.imagePath,
          },
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class Category {
  final String name;
  final String iconPath;
  final Color backgroundColor;

  Category({
    required this.name,
    required this.iconPath,
    required this.backgroundColor,
  });
}

final List<Category> categories = [
  Category(name: '전체', iconPath: 'assets/icon/drawing.png', backgroundColor: Colors.yellow.shade100),
  Category(name: '도형', iconPath: 'assets/icon/shapes.png', backgroundColor: Colors.pink.shade100),
  Category(name: '동물', iconPath: 'assets/icon/livestock.png', backgroundColor: Colors.lightBlue.shade100),
  Category(name: '교통수단', iconPath: 'assets/icon/transportation.png', backgroundColor: Colors.green.shade100),
  Category(name: '캐릭터', iconPath: 'assets/icon/character.png', backgroundColor: Colors.purple.shade100),
];

class DrawingCategoryPage extends StatefulWidget {
  @override
  _DrawingCategoryPageState createState() => _DrawingCategoryPageState();
}

class _DrawingCategoryPageState extends State<DrawingCategoryPage> {
  String selectedCategory = '전체';

  final Map<String, List<DrawingItem>> items = {
    '도형': [
      DrawingItem(name: '별', imagePath: 'assets/icon/star (1).png'),
      DrawingItem(name: '사랑', imagePath: 'assets/icon/heart1.png'),
    ],
    '동물': [
      DrawingItem(name: '토끼', imagePath: 'assets/icon/animal.png'),
      DrawingItem(name: '곰', imagePath: 'assets/icon/bear.png'),
      DrawingItem(name: '고래', imagePath: 'assets/icon/whale.png'),
    ],
    '교통수단': [
      DrawingItem(name: '배', imagePath: 'assets/icon/boat.png'),
      DrawingItem(name: '트럭', imagePath: 'assets/icon/truck.png'),
    ],
    '캐릭터': [
      DrawingItem(name: '유령', imagePath: 'assets/icon/cute-ghost.png'),
    ],
  };

  List<DrawingItem> getFilteredItems() {
    if (selectedCategory == '전체') {
      return items.values.expand((list) => list).toList();
    } else {
      return items[selectedCategory] ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = getFilteredItems();

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category.name;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = category.name;
                  });
                },
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? darken(category.backgroundColor, 0.2)
                        : category.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected
                        ? Border.all(
                      color: Colors.white,
                      width: 3,
                    )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        category.iconPath,
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.grey.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.03),
            child: HorizontalDashedDivider(color: EXERCISE_HEADER_COLOR),
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: filteredItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 4 / 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            return DrawingCard(item: filteredItems[index]);
          },
        ),
      ],
    );
  }
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}

class HorizontalDashedDivider extends StatelessWidget {
  final Color? color;

  const HorizontalDashedDivider({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color dashColor = color ?? Theme.of(context).dividerColor;
    const double dashLength = 6.0;
    const double dashThickness = 2.0;
    const double space = 10.0;

    return SizedBox(
      height: space,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxWidth = constraints.maxWidth;
          final dashCount = (boxWidth / (2 * dashLength)).floor();

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return SizedBox(
                width: dashLength,
                height: dashThickness,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: dashColor),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
