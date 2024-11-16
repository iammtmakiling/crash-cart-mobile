import 'package:flutter/material.dart';
import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/core/theme/app_text_theme.dart';

class AppInputDecoration {
  static InputDecoration get standard => InputDecoration(
        filled: true,
        fillColor: AppColors.primary.withOpacity(0.01),
        labelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          color: AppColors.textPrimary,
        ),
        hintStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          color: AppColors.textTertiary,
        ),
        disabledBorder: _buildBorder(opacity: 0.1),
        enabledBorder: _buildBorder(opacity: 0.1),
        focusedBorder: _buildBorder(opacity: 0.5),
        errorBorder: _buildBorder(color: AppColors.error),
        focusedErrorBorder: _buildBorder(color: AppColors.error),
      );

  static InputDecoration withCustomColor({required Color? fillColor}) =>
      InputDecoration(
        filled: true,
        fillColor: fillColor,
        labelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
        ),
        hintStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
          color: AppColors.textTertiary,
        ),
        disabledBorder: _buildBorder(opacity: 0.1),
        enabledBorder: _buildBorder(opacity: 0.1),
        focusedBorder: _buildBorder(opacity: 0.5),
        errorBorder: _buildBorder(color: AppColors.error),
        focusedErrorBorder: _buildBorder(color: AppColors.error),
      );

  static OutlineInputBorder _buildBorder({
    double opacity = 1.0,
    Color color = AppColors.primary,
  }) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: color.withOpacity(opacity),
        ),
        borderRadius: BorderRadius.circular(8),
      );
}
