import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF10111B);
  static const Color surface = Color(0xFF1A1C2A);
  static const Color primary = Color(0xFF8B5CF6);
  static const Color secondary = Color(0xFF272A3B);
  static const Color textprimary = Color(0xFFF5F3FF);
  static const Color textsecondary = Color(0xFF9CA3AF);
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFF87171);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: danger,
      ),
      fontFamily: GoogleFonts.inter().fontFamily,
      textTheme: ThemeData(brightness: Brightness.dark).textTheme
          .apply(bodyColor: textprimary, displayColor: textprimary),

      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        elevation: 0,
        centerTitle: false,
      ),
      useMaterial3: true,
    );
  }
}
