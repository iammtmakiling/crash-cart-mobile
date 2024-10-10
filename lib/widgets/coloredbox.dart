import 'package:flutter/material.dart';

Widget coloredBox(String text1, String text2, Color color) {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0), // Rounded corners
      color: color,
      boxShadow: [
        BoxShadow(
          color: color,
          blurRadius: 2,
          spreadRadius: 1,
        ),
      ],
    ),
    child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        text1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        text2,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    ])),
  );
}
