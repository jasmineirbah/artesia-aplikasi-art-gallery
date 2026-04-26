import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artesia_aplikasi_art_gallery/pages/detail_page.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome to", style: GoogleFonts.inter(fontSize: 14, color: Colors.grey)),
            const Text("Arts Gallery", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28)),
          ],
        ),
        actions: [
          const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/150'), radius: 18),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search Gallery",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            const Text("For You", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              height: 380,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _artCard(context, "Omar Mahfoudi", "Morning Bird 5, 2024", "Ink on paper", "\$1,500", "https://picsum.photos/300/400"),
                  _artCard(context, "Salvo", "La cattedrale, 2004", "Oil on paper", "\$32,400", "https://picsum.photos/301/400"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _artCard(BuildContext context, String artist, String title, String type, String price, String img) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailPage())),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(img, height: 250, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(artist, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(title, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
            const Spacer(),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}