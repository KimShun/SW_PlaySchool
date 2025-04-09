import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:playschool/src/games/fairyTale/fairyTaleList.dart';

import '../../common/component/color.dart';

class SelectFairyTaleScreen extends StatelessWidget {
  final FairyTaleInfo fairyTaleInfo;

  const SelectFairyTaleScreen({
    super.key,
    required this.fairyTaleInfo,
  });

  @override
  Widget build(BuildContext context) {
    bool hasSafeArea(BuildContext context) {
      final padding = MediaQuery.of(context).padding;
      return padding.top > 20;
    }

    bool needsSafeArea = hasSafeArea(context);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.15,
            child: Image.asset("assets/background/main_bg.png"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: needsSafeArea ? 0 : 15.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  _detailHeader(fairyTaleInfo: fairyTaleInfo),
                  const SizedBox(height: 15.0),
                  _selectFactorList(
                    iconPath: "assets/icon/character-design.png",
                    listName: "등장인물",
                    characters: fairyTaleInfo.settingsFairyTale.characters
                  ),
                  const SizedBox(height: 15.0),
                  _selectFactorList(
                    iconPath: "assets/icon/action.png",
                    listName: "행동",
                    characters: fairyTaleInfo.settingsFairyTale.actions
                  ),
                  const SizedBox(height: 15.0),
                  _selectFactorList(
                    iconPath: "assets/icon/background.png",
                    listName: "배경",
                    characters: fairyTaleInfo.settingsFairyTale.backgrounds
                  ),
                  const SizedBox(height: 15.0),
                  Divider(
                    color: MAKE_STROKE_COLOR,
                    indent: 23, endIndent: 23,
                  ),
                  const SizedBox(height: 15.0),
                  _makeFairyTaleBtns()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _detailHeader extends StatelessWidget {
  final FairyTaleInfo fairyTaleInfo;

  const _detailHeader({
    super.key,
    required this.fairyTaleInfo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: MAKE_HEADER_COLOR,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(fairyTaleInfo.iconPath,
                              width: 90,
                              height: 90,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(fairyTaleInfo.fiaryName,
                                  style: TextStyle(
                                    color: MAKE_TEXT_COLOR,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25.0
                                  ),
                                ),
                                Text(fairyTaleInfo.fairySub,
                                  style: TextStyle(
                                    color: TEXT_COLOR,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13.0
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    DottedBorder(
                      color: MAKE_TEXT_COLOR,
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(20),
                      child: SizedBox(
                        height: 110,
                        child: Center(
                          child: Text(fairyTaleInfo.settingsFairyTale.scene,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: MAKE_TEXT_COLOR
                            ),
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.035,
              right: MediaQuery.of(context).size.width * 0.035,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Image.asset("assets/icon/exit.png",
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _selectFactorList extends StatefulWidget {
  final String iconPath;
  final String listName;
  final List<SettingInfo> characters;

  const _selectFactorList({
    super.key,
    required this.iconPath,
    required this.listName,
    required this.characters,
  });

  @override
  State<_selectFactorList> createState() => _selectFactorListState();
}

class _selectFactorListState extends State<_selectFactorList> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(widget.iconPath,
                width: 50,
                height: 50,
              ),
              const SizedBox(width: 10),
              Text(widget.listName,
                style: TextStyle(
                  color: Y_TEXT_COLOR,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          SizedBox(
            height: 140,
            child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.characters.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20.0),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, left: 25.0),
                        child: Column(
                          children: [
                            Image.asset(widget.characters[index].iconPath,
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 10.0),
                            Text(widget.characters[index].name,
                              style: TextStyle(
                                color: MAKE_TEXT_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Radio<int>(
                          value: index,
                          groupValue: _selectedIndex,
                          onChanged: (value) {
                            setState(() {
                              _selectedIndex = value;
                            });
                          },
                          activeColor: MAKE_STROKE_COLOR,
                        ),
                      ),
                    ],
                  );
                }
            ),
          )
        ],
      ),
    );
  }
}

class _makeFairyTaleBtns extends StatelessWidget {
  const _makeFairyTaleBtns({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    side: BorderSide(
                        color: MAKE_STROKE_COLOR,
                        width: 1
                    ),
                    backgroundColor: MAKE_BTN_COLOR,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white, size: 23),
                        SizedBox(width: 5),
                        Text("놀이하기",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // 모서리 둥글게
                    ),
                    side: BorderSide(
                        color: MAKE_STROKE_COLOR,
                        width: 1
                    ),
                    backgroundColor: MAKE_MORE_COLOR,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: Row(
                      children: [
                        Icon(Icons.refresh_outlined,
                          color: Colors.white,
                          size: 23,
                        ),
                      ],
                    ),
                  )
              )
            ],
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}