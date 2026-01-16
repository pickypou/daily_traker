import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/calculated_font_size.dart';

class AppTheme {
  // Palette de couleurs
  static const Color _background = Color(0xFFFFFDE1);
  static const Color _titles = Color(0xFF93BD57);
  static const Color _textNormal = Color(0xFFFBE580);
  static const Color _buttonBackground = Color(0xFF980404);
  static const Color _buttonText = Color(0xFFFBE580);

  // Paddings/marges standard
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  ThemeData theme(BuildContext context) {
    final titleFontSize = calculateTitleFontSize(context);
    final normalFontSize = calculateFontSize(context);
    final buttonFontSize = calculateFontSize(
      context,
    ); // Using same ratio for buttons for now

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _background,

      // Configuration des couleurs principales
      colorScheme: ColorScheme.fromSeed(
        seedColor: _titles,
        surface: _background,
        primary: _titles,
        secondary: _buttonBackground,
      ),

      // Configuration de l'AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: _background,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.roboto(
          color: _titles,
          fontSize: titleFontSize,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: _titles),
      ),

      // Configuration des Textes
      textTheme: TextTheme(
        displayLarge: GoogleFonts.roboto(
          color: _titles,
          fontSize: titleFontSize * 1.5, // Scaling up for displayLarge
        ),
        titleLarge: GoogleFonts.roboto(color: _titles, fontSize: titleFontSize),
        bodyLarge: GoogleFonts.lato(
          color: _textNormal,
          fontSize: normalFontSize,
        ),
        bodyMedium: GoogleFonts.lato(
          color: _textNormal,
          fontSize: normalFontSize,
        ),
        labelLarge: GoogleFonts.lato(
          color: _buttonText,
          fontSize: buttonFontSize,
        ),
      ),

      // Configuration des Boutons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _buttonBackground,
          foregroundColor: _buttonText,
          textStyle: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: buttonFontSize,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: paddingLarge,
            vertical: paddingMedium,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      // Configuration du Divider
      dividerTheme: const DividerThemeData(color: _buttonText, thickness: 1),
    );
  }
}
