import 'package:flutter/material.dart';
import 'package:artesia_aplikasi_art_gallery/views/home/home_page.dart';
import 'package:artesia_aplikasi_art_gallery/views/game/game_page.dart';
import 'package:artesia_aplikasi_art_gallery/widgets/bottom_navbar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomePage(),
    const GamePage(),
    const Center(child: Text("Inbox Page")),
    const Center(child: Text("Profile Page")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: CustomBottomNavbar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}