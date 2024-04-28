import 'package:flutter/material.dart';
import 'package:pink_book_app/ui/widget/theme/color_theme.dart';

class AppTheme {
  static ThemeData lightTheme =
      ThemeData(brightness: Brightness.light, primarySwatch: baseMaterial);

  static ThemeData darktheme =
      ThemeData(brightness: Brightness.dark, primarySwatch: baseMaterial);
}
