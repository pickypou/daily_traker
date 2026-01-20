import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/calculated_font_size.dart';

class AppTheme {
  // Palette de couleurs (privées)
  static const Color _background = Color(0xFFFFFDE1);
  static const Color _titles = Color(0xFF93BD57);
  static const Color _textNormal = Colors.black;
  static const Color _buttonBackground = Color(0xFF980404);
  static const Color _buttonText = Color(0xFFFBE580);

  // Paddings/marges standard
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // ====== GETTERS PUBLICS POUR BOUTONS ======
  static Color get buttonBackgroundColor => _buttonBackground;
  static Color get buttonTextColor => _buttonText;

  static TextStyle buttonTextStyle(BuildContext context) {
    final buttonFontSize = calculateFontSize(context);
    return GoogleFonts.lato(
      color: _buttonText,
      fontSize: buttonFontSize,
      fontWeight: FontWeight.bold,
    );
  }

  // ====== STYLES TEXTES ======
  static TextStyle titleStyle(BuildContext context) {
    final titleFontSize = calculateTitleFontSize(context);
    return GoogleFonts.roboto(
      color: _titles,
      fontSize: titleFontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle bodyStyle(BuildContext context) {
    final normalFontSize = calculateFontSize(context);
    return GoogleFonts.lato(
      color: _textNormal,
      fontSize: normalFontSize,
    );
  }

  // ====== THEME DATA POUR FLUTTER ======
  ThemeData theme(BuildContext context) {
    final titleFontSize = calculateTitleFontSize(context);
    final normalFontSize = calculateFontSize(context);
    final buttonFontSize = calculateFontSize(context);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _background,

      // Couleurs principales
      colorScheme: ColorScheme.fromSeed(
        seedColor: _titles,
        surface: _background,
        primary: _titles,
        secondary: _buttonBackground,
      ),

      // AppBar
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

      // Textes
      textTheme: TextTheme(
        displayLarge: GoogleFonts.roboto(
          color: _titles,
          fontSize: titleFontSize * 1.5,
        ),
        titleLarge: GoogleFonts.roboto(
          color: _titles,
          fontSize: titleFontSize,
        ),
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
          fontWeight: FontWeight.bold,
        ),
      ),

      // Boutons
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: _buttonText,
        thickness: 1,
      ),
    );
  }
}
