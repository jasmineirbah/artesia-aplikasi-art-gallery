import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.text = 'A R T E S I A',
    this.fontSize = 10,
    this.showBackButton = false,
  });

  final String text;
  final double fontSize;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// 🔹 Back Button (optional)
          if (showBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ),

          /// 🔹 Logo Text
          Text(
            text,
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}