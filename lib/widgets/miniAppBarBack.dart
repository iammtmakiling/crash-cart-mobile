import 'package:flutter/material.dart';

class MiniAppBarBack extends StatelessWidget {
  final bool showButton;
  final VoidCallback onBack;

  const MiniAppBarBack({
    super.key,
    this.showButton = true,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyan, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                if (showButton)
                  IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white), // Custom icon
                      onPressed: () => {onBack()}),
                const Text(
                  'CrashCart',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
