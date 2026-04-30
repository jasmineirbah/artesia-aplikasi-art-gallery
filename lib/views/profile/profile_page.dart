import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../services/session_service.dart';
import '../../widgets/app_logo.dart';
import 'nearby_gallery_sheet.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void showNearby(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NearbyGallerySheet(),
    );
  }

  Future<void> logout(BuildContext context) async {
    await SessionService().clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),

      /// 🔥 APP BAR (LOGO)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const AppLogo(),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// 🔥 PROFILE IMAGE
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 40),
            ),

            const SizedBox(height: 16),

            /// 🔥 NAME
            Text(
              "User Name",
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Art Enthusiast",
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 MENU LIST
            _buildMenuItem("Edit Profile"),
            _buildMenuItem("My Orders"),
            _buildMenuItem("My Collections"),

            /// 🔥 NEARBY (CLICKABLE)
            GestureDetector(
              onTap: () => showNearby(context),
              child: Column(
                children: [
                  _buildMenuItem("Nearby Galleries"),
                  const SizedBox(height: 4),
                  Container(
                    width: 40,
                    height: 2,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),

            _buildMenuItem("Settings"),

            const SizedBox(height: 30),

            /// 🔥 LOGOUT BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// 🔥 MENU ITEM UI
  Widget _buildMenuItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14),
        ],
      ),
    );
  }
}