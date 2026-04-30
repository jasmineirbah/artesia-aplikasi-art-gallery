import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBottomNavbar extends StatelessWidget {
  const CustomBottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 11,
      type: BottomNavigationBarType.fixed,

      // 🔥 TAMBAH INI
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      ),

      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.extension_outlined),
          label: "Game",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.mail_outline),
          label: "Inbox",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profile",
        ),
      ],
    );
  }
}