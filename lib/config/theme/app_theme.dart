import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const colorsAppTheme = <Color>[
  Colors.blueAccent,
  Colors.deepOrangeAccent,
  Colors.greenAccent,
];

class AppTheme {
  final bool isDark;
  final int selectedColor;

  AppTheme({
    this.isDark = false,
    this.selectedColor = 0,
  });

  ThemeData getTheme() {
    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorSchemeSeed: colorsAppTheme[selectedColor],
    );

    return baseTheme.copyWith(
      textTheme: GoogleFonts.interTextTheme(baseTheme.textTheme),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}