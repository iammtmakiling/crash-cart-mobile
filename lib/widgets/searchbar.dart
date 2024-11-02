import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const SearchTextField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          // filled: true,
          // fillColor: Theme.of(context).primaryColorLight.withOpacity(0.1),
          hintText: "Search",
          filled: true,
          fillColor: Theme.of(context).primaryColorLight.withOpacity(0.1),
          labelStyle: Theme.of(context).textTheme.bodySmall,
          hintStyle: Theme.of(context).textTheme.bodySmall,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.1)),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: Icon(
            LucideIcons.search,
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
    );
  }
}
