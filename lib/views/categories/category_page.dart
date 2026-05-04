import 'package:artesia_aplikasi_art_gallery/services/database_service.dart';
import 'package:artesia_aplikasi_art_gallery/services/notification_service.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/art_card.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/app_logo.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final int userId;

  const CategoryPage({super.key, required this.category, required this.userId});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Set<int> favoriteIds = {};

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final data = await DatabaseService.instance.getUserFavorites(widget.userId);

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
      await DatabaseService.instance.removeFavorite(widget.userId, artworkId);
    } else {
      await DatabaseService.instance.addFavoriteArtwork(widget.userId, art);
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

  @override
  Widget build(BuildContext context) {
    final allArtworks =
        ModalRoute.of(context)!.settings.arguments
            as List<Map<String, dynamic>>?;

    final filtered =
        allArtworks
            ?.where((art) => art['category'] == widget.category)
            .toList() ??
        [];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 216, 220, 216),
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
              widget.category,
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
            mainAxisExtent: 390,
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
              isFavorite: favoriteIds.contains(art['id']),
              onFavoriteToggle: () => toggleFavorite(art),
            );
          },
        ),
      ),
    );
  }
}
