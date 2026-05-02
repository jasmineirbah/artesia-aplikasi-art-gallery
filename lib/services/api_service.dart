import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
class ApiService {
  Future<List<Map<String, dynamic>>> fetchArtworks() async {
    try {
      // SEARCH PAINTINGS
      final searchUrl = Uri.parse(
        "https://collectionapi.metmuseum.org/public/collection/v1/search?q=painting&hasImages=true",
      );

      final searchRes = await http.get(searchUrl);

      if (searchRes.statusCode != 200) {
        throw Exception('Failed to search artworks');
      }

      final searchData = jsonDecode(searchRes.body);

      final List ids = searchData['objectIDs'] ?? [];

      // ambil maksimal 50 
      final limitedIds = ids.take(50).toList();

      List<Map<String, dynamic>> artworks = [];

      // GET DETAIL PER ARTWORK
      for (var id in limitedIds) {
        try {
          final detailUrl = Uri.parse(
            "https://collectionapi.metmuseum.org/public/collection/v1/objects/$id",
          );

          final res = await http.get(detailUrl);

          if (res.statusCode != 200) continue;

          final data = jsonDecode(res.body);

          final image = data['primaryImageSmall'];

          final price = (1500 + (id % 10) * 1200) * 15000;
          final formatter = NumberFormat('#,###', 'id_ID');

          // skip kalau ga ada gambar
          if (image == null || image.toString().isEmpty) continue;

          artworks.add({
            'id': id,
            'title': data['title'] ?? 'Untitled',
            'artist': data['artistDisplayName'] ?? 'Unknown Artist',
            'image': image,

            // tambahan data penting
            'category': data['classification'] ?? 'Art',
            'culture': data['culture'] ?? 'Unknown',
            'medium': data['medium'] ?? 'Unknown',
            'dimensions': data['dimensions'] ?? 'Unknown size',
            'location': data['repository'] ?? 'Unknown Museum',

            // dummy price (stabil)

            'price': 'Rp ${formatter.format(price)}',
          });
        } catch (e) {
          // skip kalau error di item tertentu
          continue;
        }
      }

      return artworks;
    } catch (e) {
      throw Exception('Error fetching artworks: $e');
    }
  }
}