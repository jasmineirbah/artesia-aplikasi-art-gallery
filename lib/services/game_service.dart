import 'dart:convert';
import 'package:http/http.dart' as http;

class GameService {
  Future<List<dynamic>> fetchQuestions() async {
    final res = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/jasmineirbah/artesia-api/main/questions.json',
    ));

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Failed to load questions");
    }
  }
}