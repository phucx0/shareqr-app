import 'package:flutter/material.dart';

// App Theme
class AppTheme {
  // Dark Colors
  static const Color darkest = Color(0xFF0F172A);
  static const Color dark = Color(0xFF1E293B);
  static const Color medium = Color(0xFF283447);
  static const Color primaryBlue = Color(0xFF3B82F6);
  
  // Light Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color primaryOrange = Color(0xFFFF5722);
  
  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkest,
    primaryColor: primaryBlue,
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      secondary: primaryBlue,
      surface: dark,
      background: darkest,
    ),
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: darkest,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: white),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: dark,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: medium, width: 1),
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: white,
        side: const BorderSide(color: medium, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: dark,
      hintStyle: const TextStyle(
        color: Colors.white70,
        fontSize: 14
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: medium),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: medium),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: white, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: white, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: white, fontSize: 16),
      bodyMedium: TextStyle(color: white, fontSize: 14),
      bodySmall: TextStyle(color: Colors.white70, fontSize: 12),
    ),

  );
  
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: white,
    primaryColor: primaryOrange,
    colorScheme: const ColorScheme.light(
      primary: primaryOrange,
      secondary: primaryOrange,
      surface: Colors.white,
      background: Colors.grey,
    ),
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: black),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        side: const BorderSide(color: primaryOrange, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      hintStyle: const TextStyle(
        color:  Colors.black87,
        fontSize: 14
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: black, fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: black, fontSize: 28, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: black, fontSize: 24, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(color: black, fontSize: 16),
      bodyMedium: TextStyle(color: black, fontSize: 14),
      bodySmall: TextStyle(color: Colors.black54, fontSize: 12),
    ),
  );
}
