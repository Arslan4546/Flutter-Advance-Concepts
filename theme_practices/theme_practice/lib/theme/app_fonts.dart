import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // 🔹 LIGHT TEXT THEME
  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.lightText,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.lightText,
    ),
    bodyLarge: GoogleFonts.poppins(fontSize: 16, color: AppColors.lightText),
    bodyMedium: GoogleFonts.poppins(fontSize: 14, color: AppColors.lightText),
  );

  // 🔹 DARK TEXT THEME
  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: AppColors.darkText,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.darkText,
    ),
    bodyLarge: GoogleFonts.poppins(fontSize: 16, color: AppColors.darkText),
    bodyMedium: GoogleFonts.poppins(fontSize: 14, color: AppColors.darkText),
  );
}
