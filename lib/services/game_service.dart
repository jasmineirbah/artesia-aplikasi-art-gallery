import 'dart:convert';
import 'package:http/http.dart' as http;

class GameService {
  Future<List<dynamic>> fetchQuestions() async {
    final res = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/jasmineirbah/artesia-api/refs/heads/main/questions.json',
    ));

    return jsonDecode(res.body);
  }
}