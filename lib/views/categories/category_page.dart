import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/art_card.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/app_logo.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final allArtworks =
        ModalRoute.of(context)!.settings.arguments as List<Map<String, dynamic>>?;

    final filtered = allArtworks
            ?.where((art) => art['category'] == category)
            .toList() ??
        [];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      /*appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Artesia",
              style: GoogleFonts.inter(fontSize: 12),
            ),
            Text(
              category,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),*/

      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 216, 220, 216),
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100, // 🔥 INI KUNCI
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(showBackButton: false),

            const SizedBox(height: 6), // 🔥 JARAK

            Text(
              category,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: filtered.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 390, // 🔥 FIX HEIGHT LANGSUNG
          ),
          itemBuilder: (context, index) {
            final art = filtered[index];

            return ArtCard(
              art: art,
              artist: art['artist'],
              title: art['title'],
              price: art['price'],
              image: art['image'],
              medium: art['medium'],
              isSmall: true,

              isFavorite: false, // optional
              onFavoriteToggle: () {}, // 🔥 wajib isi walaupun kosong
            );
          },
        ),
      ),
    );
  }
}