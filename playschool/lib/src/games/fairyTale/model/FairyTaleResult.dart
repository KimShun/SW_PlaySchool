class FairyTaleResult {
  final List<String> contentList;
  final List<String> imgUrlList;

  const FairyTaleResult({
    required this.contentList,
    required this.imgUrlList,
  });

  factory FairyTaleResult.fromJson(Map<String, dynamic> json) {
    return FairyTaleResult(
      contentList: json["content"],
      imgUrlList: json["imgs"]
    );
  }
}