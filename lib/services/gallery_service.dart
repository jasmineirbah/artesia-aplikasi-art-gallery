import 'dart:convert';
import 'package:http/http.dart' as http;

class GalleryService {
  final String url = "https://raw.githubusercontent.com/jasmineirbah/artesia-api/refs/heads/main/galleries.json";

  Future<List<dynamic>> fetchGalleries() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load galleries");
    }
  }
}