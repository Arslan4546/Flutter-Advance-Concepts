import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // 🔹 LIGHT TEXT THEME (colors handled by Material theme)
  static TextTheme get lightTextTheme => TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.poppins(fontSize: 16),
    bodyMedium: GoogleFonts.poppins(fontSize: 14),
  );

  // 🔹 DARK TEXT THEME (colors handled by Material theme)
  static TextTheme get darkTextTheme => TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
    bodyLarge: GoogleFonts.poppins(fontSize: 16),
    bodyMedium: GoogleFonts.poppins(fontSize: 14),
  );
}
