import 'package:flutter/material.dart';

class GalleryAccent extends StatelessWidget {
  const GalleryAccent({
    super.key,
    this.width = 170,
    this.height = 96,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// 🔹 Kotak kiri bawah
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: width * 0.38,
              height: height * 0.6,
              color: const Color(0xFFF8EBDD),
            ),
          ),

          /// 🔹 Shape tengah (curve)
          Positioned(
            left: width * 0.18,
            bottom: 0,
            child: Container(
              width: width * 0.45,
              height: height * 0.8,
              decoration: const BoxDecoration(
                color: Color(0xFFF3E3C5),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                ),
              ),
            ),
          ),

          /// 🔹 Shape kanan tinggi
          Positioned(
            right: width * 0.1,
            bottom: 0,
            child: Container(
              width: width * 0.38,
              height: height,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D8CC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(80),
                ),
              ),
            ),
          ),

          /// 🔹 Kotak kecil depan
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: width * 0.2,
              height: width * 0.2,
              color: const Color(0xFFF5C76E),
            ),
          ),
        ],
      ),
    );
  }
}