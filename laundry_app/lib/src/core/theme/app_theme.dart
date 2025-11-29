import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: Color(0xFFECF2FB),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFECF2FB),
        foregroundColor: Color(0xFF27BDAE),
      ),
    );
  }
}
