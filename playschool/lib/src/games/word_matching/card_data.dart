import 'package:playschool/src/games/word_matching/word_matching_detail.dart';


/// 집 카드 목록
final List<WordImagePair> home = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
];


/// 과일 카드 목록
final List<WordImagePair> fruits = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
];

/// 동물 카드 목록
final List<WordImagePair> animals = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
  WordImagePair(word: "양", imagePath: "assets/icon/sheep.png"),
  WordImagePair(word: "다람쥐", imagePath: "assets/icon/squirrel.png"),
];

/// 색 카드 목록
final List<WordImagePair> color = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
];

/// 숫자 카드 목록
final List<WordImagePair> number = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
];

/// 직업 카드 목록
final List<WordImagePair> job = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
];

/// 교통 수단 카드 목록
final List<WordImagePair> transportation = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
];


/// 동물 카드 목록
final List<WordImagePair> body = [
  WordImagePair(word: "강아지", imagePath: "assets/icon/dog1.png"),
  WordImagePair(word: "고양이", imagePath: "assets/icon/cat.png"),
  WordImagePair(word: "토끼", imagePath: "assets/icon/rabbit.png"),
  WordImagePair(word: "코끼리", imagePath: "assets/icon/elephant.png"),
  WordImagePair(word: "기린", imagePath: "assets/icon/giraffe.png"),
  WordImagePair(word: "말", imagePath: "assets/icon/horse.png"),
];


/// 🗂 카테고리별 카드 맵핑
final Map<String, List<WordImagePair>> wordDataMap = {
  "우리 집": home,
  "과일 & 채소나라": fruits,
  "동물": animals,
  "색 & 모양": color,
  "숫자": number,
  "직업 탐험": job,
  "교통수단": transportation,
  "몸": body,


};


