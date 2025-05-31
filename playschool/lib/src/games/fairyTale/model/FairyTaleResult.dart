class FairyTaleResult {
  final List<Map<String, dynamic>> fairyResults;

  const FairyTaleResult({
    required this.fairyResults,
  });

  factory FairyTaleResult.fromJson(Map<String, dynamic> json) {
    return FairyTaleResult(
      fairyResults: convertToList(json["imgs"], json["content"])
    );
  }
}

List<Map<String, dynamic>> convertToList(List<dynamic> imgs, List<dynamic> contents) {
  List<Map<String, dynamic>> fairyResults = [];
  for (int i=0; i<imgs.length; i++) {
    fairyResults.add({
      "image": imgs[i],
      "content": contents[i]
    });
  }

  return fairyResults;
}