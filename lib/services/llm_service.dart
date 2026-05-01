import 'dart:convert';
import 'package:http/http.dart' as http;

class LLMService {
  Future<String> interpretQuery(String query) async {
    final res = await http.post(
      Uri.parse("https://api.openai.com/v1/chat/completions"),
      headers: {
        "Authorization": "Bearer sk-xxxxxxxxxxxxxxxx",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {
            "role": "user",
            "content":
                "Convert this search query into simple keywords for searching artworks. Only return keywords, no sentence: '$query'"
          }
        ]
      }),
    );

    final data = jsonDecode(res.body);
    return data['choices'][0]['message']['content'];
  }
}