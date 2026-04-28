import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFFFF8C00);
  static const primary2 = Color.fromARGB(255, 248, 160, 52);
  static const lightPrimary = Color(0xFFFFD699);
  static const primaryBackground = Color(0xFFFDF7EF);
  static const secondary = Color(0xFF00829F);
  static const secondaryLight = Color.fromARGB(255, 69, 164, 185);
  static const accent = Color(0xFF002B5B);
  static const dividerColor = Color(0xFFD1D1D1);
  static const white = Color(0xFFffffff);
  //Text
  static const darkText = Color(0xFF2C2C2C);
  static const mediumText = Color(0xFF555555);
  static const lightText = Color(0xFF888888);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: AppColors.accent),
  scaffoldBackgroundColor: Colors.white,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: "poppins",
);
