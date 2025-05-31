FairyTaleInfo dungeonWithDragon = FairyTaleInfo(
  iconPath: "assets/icon/fairyDragon.png",
  fairyName: "용과의 모험",
  fairySub: "용과 즐거운 모험을 떠나보자!",
  settingsFairyTale: dungeonWithDragonSetting,
);

FairyTaleInfo magicForest = FairyTaleInfo(
  iconPath: "assets/icon/forest.png",
  fairyName: "마법의 숲",
  fairySub: "마법의 숲에서 환상적인 일을 경험해봐~",
  settingsFairyTale: magicForestSetting,
);

FairyTaleInfo ocean = FairyTaleInfo(
  iconPath: "assets/icon/ocean.png",
  fairyName: "바다 속 탐험",
  fairySub: "너가 원하는 바다 속을 탐험해보자~",
  settingsFairyTale: oceanSetting
);

FairyTaleInfo spaceTrip = FairyTaleInfo(
  iconPath: "assets/icon/galaxy.png",
  fairyName: "우주여행",
  fairySub: "어디 행성을 여행해보고 싶어?",
  settingsFairyTale: spaceTripSetting,
);

List<FairyTaleInfo> fairyTaleList = [dungeonWithDragon, magicForest, ocean, spaceTrip];

class FairyTaleInfo {
  final String iconPath;
  final String fairyName;
  final String fairySub;
  final SettingsFairyTale settingsFairyTale;

  const FairyTaleInfo({
    required this.iconPath,
    required this.fairyName,
    required this.fairySub,
    required this.settingsFairyTale,
  });
}

// 용과의 모험
List<SettingInfo> dragonDungeonCharacters = [
  SettingInfo(iconPath: "assets/icon/boy.png", name: "남자아이"),
  SettingInfo(iconPath: "assets/icon/daughter.png", name: "여자아이"),
  SettingInfo(iconPath: "assets/icon/superhero.png", name: "영웅"),
  SettingInfo(iconPath: "assets/icon/kitty.png", name: "고양이"),
  SettingInfo(iconPath: "assets/icon/fairyUser.png", name: "나"),
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
  scene: "{character}(이)가 용과 함께 {background}에서 {action}를 하고 있어!",
  characters: dragonDungeonCharacters,
  actions: dragonDungeonActions,
  backgrounds: dragonDungeonBgs
);

// 바다 속 탐험
List<SettingInfo> oceanCharacters = [
  SettingInfo(iconPath: "assets/icon/boy.png", name: "남자아이"),
  SettingInfo(iconPath: "assets/icon/daughter.png", name: "여자아이"),
  SettingInfo(iconPath: "assets/icon/mermaid.png", name: "인어공주"),
  SettingInfo(iconPath: "assets/icon/fairyUser.png", name: "나"),
];

List<SettingInfo> oceanActions = [
  SettingInfo(iconPath: "assets/icon/adventurer.png", name: "탐험"),
  SettingInfo(iconPath: "assets/icon/treasure.png", name: "보물찾기"),
  SettingInfo(iconPath: "assets/icon/trash.png", name: "청소"),
  SettingInfo(iconPath: "assets/icon/swimming.png", name: "수영"),
];

List<SettingInfo> oceanBgs = [
  SettingInfo(iconPath: "assets/icon/fairyBoat.png", name: "해적선"),
  SettingInfo(iconPath: "assets/icon/palace.png", name: "용궁"),
  SettingInfo(iconPath: "assets/icon/coral.png", name: "산호숲"),
];

SettingsFairyTale oceanSetting = SettingsFairyTale(
    scene: "{character}(이)가 바다 속의 {background}에서 {action}를 하고 있어!",
    characters: oceanCharacters,
    actions: oceanActions,
    backgrounds: oceanBgs
);

// 마법의 숲
List<SettingInfo> magicForestCharacters = [
  SettingInfo(iconPath: "assets/icon/boy.png", name: "남자아이"),
  SettingInfo(iconPath: "assets/icon/daughter.png", name: "여자아이"),
  SettingInfo(iconPath: "assets/icon/fWizard.png", name: "마법사"),
  SettingInfo(iconPath: "assets/icon/fairy.png", name: "요정"),
  SettingInfo(iconPath: "assets/icon/fairyUser.png", name: "나"),
];

List<SettingInfo> magicForestActions = [
  SettingInfo(iconPath: "assets/icon/adventurer.png", name: "탐험"),
  SettingInfo(iconPath: "assets/icon/boxing-gloves.png", name: "대결"),
  SettingInfo(iconPath: "assets/icon/potion.png", name: "포션 제작"),
  SettingInfo(iconPath: "assets/icon/fMagic.png", name: "마법 사용"),
];

List<SettingInfo> magicForestBgs = [
  SettingInfo(iconPath: "assets/icon/tree.png", name: "나무 앞"),
  SettingInfo(iconPath: "assets/icon/wood-cabin.png", name: "오두막"),
  SettingInfo(iconPath: "assets/icon/mushroom.png", name: "버섯 숲"),
  SettingInfo(iconPath: "assets/icon/lake.png", name: "요정의 연못"),
];

SettingsFairyTale magicForestSetting = SettingsFairyTale(
    scene: "{character}(이)가 마법이 가득한 숲의 {background}에서 {action}를 하고 있어!",
    characters: magicForestCharacters,
    actions: magicForestActions,
    backgrounds: magicForestBgs
);

// 우주여행
List<SettingInfo> spaceTripCharacters = [
  SettingInfo(iconPath: "assets/icon/boy.png", name: "남자아이"),
  SettingInfo(iconPath: "assets/icon/daughter.png", name: "여자아이"),
  SettingInfo(iconPath: "assets/icon/robot.png", name: "로봇 친구"),
  SettingInfo(iconPath: "assets/icon/fairyUser.png", name: "나"),
];

List<SettingInfo> spaceTripActions = [
  SettingInfo(iconPath: "assets/icon/space-invaders.png", name: "우주선 조종"),
  SettingInfo(iconPath: "assets/icon/fishing.png", name: "우주 낚시"),
  SettingInfo(iconPath: "assets/icon/fShootingStar.png", name: "별똥별 잡기"),
  SettingInfo(iconPath: "assets/icon/adventurer.png", name: "탐험"),
];

List<SettingInfo> spaceTripBgs = [
  SettingInfo(iconPath: "assets/icon/full-moon.png", name: "달"),
  SettingInfo(iconPath: "assets/icon/venus.png", name: "금성"),
  SettingInfo(iconPath: "assets/icon/mars.png", name: "화성"),
  SettingInfo(iconPath: "assets/icon/black-hole.png", name: "블랙홀"),
  SettingInfo(iconPath: "assets/icon/fairyUser.png", name: "나"),
];

SettingsFairyTale spaceTripSetting = SettingsFairyTale(
    scene: "{character}(이)가 {background}의 행성에서 {action}를 하고 있어!",
    characters: spaceTripCharacters,
    actions: spaceTripActions,
    backgrounds: spaceTripBgs
);

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