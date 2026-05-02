import 'package:artesia_aplikasi_art_gallery/services/session_service.dart';
import 'package:artesia_aplikasi_art_gallery/views/categories/category_page.dart';
import 'package:artesia_aplikasi_art_gallery/views/chatbot/chatbot_page.dart';
import 'package:artesia_aplikasi_art_gallery/views/favorites/favorite_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artesia_aplikasi_art_gallery/services/api_service.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/art_card.dart';
import 'package:artesia_aplikasi_art_gallery/services/database_service.dart';
import 'package:artesia_aplikasi_art_gallery/services/notification_service.dart';
import 'package:artesia_aplikasi_art_gallery/controllers/search_controller.dart' as search;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService _apiService = ApiService();

  final search.SearchController searchController = search.SearchController();
  List<Map<String, dynamic>> filteredArtworks = [];

  List<Map<String, dynamic>> artworks = [];
  List<String> categories = [];
  bool isLoading = true;
  Set<int> favoriteIds = {}; 
  late int userId; //

  final List<String> validCategories = [
    "Paintings",
    "Drawings",
    "Prints",
    "Sculpture",
  ];
  
  String getCategoryImage(String category) {
    switch (category) {
      case "Paintings":
        return "assets/images/painting.jpg";
      case "Prints":
        return "assets/images/printing.jpg";
      case "Sculpture":
        return "assets/images/sculpture.jpg"; 
      case "Drawings":
        return "assets/images/drawing.jpg";
      default:
        return "assets/images/others.jpg";
    }
  }

  @override
  void initState() {
    super.initState();

    initUser();
  }

  Future<void> initUser() async {
    final id = await SessionService().getUserId();

    setState(() {
      userId = id ?? 0;
    });

    fetchData();
    loadFavorites();
  }

  Future<void> fetchData() async {
    try {
      final data = await _apiService.fetchArtworks();

      setState(() {
        artworks = data;
        filteredArtworks = data; 
        extractCategories();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> loadFavorites() async {
    final data = await DatabaseService.instance.getUserFavorites(userId);

    if (!mounted) return;

    setState(() {
      favoriteIds = data.toSet();
    });
  }

  Future<void> toggleFavorite(Map<String, dynamic> art) async {
    final artworkId = art['id'];
    if (artworkId is! int) return;

    final isAlreadyFavorite = favoriteIds.contains(artworkId);

    if (isAlreadyFavorite) {
      await DatabaseService.instance.removeFavorite(userId, artworkId);
    } else {
      await DatabaseService.instance.addFavoriteArtwork(userId, art);
    }

    if (!mounted) return;

    setState(() {
      if (isAlreadyFavorite) {
        favoriteIds.remove(artworkId);
      } else {
        favoriteIds.add(artworkId);
      }
    });

    NotificationService.showFavoriteNotification(
      isFavorite: !isAlreadyFavorite,
      artworkTitle: art['title']?.toString() ?? 'Artwork',
    );
  }

  void extractCategories() {
    final set = <String>{};

    for (var art in artworks) {
      final category = art['category']?.toString();

      if (category != null && validCategories.contains(category)) {
        set.add(category);
      }
    }

    categories = set.toList();

    // SORT
    categories.sort(
      (a, b) =>
          validCategories.indexOf(a).compareTo(validCategories.indexOf(b)),
    );

    //
    while (categories.length < 4) {
      for (var cat in validCategories) {
        if (!categories.contains(cat)) {
          categories.add(cat);
        }
        if (categories.length == 4) break;
      }
    }
  }

  void onSearch(String value) {
    if (value.isEmpty) {
      setState(() {
        filteredArtworks = artworks;
      });
      return;
    }

    final result = searchController.search(value, artworks);

    setState(() {
      filteredArtworks = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      body: SafeArea(
        child: SingleChildScrollView(
          // 
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),

                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to",
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Arts Gallery",
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FavoritePage(userId: userId),
                          ),
                        );

                        if (mounted) {
                          loadFavorites();
                        }
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.favorite_border),
                          ),
                          if (favoriteIds.isNotEmpty)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  favoriteIds.length.toString(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // SEARCH
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: onSearch,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search Painting",
                          hintStyle: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                          prefixIcon: const Icon(Icons.search, size: 18),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    //  CHATBOT BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ChatbotPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.smart_toy_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // FOR YOU
                Text(
                  "For You",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 380, 
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: filteredArtworks.length,
                          itemBuilder: (context, index) {
                            final art = filteredArtworks[index];

                            return ArtCard(
                              art: art,
                              artist: art['artist'],
                              title: art['title'],
                              price: art['price'],
                              image: art['image'],
                              medium: art['medium'],

                              isFavorite: favoriteIds.contains(
                                art['id'],
                              ), // 🔥 ini

                              onFavoriteToggle: () => toggleFavorite(art),
                            );
                          },
                        ),
                ),

                const SizedBox(height: 24),

                // CATEGORIES
                Text(
                  "Categories",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true, 
                  physics: const NeverScrollableScrollPhysics(), 
                  itemCount: categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryPage(
                              category: category,
                              userId: userId,
                            ),
                            settings: RouteSettings(arguments: artworks),
                          ),
                        );

                        if (mounted) {
                          loadFavorites();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: AssetImage(getCategoryImage(category)),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black.withOpacity(0.3), // biar text kebaca
                          ),
                          child: Center(
                            child: Text(
                              category,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    );
                  },
                ),
                const SizedBox(height: 46),

                Text(
                  "Culture",
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  height: 380,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredArtworks.length,
                    itemBuilder: (context, index) {
                      final art = filteredArtworks[index];

                      return ArtCard(
                        art: art,
                        artist: art['culture'] ?? 'Unknown',
                        title: art['title'],
                        price: art['price'],
                        image: art['image'],
                        medium: art['medium'],

                        isFavorite: favoriteIds.contains(art['id']),
                        onFavoriteToggle: () => toggleFavorite(art),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
