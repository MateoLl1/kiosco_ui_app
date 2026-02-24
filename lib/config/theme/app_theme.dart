import 'package:flutter/material.dart';


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

  ThemeData getTheme() => ThemeData(
    useMaterial3: true,
    brightness: isDark ? Brightness.dark : Brightness.light,
    colorSchemeSeed: colorsAppTheme[selectedColor],
    fontFamily: 'Montserrat',
  );
}