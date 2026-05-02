import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KesanPesanPage extends StatelessWidget {
  const KesanPesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🖼️ BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/images/monet.jpg",
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),

          /// 🌫️ OVERLAY TIPIS (BIAR ELEGAN)
          Container(
            color: Colors.black.withOpacity(0.25),
          ),

          // CONTENT
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),

                // GLASS CARD 
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.30), 
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Text(
                        "Kesan & Pesan",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// KESAN
                      Text(
                        "Kesan",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Mata kuliah TPM sangat seru dan berkesan karena memberi pengalaman dalam membuat aplikasi mobile dari awal. Mulai dari perancangan tampilan sampai aplikasi dapat berjalan, prosesnya cukup menantang tapi juga menyenangkan.",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// PESAN
                      Text(
                        "Pesan",
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Semoga ke depannya materi yang diberikan dapat terus memberi manfaat bagi mahasiswa angkatan selanjutnya.",
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}