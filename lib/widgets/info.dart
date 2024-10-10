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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
      ],
    );
  }
}
