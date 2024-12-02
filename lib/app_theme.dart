import 'package:flutter/material.dart';

class AppTheme {
  // Base constants for consistent styling
  static const double _borderRadius = 8.0;
  static const EdgeInsets _buttonPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 20);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: _colorScheme.surface,
      appBarTheme: _appBarTheme,
      cardTheme: _cardTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
      textTheme: _textTheme,
    );
  }

  // New Bluish Color Scheme
  static const ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF007BFF), // Deep sky blue
    onPrimary: Colors.white,
    secondary: Color(0xFF5BC0EB), // Soft teal blue
    onSecondary: Colors.white,
    error: Color(0xFFFF6B6B), // Warm coral red
    onError: Colors.white, // Rich dark blue-gray
    surface: Color(0xFFFFFFFF), // White
    onSurface: Color(0xFF34495E), // Neutral dark blue for text
  );

  // AppBar Theme
  static final AppBarTheme _appBarTheme = AppBarTheme(
    backgroundColor: Colors.transparent,
    foregroundColor: _colorScheme.onSurface,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _colorScheme.onSurface,
    ),
    iconTheme: IconThemeData(color: _colorScheme.onSurface),
  );

  // Card Theme
  static final CardTheme _cardTheme = CardTheme(
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(_borderRadius)),
    ),
    color: _colorScheme.surface,
  );

  // Elevated Button Theme
  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _colorScheme.primary,
      foregroundColor: _colorScheme.onPrimary,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      padding: _buttonPadding,
      elevation: 1,
    ),
  );

  // Outlined Button Theme
  static final OutlinedButtonThemeData _outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: _colorScheme.primary,
      side: BorderSide(color: _colorScheme.primary, width: 1),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      padding: _buttonPadding,
    ),
  );

  // Input Decoration Theme
  static final InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    filled: true,
    fillColor: _colorScheme.surface.withOpacity(0.5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: _colorScheme.onSurface.withOpacity(0.2)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: _colorScheme.primary, width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: _colorScheme.onSurface.withOpacity(0.2)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_borderRadius),
      borderSide: BorderSide(color: _colorScheme.error, width: 2),
    ),
    labelStyle: TextStyle(color: _colorScheme.onSurface.withOpacity(0.6)),
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
  );

  // Text Theme
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
    displaySmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
  );
}
