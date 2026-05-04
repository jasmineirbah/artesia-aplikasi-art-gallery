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
          Padding(
            padding: const EdgeInsets.only(top: 4), // 🔥 ini untuk TOP
            child: Row(
              children: [
                const SizedBox(width: 10), // 🔥 ini untuk LEFT
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 16,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
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