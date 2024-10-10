import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormDropdown extends StatelessWidget {
  final String name;
  final String? labelName;
  final List<dynamic> items;
  final String? Function(dynamic)? validator;
  final void Function(Object?)? onChange;
  final String? initialValue;

  const FormDropdown({
    super.key,
    required this.name,
    required this.items,
    this.labelName,
    this.validator,
    this.onChange,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDropdown(
        name: name,
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelName,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
          ),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        validator: validator,
        onChanged: onChange);
  }
}
