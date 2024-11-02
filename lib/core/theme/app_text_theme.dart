import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTextTheme {
  static TextTheme get textTheme => const TextTheme(
        displayLarge: AppTextStyles.headline1, // Equivalent to `headline1`
        displayMedium: AppTextStyles.headline2, // Equivalent to `headline2`
        displaySmall: AppTextStyles.headline3, // Equivalent to `headline3`
        headlineLarge: AppTextStyles.largeTextBold, // Equivalent to `headline4`
        headlineMedium: AppTextStyles
            .largeTextLight, // Equivalent to `headline5` as a lighter option
        titleLarge: AppTextStyles.bodyLargeBold, // Equivalent to `headline6`
        titleMedium: AppTextStyles
            .bodyLargeLight, // Alternative for `headline6` with lighter weight
        bodyLarge: AppTextStyles.bodyRegularBold, // Equivalent to bodyText1
        bodyMedium: AppTextStyles
            .bodyRegularLight, // Equivalent to bodyText2 with light weight
        bodySmall: AppTextStyles.bodySmallLight, // Small body text
        labelLarge:
            AppTextStyles.bodySmallBold, // Label style for small bold text
        labelSmall:
            AppTextStyles.captionLight, // Caption for smallest light text (8)
        labelMedium: AppTextStyles.captionBold, // Smallest bold text (8)
      );
}

// Usage in the ThemeData
final ThemeData appTheme = ThemeData(
  textTheme: AppTextTheme.textTheme,
  // Additional theme customizations
);
