import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artesia_aplikasi_art_gallery/views/detail/detail_page.dart';
//import 'package:artesia_aplikasi_art_gallery/views/detail/detail_page.dart';

class ArtCard extends StatelessWidget {
  final String artist;
  final String title;
  final String medium;
  final String price;
  final String image;
  final bool isSmall;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final Map<String, dynamic> art;

  const ArtCard({
    super.key,
    required this.artist,
    required this.title,
    required this.medium,
    required this.price,
    required this.image,
    this.isSmall = false,
    this.isFavorite = false,
    required this.onFavoriteToggle,
    required this.art,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailPage(art: art),
          ),
        );
      },
      child: Container(
        width: 240,
        margin: isSmall
            ? EdgeInsets.zero
            : const EdgeInsets.only(right: 20),
        color: Colors.transparent,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 BOX PUTIH (KHUSUS GAMBAR)
            Stack(
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(0, 0, 0, 0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.network(
                    image,
                    fit: BoxFit.contain,
                  ),
                ),

                /// ❤️ LOVE BUTTON
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.black,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: isSmall ? 13 : 15,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: isSmall ? 11 : 13,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 4),

            Text(
              medium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: isSmall ? 10 : 12,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              price,
              style: GoogleFonts.inter(
                fontSize: isSmall ? 14 : 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}