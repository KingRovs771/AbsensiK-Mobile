import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  static final appTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundColor,
    brightness: Brightness.dark,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.backgroundColor,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
  );
}
