import 'package:dashboard/features/viewFeature/components/view_arrow_icon.dart';
import 'package:flutter/material.dart';

class ExpandButton extends StatelessWidget {
  final bool isExpanded;
  final String text;
  final VoidCallback onTap;
  final Widget widget;

  const ExpandButton({
    required this.text,
    required this.isExpanded,
    required this.widget,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: isExpanded ? FontWeight.w700 : FontWeight.w500,
                  ),
            ),
            ViewArrowIcon(
              isExpanded: isExpanded,
              onTap: onTap,
            ),
          ],
        ),
        if (isExpanded)
          Divider(
            color: Colors.black.withOpacity(0.8),
            thickness: 0.4,
          ),
        const SizedBox(height: 8),
        if (isExpanded) widget,
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
      ],
    );
  }
}
