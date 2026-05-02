import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30), 
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: const Icon(Icons.search),
          hintText: "Search Painting",
          hintStyle: GoogleFonts.inter(color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}