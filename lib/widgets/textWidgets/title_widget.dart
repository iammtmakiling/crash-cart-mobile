import 'package:dashboard/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final bool isRequired;

  const TitleWidget({
    super.key,
    required this.title,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      textAlign: TextAlign.start,
      TextSpan(
        text: title,
        style: Theme.of(context).textTheme.bodyMedium,
        children: <TextSpan>[
          if (isRequired)
            TextSpan(
              text: '*',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
        ],
      ),
    );
  }
}
