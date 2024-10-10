import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String detailTitle;
  final String detailText;

  const UserDetail({
    super.key,
    required this.icon,
    this.iconSize = 40,
    required this.detailTitle,
    required this.detailText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.cyan, size: iconSize),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detailTitle,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  detailText,
                  style: const TextStyle(fontSize: 18),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
