import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatelessWidget {
  const InputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
    this.onFieldSubmitted,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 🔹 LABEL
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF76706B),
          ),
        ),

        const SizedBox(height: 6),

        /// 🔹 INPUT
        TextFormField(
          controller: controller,
          textInputAction: textInputAction,
          obscureText: obscureText,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 13,
              color: const Color(0xFF928C86),
            ),

            /// 🔹 ICON (optional)
            suffixIcon: suffixIcon,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),

            /// 🔹 SPACING FIX (biar konsisten)
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 10),

            /// 🔹 BORDER STYLE
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8C867F)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1.4),
            ),
            errorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB45A4B)),
            ),
            focusedErrorBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFB45A4B), width: 1.4),
            ),

            /// 🔹 ERROR TEXT
            errorStyle: GoogleFonts.inter(
              fontSize: 10,
              color: const Color(0xFFB45A4B),
            ),
          ),
        ),
      ],
    );
  }
}