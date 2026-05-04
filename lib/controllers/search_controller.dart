import 'dart:math';

class SearchController {
  // interpretasi query (rule-based)
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

  // TERM FREQUENCY (ML)
  Map<String, double> termFrequency(String text) {
    final words = text.toLowerCase().split(" ");
    final Map<String, double> tf = {};

    for (var word in words) {
      if (word.trim().isEmpty) continue;
      tf[word] = (tf[word] ?? 0) + 1;
    }

    final total = words.length;
    tf.updateAll((key, value) => value / total);

    return tf;
  }

  // COSINE SIMILARITY (ML)
  double cosineSimilarity(
    Map<String, double> v1,
    Map<String, double> v2,
  ) {
    final allWords = {...v1.keys, ...v2.keys};

    double dot = 0;
    double mag1 = 0;
    double mag2 = 0;

    for (var word in allWords) {
      final x = v1[word] ?? 0;
      final y = v2[word] ?? 0;

      dot += x * y;
      mag1 += x * x;
      mag2 += y * y;
    }

    if (mag1 == 0 || mag2 == 0) return 0;

    return dot / (sqrt(mag1) * sqrt(mag2));
  }

  // ML SIMILARITY (GANTI YANG LAMA)
  double similarity(String query, String text) {
    final tf1 = termFrequency(query);
    final tf2 = termFrequency(text);

    return cosineSimilarity(tf1, tf2);
  }

  // SEARCH FINAL
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