import 'package:flutter/material.dart';

Widget viewInfoRow(String title, dynamic info) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Builder(
            builder: (context) => Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          flex: 4,
          child: info is List<String>
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: info.map((item) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (info.length != 1)
                          const Text("• ", style: TextStyle(fontSize: 14)),
                        Expanded(
                          child: Builder(
                            builder: (context) => Text(
                              item,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                )
              : Builder(
                  builder: (context) => Text(
                    info as String,
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                ),
        ),
      ],
    ),
  );
}
