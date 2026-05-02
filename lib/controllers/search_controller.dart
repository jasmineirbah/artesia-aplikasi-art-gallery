class SearchController {
  /// 🔥 interpretasi query (LLM sederhana)
  String interpretQuery(String query) {
    query = query.toLowerCase();

    if (query.contains("korea")) return "korean";
    if (query.contains("jepang")) return "japanese";
    if (query.contains("china")) return "chinese";
    if (query.contains("prancis")) return "french";
    if (query.contains("italy")) return "italian";
    if (query.contains("bunga")) return "flower";

    return query;
  }

  /// 🔥 ML similarity
  double similarity(String query, String text) {
    final qWords = query.split(" ");
    final t = text.toLowerCase();

    int match = 0;

    for (var word in qWords) {
      if (t.contains(word)) match++;
    }

    return match / qWords.length;
  }

  /// 🔥 SEARCH FINAL
  List<Map<String, dynamic>> search(
    String query,
    List<Map<String, dynamic>> data,
  ) {
    final interpreted = interpretQuery(query);

    data.sort((a, b) {
      final textA =
          "${a['title']} ${a['artist']} ${a['culture']} ${a['medium']}"
              .toLowerCase();

      final textB =
          "${b['title']} ${b['artist']} ${b['culture']} ${b['medium']}"
              .toLowerCase();

      final scoreA = similarity(interpreted, textA);
      final scoreB = similarity(interpreted, textB);

      return scoreB.compareTo(scoreA);
    });

    return data;
  }
}