import 'package:dashboard/core/theme/app_colors.dart';
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
          // Add notification handling here
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
