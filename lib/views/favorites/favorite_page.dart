import 'package:artesia_aplikasi_art_gallery/services/database_service.dart';
import 'package:artesia_aplikasi_art_gallery/services/notification_service.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/app_logo.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/art_card.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key, required this.userId});

  final int userId;

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<Map<String, dynamic>> favoriteArtworks = [];
  Set<int> favoriteIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await DatabaseService.instance.getUserFavoriteArtworks(
      widget.userId,
    );

    if (!mounted) return;

    setState(() {
      favoriteArtworks = data;
      favoriteIds = data.map((art) => art['id']).whereType<int>().toSet();
      isLoading = false;
    });
  }

  Future<void> toggleFavorite(Map<String, dynamic> art) async {
    final artworkId = art['id'];
    if (artworkId is! int) return;

    await DatabaseService.instance.removeFavorite(widget.userId, artworkId);

    if (!mounted) return;

    setState(() {
      favoriteIds.remove(artworkId);
      favoriteArtworks.removeWhere((item) => item['id'] == artworkId);
    });

    NotificationService.showFavoriteNotification(
      isFavorite: false,
      artworkTitle: art['title']?.toString() ?? 'Artwork',
    );
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
              'Favorites',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteArtworks.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 48,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No favorites yet',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: favoriteArtworks.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 390,
                ),
                itemBuilder: (context, index) {
                  final art = favoriteArtworks[index];

                  return ArtCard(
                    art: art,
                    artist: art['artist']?.toString() ?? 'Unknown Artist',
                    title: art['title']?.toString() ?? 'Untitled',
                    price: art['price']?.toString() ?? '',
                    image: art['image']?.toString() ?? '',
                    medium: art['medium']?.toString() ?? 'Unknown medium',
                    isSmall: true,
                    isFavorite: favoriteIds.contains(art['id']),
                    onFavoriteToggle: () => toggleFavorite(art),
                  );
                },
              ),
            ),
    );
  }
}
