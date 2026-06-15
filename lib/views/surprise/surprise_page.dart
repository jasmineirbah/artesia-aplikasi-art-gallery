import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_back_button.dart';
import '../../widgets/primary_button.dart';
import '../../services/api_service.dart';

class SurprisePage extends StatefulWidget {
  const SurprisePage({super.key});

  @override
  State<SurprisePage> createState() => _SurprisePageState();
}

class _SurprisePageState extends State<SurprisePage> {
  final ApiService apiService = ApiService();

  Map<String, dynamic>? randomArt;

  List<Map<String, dynamic>> artworks = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadArtwork();
  }

  Future<void> loadArtwork() async {
    try {
      final data = await apiService.fetchArtworks();

      if (data.isEmpty) return;

      setState(() {
        artworks = data;
        randomArt = data[Random().nextInt(data.length)];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void getAnotherArtwork() {
    if (artworks.isEmpty) return;

    setState(() {
      randomArt = artworks[Random().nextInt(artworks.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      centerTitle: true,
                      toolbarHeight: 100,

                      leading: const CustomBackButton(),

                      title: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const AppLogo(showBackButton: false),

                          const SizedBox(height: 6),

                          Text(
                            'Surprise Me',
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    const SizedBox(height: 8),

                    Text(
                      "Discover a random artwork",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// IMAGE
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          randomArt!['image'],
                          height: 320,
                          width: double.infinity,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              height: 320,
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.image_not_supported),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// TITLE ARTWORK
                    Text(
                      randomArt!['title'],
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// ARTIST
                    Text(
                      randomArt!['artist'],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// CULTURE
                    Text(
                      randomArt!['culture'] ?? 'Unknown',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        text: "🎲 TRY ANOTHER",
                        onPressed: getAnotherArtwork,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
    );
  }
}