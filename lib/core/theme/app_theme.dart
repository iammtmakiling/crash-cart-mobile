import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_theme.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Primary and Secondary Colors
      primaryColor: AppColors.primary,
      primaryColorLight: AppColors.primaryVariant,
      hintColor: AppColors.secondary,
      canvasColor: AppColors.background,
      scaffoldBackgroundColor: AppColors.background,
      cardColor: AppColors.primaryVariant,

      // Text Theme
      textTheme: AppTextTheme.textTheme,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        color: AppColors.primary,
        iconTheme: const IconThemeData(color: AppColors.background),
        titleTextStyle: AppTextTheme.textTheme.headlineLarge?.copyWith(
          color: AppColors.background,
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: AppColors.background,
          backgroundColor: AppColors.primary,
          textStyle: AppTextTheme.textTheme.bodyLarge,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.circular(8),
          // ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextTheme.textTheme.bodyMedium,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.primaryVariant.withOpacity(0.1),
        labelStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextTheme.textTheme.bodyMedium?.copyWith(
          color: AppColors.textTertiary,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primaryVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.error),
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: AppColors.primary,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: AppColors.lightGray,
        thickness: 1,
      ),
    );
  }
}
