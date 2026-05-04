import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/app_logo.dart';

class KesanPesanPage extends StatelessWidget {
  const KesanPesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        toolbarHeight: 100,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(showBackButton: false),
            const SizedBox(height: 6),
            Text(
              "Kesan & Pesan",
              style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      // BODY
      body: Stack(
        children: [
          /// 🎨 BACKGROUND FULL (NO BLUR)
          Positioned.fill(
            child: Image.asset(
              "assets/images/star.jpg",
              fit: BoxFit.cover,
            ),
          ),

          // CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 46),

                  _buildCard(
                    title: "Kesan",
                    content:
                        "Mata kuliah TPM sangat seru dan berkesan karena memberi pengalaman dalam membuat aplikasi mobile dari awal.\n\nMulai dari perancangan tampilan hingga aplikasi dapat berjalan, prosesnya cukup menantang tetapi tetap menyenangkan.",
                  ),

                  const SizedBox(height: 18),

                  _buildCard(
                    title: "Pesan",
                    content:
                        "Semoga kedepannya materi yang diberikan dapat terus memberi manfaat bagi mahasiswa angkatan selanjutnya.",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CARD 
  Widget _buildCard({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.7,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}