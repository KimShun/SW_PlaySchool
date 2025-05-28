class FairyTaleResult {
  final List<Map<String, String>> fairyResults;

  const FairyTaleResult({
    required this.fairyResults,
  });

  factory FairyTaleResult.fromJson(Map<String, dynamic> json) {
    return FairyTaleResult(
      fairyResults: convertToList(json["imgs"], json["content"])
    );
  }
}

List<Map<String, String>> convertToList(List<String> imgs, List<String> contents) {
  List<Map<String, String>> fairyResults = [];
  for (int i=0; i<imgs.length; i++) {
    fairyResults.add({
      "image": imgs[i],
      "content": contents[i]
    });
  }

  return fairyResults;
}