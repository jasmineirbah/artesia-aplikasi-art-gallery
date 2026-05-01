import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/location_service.dart';
import '../../services/gallery_service.dart';

class NearbyGallerySheet extends StatefulWidget {
  const NearbyGallerySheet({super.key});

  @override
  State<NearbyGallerySheet> createState() => _NearbyGallerySheetState();
}

class _NearbyGallerySheetState extends State<NearbyGallerySheet> {
  final LocationService locationService = LocationService();
  final GalleryService galleryService = GalleryService();

  Position? userPos;
  List galleries = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    userPos = await locationService.getLocation();
    galleries = await galleryService.fetchGalleries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFFF4F1EC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: (userPos == null || galleries.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HANDLE
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                Center(
                  child: Column(
                    children: [
                      Text(
                        "Nearby Galleries",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 14),

                      /// 🔥 ICON MAP
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_on, size: 16),
                          SizedBox(width: 4),
                          Text(
                            "Within 50 km",
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: galleries.length,
                    itemBuilder: (context, index) {
                      final g = galleries[index];

                      double distance = locationService.getDistance(
                        userPos!.latitude,
                        userPos!.longitude,
                        g["lat"],
                        g["lng"],
                      );

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            /// IMAGE
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                g["image"],
                                width: 70,
                                height: 70,
                                fit: BoxFit.cover,
                              ),
                            ),

                            const SizedBox(width: 12),

                            /// TEXT
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    g["name"],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${distance.toStringAsFixed(1)} km away",
                                    style: GoogleFonts.inter(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}