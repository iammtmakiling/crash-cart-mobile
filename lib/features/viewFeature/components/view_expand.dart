import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ExpandButton extends StatelessWidget {
  final String text;
  final Widget widget;
  final VoidCallback onTap;
  final bool withAdd;
  const ExpandButton({
    required this.text,
    required this.widget,
    required this.onTap,
    this.withAdd = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBe,
            children: [
              Text(
                text,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(LucideIcons.edit),
                onPressed: onTap,
                iconSize: 16,
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              // const SizedBox(width: 8),
              IconButton(
                icon: const Icon(LucideIcons.plus),
                onPressed: onTap,
                iconSize: 16,
                style: IconButton.styleFrom(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.black.withOpacity(0.8),
          thickness: 0.4,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: widget,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
