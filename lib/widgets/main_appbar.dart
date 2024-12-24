import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/widgets/custom_modal.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

AppBar mainAppBar(BuildContext context, String title) {
  return AppBar(
    title: Text(title, style: Theme.of(context).textTheme.titleLarge),
    centerTitle: true,
    leading: Icon(LucideIcons.activitySquare,
        color: Theme.of(context).iconTheme.color),
    actions: [
      IconButton(
        icon: Icon(LucideIcons.info, color: Theme.of(context).iconTheme.color),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => CustomModal(
              body: Column(
                children: [
                  Text(
                    'Crash Cart Information',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'It is a Trauma Registry Tool that allows doctors to collect patient data. It is used to track, streamline, and report patient data for trauma care.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(1.0),
      child: Divider(
        height: 1.0,
        color: AppColors.textPrimary.withOpacity(0.08),
      ),
    ),
  );
}
