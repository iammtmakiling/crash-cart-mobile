import 'package:dashboard/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:dashboard/widgets/custom_modal.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ErrorModal extends StatelessWidget {
  final VoidCallback onClose;

  const ErrorModal({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              LucideIcons.alertTriangle,
              size: 48,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              "An error occurred while processing your request.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
