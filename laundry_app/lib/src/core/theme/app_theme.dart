import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: AppColors.backgroundMain,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundAppBar,
        foregroundColor: AppColors.primary,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
          color: Color(0xFF27BDAE)
        ),
      ),
    );
  }
}
