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
              style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.cyan,
              ),
              onPressed: onTap,
            ),
          ],
        ),
        if (isExpanded) widget,
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
      ],
    );
  }
}
