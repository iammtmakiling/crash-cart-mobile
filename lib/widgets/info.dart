import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;
  final FontWeight fontWeight;

  const Info({
    super.key,
    required this.label,
    required this.value,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.black.withOpacity(0.6),
                fontWeight: FontWeight.bold,
              ),
        ),
        const Spacer(),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.black.withOpacity(0.8),
              ),
        ),
      ],
    );
  }
}
