import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  static final TextStyle headlineLarge = GoogleFonts.nunito(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.dark,
  );

  static final TextStyle headlineMedium = GoogleFonts.nunito(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.dark,
  );

  static final TextStyle headlineSmall = GoogleFonts.nunito(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  static final TextStyle titleLarge = GoogleFonts.nunito(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.dark,
  );

  static final TextStyle titleMedium = GoogleFonts.nunito(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.dark,
  );

  static final TextStyle bodyLarge = GoogleFonts.nunito(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
  );

  static final TextStyle bodyMedium = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.dark,
  );

  static final TextStyle bodySmall = GoogleFonts.nunito(
    fontSize: 14,
    fontWeight: FontWeight.w300,
    color: AppColors.dark.withOpacity(0.7),
  );

  static final TextStyle labelLarge = GoogleFonts.nunito(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}
