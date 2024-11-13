import 'package:flutter/material.dart';
import 'app_text_styles.dart';

class AppTextTheme {
  static TextTheme get textTheme => const TextTheme(
        displayLarge: AppTextStyles.headline1,
        displayMedium: AppTextStyles.headline2,
        displaySmall: AppTextStyles.headline3,
        headlineLarge: AppTextStyles.largeTextBold,
        headlineMedium: AppTextStyles.largeTextLight,
        titleLarge: AppTextStyles.bodyLargeBold,
        titleMedium: AppTextStyles.bodyLargeLight,
        bodyLarge: AppTextStyles.bodyRegularBold,
        bodyMedium: AppTextStyles.bodyRegularLight,
        bodySmall: AppTextStyles.bodySmallLight,
        labelLarge: AppTextStyles.bodySmallBold,
        labelSmall: AppTextStyles.captionLight,
        labelMedium: AppTextStyles.captionBold,
      );
}

final ThemeData appTheme = ThemeData(
  textTheme: AppTextTheme.textTheme,
);
