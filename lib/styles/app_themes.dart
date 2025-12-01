// lib/styles/app_themes.dart

import 'package:flutter/material.dart';
import 'package:nanas_mobile/styles/colors.dart';
import 'package:nanas_mobile/styles/sizes.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: kBodyLightColor,
    fontFamily: 'myFont',
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.all(Color(0xFFd1d5db)),
      radius: Radius.circular(16),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: kFontSizeMedium,
        fontWeight: FontWeight.normal,
        color: kTextColorMedium,
      ),
      bodySmall: TextStyle(
        fontSize: kFontSizeSmall,
        fontWeight: FontWeight.normal,
        color: kTextColorMedium,
      ),
      titleSmall: TextStyle(
        fontSize: kFontSizeSmall,
        fontWeight: FontWeight.bold,
        color: kTextColorHigh,
      ),
      titleMedium: TextStyle(
        fontSize: kFontSizeMedium,
        fontWeight: FontWeight.bold,
        color: kTextColorHigh,
      ),
      titleLarge: TextStyle(
        fontSize: kFontSizeLarge,
        fontWeight: FontWeight.bold,
        color: kTextColorHigh,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: kBodyDarkColor,
    fontFamily: 'myFont',
    scrollbarTheme: ScrollbarThemeData(
      thumbColor: MaterialStateProperty.all(Color(0xFF9E9E9E)),
      radius: Radius.circular(16),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontSize: kFontSizeMedium,
        fontWeight: FontWeight.normal,
        color: kWhiteColor,
      ),
      bodySmall: TextStyle(
        fontSize: kFontSizeSmall,
        fontWeight: FontWeight.normal,
        color: kWhiteColor,
      ),
      titleSmall: TextStyle(
        fontSize: kFontSizeSmall,
        fontWeight: FontWeight.bold,
        color: kWhiteColor,
      ),
      titleMedium: TextStyle(
        fontSize: kFontSizeMedium,
        fontWeight: FontWeight.bold,
        color: kWhiteColor,
      ),
      titleLarge: TextStyle(
        fontSize: kFontSizeLarge,
        fontWeight: FontWeight.bold,
        color: kWhiteColor,
      ),
    ),
  );
}
