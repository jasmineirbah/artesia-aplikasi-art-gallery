import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Center(
        child: Column(
          children: [
            const Text("Loribelle\nSpirovski", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            Text("Homme 271, 2021", style: GoogleFonts.inter(color: Colors.grey)),
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD4AF37), width: 8)),
                  child: Image.network("https://picsum.photos/250/350", height: 300),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.black,
                  child: const Text("\$5,800-\$7,500", style: TextStyle(color: Colors.white, fontSize: 12)),
                )
              ],
            ),
            const SizedBox(height: 20),
            const Text("✨ Unique work", style: TextStyle(fontSize: 14)),
            const Text("📜 Includes a Certificate of Authenticity", style: TextStyle(decoration: TextDecoration.underline, fontSize: 12)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Make an Offer", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}