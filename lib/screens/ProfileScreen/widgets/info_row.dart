import 'package:flutter/material.dart';

class AccountInfoRow extends StatelessWidget {
  final String title;
  final String info;

  const AccountInfoRow({
    super.key,
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).dividerColor),
          ),
          Flexible(
              child: Text(info, style: Theme.of(context).textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
