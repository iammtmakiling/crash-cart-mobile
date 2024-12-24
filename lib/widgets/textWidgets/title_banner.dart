import 'package:flutter/material.dart';
import 'package:dashboard/core/theme/app_colors.dart';

class TitleBanner extends StatelessWidget {
  final String title;

  const TitleBanner({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 32.0,
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.primary,
              ),
        ),
      ),
    );
  }
}
