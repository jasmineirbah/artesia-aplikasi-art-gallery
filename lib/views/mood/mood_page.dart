import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/api_service.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  final ApiService apiService = ApiService();

  String? selectedMood;

  List<Map<String, dynamic>> artworks = [];

  Map<String, dynamic>? recommendedArt;

  bool isLoading = true;

  final moods = [
    {
      "emoji": "😌",
      "title": "Relaxing",
    },
    {
      "emoji": "✨",
      "title": "Inspiring",
    },
    {
      "emoji": "🏛",
      "title": "Historical",
    },
    {
      "emoji": "🎭",
      "title": "Mysterious",
    },
    {
      "emoji": "🎨",
      "title": "Creative",
    },
  ];

  @override
  void initState() {
    super.initState();
    loadArtworks();
  }

  Future<void> loadArtworks() async {
    try {
      final data = await apiService.fetchArtworks();

      setState(() {
        artworks = data;
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void chooseMood(String mood) {
    if (artworks.isEmpty) return;

    List<Map<String, dynamic>> filtered = [];

    switch (mood) {
      case "Relaxing":
        filtered = artworks.where((art) {
          return art['culture']
              .toString()
              .toLowerCase()
              .contains('japan');
        }).toList();
        break;

      case "Historical":
        filtered = artworks.where((art) {
          return art['culture']
              .toString()
              .toLowerCase()
              .contains('europe');
        }).toList();
        break;

      case "Creative":
        filtered = artworks.where((art) {
          return art['medium']
              .toString()
              .toLowerCase()
              .contains('ink');
        }).toList();
        break;

      case "Inspiring":
        filtered = artworks.where((art) {
          return art['category']
              .toString()
              .toLowerCase()
              .contains('painting');
        }).toList();
        break;

      case "Mysterious":
        filtered = artworks.where((art) {
          return art['medium']
              .toString()
              .toLowerCase()
              .contains('oil');
        }).toList();
        break;

      default:
        filtered = artworks;
    }

    if (filtered.isEmpty) {
      filtered = artworks;
    }

    setState(() {
      selectedMood = mood;
      recommendedArt =
          filtered[Random().nextInt(filtered.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      Text(
                        "😊 Mood Art",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "How are you feeling today?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 35),

                      ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(),
                        itemCount: moods.length,
                        itemBuilder: (context, index) {
                          final mood = moods[index];

                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.circular(18),
                              onTap: () {
                                chooseMood(
                                  mood["title"] as String,
                                );
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: selectedMood ==
                                          mood["title"]
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      mood["emoji"] as String,
                                      style:
                                          const TextStyle(
                                        fontSize: 28,
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Text(
                                      mood["title"]
                                          as String,
                                      style:
                                          GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight:
                                            FontWeight.w600,
                                        color: selectedMood ==
                                                mood[
                                                    "title"]
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      if (recommendedArt != null) ...[
                        const SizedBox(height: 25),

                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Recommended Artwork",
                                style:
                                    GoogleFonts.inter(
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 14),

                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                                child: Image.network(
                                  recommendedArt![
                                      'image'],
                                  height: 220,
                                  width:
                                      double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              const SizedBox(height: 14),

                              Text(
                                recommendedArt![
                                    'title'],
                                textAlign:
                                    TextAlign.center,
                                maxLines: 2,
                                overflow:
                                    TextOverflow
                                        .ellipsis,
                                style:
                                    GoogleFonts
                                        .cormorantGaramond(
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height: 8),

                              Text(
                                recommendedArt![
                                    'artist'],
                                textAlign:
                                    TextAlign.center,
                                style:
                                    GoogleFonts.inter(
                                  color:
                                      Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}