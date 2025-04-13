import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:playschool/src/games/fairyTale/fairyTaleList.dart';

import '../../common/component/color.dart';

class SelectFairyTaleScreen extends StatefulWidget {
  final FairyTaleInfo fairyTaleInfo;

  const SelectFairyTaleScreen({
    super.key,
    required this.fairyTaleInfo,
  });

  @override
  State<SelectFairyTaleScreen> createState() => _SelectFairyTaleScreenState();
}

class _SelectFairyTaleScreenState extends State<SelectFairyTaleScreen> {
  int _resetKey = 0;
  SettingInfo? selectedCharacter;
  SettingInfo? selectedAction;
  SettingInfo? selectedBackground;

  void _resetSelections() {
    setState(() {
      _resetKey++;
      selectedCharacter = null;
      selectedAction = null;
      selectedBackground = null;
    });
  }

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
                  _detailHeader(fairyTaleInfo: widget.fairyTaleInfo),
                  const SizedBox(height: 15.0),
                  _selectFactorList(
                    iconPath: "assets/icon/character-design.png",
                    listName: "등장인물",
                    factors: widget.fairyTaleInfo.settingsFairyTale.characters,
                    onSelected: (value) {
                      setState(() {
                        selectedCharacter = value;
                      });
                    },
                    resetKey: _resetKey,
                  ),
                  const SizedBox(height: 15.0),
                  _selectFactorList(
                    iconPath: "assets/icon/action.png",
                    listName: "행동",
                    factors: widget.fairyTaleInfo.settingsFairyTale.actions,
                    onSelected: (value) {
                      setState(() {
                        selectedAction = value;
                      });
                    },
                    resetKey: _resetKey,
                  ),
                  const SizedBox(height: 15.0),
                  _selectFactorList(
                    iconPath: "assets/icon/background.png",
                    listName: "배경",
                    factors: widget.fairyTaleInfo.settingsFairyTale.backgrounds,
                    onSelected: (value) {
                      setState(() {
                        selectedBackground = value;
                      });
                    },
                    resetKey: _resetKey,
                  ),
                  const SizedBox(height: 90.0),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _makeFairyTaleBtns(
        fairyTaleInfo: widget.fairyTaleInfo,
        selectedCharacter: selectedCharacter,
        selectedAction: selectedAction,
        selectedBackground: selectedBackground,
        resetSelections: _resetSelections,
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
  final List<SettingInfo> factors;
  final void Function(SettingInfo selected)? onSelected;
  final int resetKey;

  const _selectFactorList({
    super.key,
    required this.iconPath,
    required this.listName,
    required this.factors,
    this.onSelected,
    required this.resetKey,
  });

  @override
  State<_selectFactorList> createState() => _selectFactorListState();
}

class _selectFactorListState extends State<_selectFactorList> {
  int? _selectedIndex;
  late int _lastResetKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lastResetKey = widget.resetKey;
  }

  @override
  void didUpdateWidget(covariant _selectFactorList oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);

    if(widget.resetKey != _lastResetKey) {
      setState(() {
        _selectedIndex = null;
        _lastResetKey = widget.resetKey;
      });
    }
  }

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
                itemCount: widget.factors.length,
                separatorBuilder: (context, index) => const SizedBox(width: 20.0),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, left: 25.0),
                        child: Column(
                          children: [
                            Image.asset(widget.factors[index].iconPath,
                              width: 80,
                              height: 80,
                            ),
                            const SizedBox(height: 10.0),
                            Text(widget.factors[index].name,
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

                            if(widget.onSelected != null) {
                              widget.onSelected!(widget.factors[index]);
                            }
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
  final FairyTaleInfo fairyTaleInfo;
  final SettingInfo? selectedCharacter;
  final SettingInfo? selectedAction;
  final SettingInfo? selectedBackground;
  final void Function() resetSelections;

  const _makeFairyTaleBtns({
    super.key,
    required this.fairyTaleInfo,
    required this.selectedCharacter,
    required this.selectedAction,
    required this.selectedBackground,
    required this.resetSelections,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if(selectedCharacter != null && selectedAction != null && selectedBackground != null) {
                      print("선택된 주제: ${fairyTaleInfo.fiaryName}");
                      print("선택된 등장인물: ${selectedCharacter!.name}");
                      print("선택된 행동: ${selectedAction!.name}");
                      print("선택된 배경: ${selectedBackground!.name}");
                    } else {
                      print("항목을 전부 선택해주셔야 합니다.");
                    }
                  },
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
                  onPressed: resetSelections,
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