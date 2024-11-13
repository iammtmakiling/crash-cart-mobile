import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

AppBar mainAppBar(BuildContext context) {
  return AppBar(
    title: Text('CrashCart', style: Theme.of(context).textTheme.titleLarge),
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
      child: Divider(height: 1.0),
    ),
  );
}
