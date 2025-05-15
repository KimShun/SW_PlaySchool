class DanceAPI {
  final double totalScore;
  final double similarityScore;
  final double movementScore;
  final String totalContent;
  final String similarityContent;
  final String movementContent;

  const DanceAPI({
    required this.totalScore,
    required this.similarityScore,
    required this.movementScore,
    required this.totalContent,
    required this.similarityContent,
    required this.movementContent,
  });

  factory DanceAPI.fromJson(Map<String, dynamic>  json) {
    final similarity = json["similarity_score"];
    final movement = json["movement_range"] * 10 + 20;
    final total = similarity * 0.7 + movement * 0.3;

    String getTotalComment(double total) {
      if (total >= 85) {
        return "우와!! 정말 굉장해!!";
      } else if (total >= 60) {
        return "대단해!! 정말 잘했어!!";
      } else {
        return "괜찮아~! 다음엔 더 힘내보자~!!";
      }
    }

    String getSimilarityComment(double similarity) {
      if (similarity >= 85) {
        return "자세가 아주 훌륭해~~!!";
      } else if (similarity >= 60) {
        return "잘 따라했어~!!";
      } else {
        return "따라서 춤 추느라 수고많았어~";
      }
    }

    String getMovementComment(double movement) {
      if (movement >= 85) {
        return "동작이 전부 열정적이야!!";
      } else if (movement >= 60) {
        return "열심히 춤 췄는걸~";
      } else {
        return "열심히 춤 추느라 수고많았어~~";
      }
    }

    return DanceAPI(
      totalScore: total,
      similarityScore: similarity,
      movementScore: movement,
      totalContent: getTotalComment(total),
      similarityContent: getSimilarityComment(similarity),
      movementContent: getMovementComment(movement)
    );
  }
}