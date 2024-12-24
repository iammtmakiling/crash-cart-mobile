import 'package:flutter/material.dart';
import 'package:dashboard/widgets/custom_modal.dart';
import 'package:dashboard/core/theme/app_text_theme.dart';

class ResetModal extends StatelessWidget {
  final VoidCallback onReset;

  const ResetModal({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset Form',
            style: AppTextTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'Are you sure you want to reset the form? All unsaved data will be lost.',
            style: AppTextTheme.textTheme.bodyMedium,
          ),
        ],
      ),
      actionText: "Reset",
      onActionPressed: onReset,
    );
  }
}
