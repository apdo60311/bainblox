import 'package:flutter/material.dart';

class ApplicationTheme {
  static ThemeData lightMode = ThemeData(
      primaryColor: const Color(0xFF004B76),
      textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          titleMedium: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white)));
}
