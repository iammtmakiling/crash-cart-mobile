import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    hintColor: Colors.cyan,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.blue,
      iconTheme: IconThemeData(color: Colors.blue),
    ),
    textTheme: GoogleFonts.poppinsTextTheme()
        .apply(
          bodyColor: Colors.black,
          fontSizeFactor: 1.0,
          decoration: TextDecoration.none,
        )
        .copyWith(
          bodyLarge: GoogleFonts.poppins(fontSize: 36.0),
          bodyMedium: GoogleFonts.poppins(fontSize: 24.0),
          bodySmall: GoogleFonts.poppins(fontSize: 16.0),
        ),
    buttonTheme: const ButtonThemeData(
      buttonColor:Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),

    iconTheme:
        const IconThemeData(color: Colors.blue), // Use hex color #336CFB
    colorScheme: ThemeData().colorScheme.copyWith(
          secondary: Colors.blue, // Use hex color #336CFB
        ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.grey[400]),
      labelStyle: const TextStyle(color: Colors.grey, fontSize: 22.0),
      // enabledBorder: OutlineInputBorder(
      //   borderSide: const BorderSide(color: Colors.grey),
      //   borderRadius: BorderRadius.circular(8.0),
      // ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.teal),
        borderRadius: BorderRadius.circular(8.0),
      ),

      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
    ),
  );
}
