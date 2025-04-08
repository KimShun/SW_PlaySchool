FairyTaleInfo dungeonWithDragon = FairyTaleInfo(
  iconPath: "assets/icon/fairyDragon.png",
  fiaryName: "용과의 모험"
);

FairyTaleInfo magicForest = FairyTaleInfo(
    iconPath: "assets/icon/forest.png",
    fiaryName: "마법의 숲"
);

FairyTaleInfo ocean = FairyTaleInfo(
    iconPath: "assets/icon/ocean.png",
    fiaryName: "바다 속 탐험"
);

FairyTaleInfo spaceTrip = FairyTaleInfo(
    iconPath: "assets/icon/galaxy.png",
    fiaryName: "우주여행"
);

List<FairyTaleInfo> fairyTaleList = [dungeonWithDragon, magicForest, ocean, spaceTrip];

class FairyTaleInfo {
  final String iconPath;
  final String fiaryName;

  const FairyTaleInfo({
    required this.iconPath,
    required this.fiaryName
  });
}

// 용과의 모험
List<SettingInfo> dragonDungeonCharacters = [
  SettingInfo(iconPath: "assets/icon/boy.png", name: "남자아이"),
  SettingInfo(iconPath: "assets/icon/daughter.png", name: "여자아이"),
  SettingInfo(iconPath: "assets/icon/superhero.png", name: "영웅"),
  SettingInfo(iconPath: "assets/icon/kitty.png", name: "고양이"),
];

List<SettingInfo> dragonDungeonActions = [
  SettingInfo(iconPath: "assets/icon/flying.png", name: "하늘날기"),
  SettingInfo(iconPath: "assets/icon/boxing-gloves.png", name: "대결"),
  SettingInfo(iconPath: "assets/icon/talking.png", name: "대화하기"),
];

List<SettingInfo> dragonDungeonBgs = [
  SettingInfo(iconPath: "assets/icon/trees.png", name: "숲"),
  SettingInfo(iconPath: "assets/icon/cave.png", name: "동굴"),
  SettingInfo(iconPath: "assets/icon/clouds.png", name: "하늘"),
  SettingInfo(iconPath: "assets/icon/village.png", name: "마을"),
];

SettingsFairyTale dungeonWithDragonSetting = SettingsFairyTale(
  scene: "",
  characters: dragonDungeonCharacters,
  actions: dragonDungeonActions,
  backgrounds: dragonDungeonBgs
);

// 바다 속 탐험
List<SettingInfo> oceanCharacters = [
];

List<SettingInfo> oceanActions = [
];

List<SettingInfo> oceanBgs = [
];

SettingsFairyTale oceanSetting = SettingsFairyTale(
    scene: "",
    characters: oceanCharacters,
    actions: oceanActions,
    backgrounds: oceanBgs
);

// 마법의 숲
List<SettingInfo> magicForestCharacters = [
];

List<SettingInfo> magicForestActions = [
];

List<SettingInfo> magicForestBgs = [
];

SettingsFairyTale magicForestSetting = SettingsFairyTale(
    scene: "",
    characters: magicForestCharacters,
    actions: magicForestActions,
    backgrounds: magicForestBgs
);

// 우주여행
List<SettingInfo> spaceTripCharacters = [
];

List<SettingInfo> spaceTripActions = [
];

List<SettingInfo> spaceTripBgs = [
];

SettingsFairyTale spaceTripSetting = SettingsFairyTale(
    scene: "",
    characters: spaceTripCharacters,
    actions: spaceTripActions,
    backgrounds: spaceTripBgs
);

List<SettingsFairyTale> fairyTaleSettingList = [dungeonWithDragonSetting, oceanSetting, magicForestSetting, spaceTripSetting];

class SettingsFairyTale {
  final String scene;
  final List<SettingInfo> characters;
  final List<SettingInfo> actions;
  final List<SettingInfo> backgrounds;

  const SettingsFairyTale({
    required this.scene,
    required this.characters,
    required this.actions,
    required this.backgrounds,
  });
}

class SettingInfo {
  final String iconPath;
  final String name;

  const SettingInfo({
    required this.iconPath,
    required this.name,
  });
}