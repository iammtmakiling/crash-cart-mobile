import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormCheckbox extends StatelessWidget {
  final String name;
  final List<dynamic> options;
  final String? Function(dynamic)? validator;
  final List<dynamic>? initialValue;

  const FormCheckbox(
      {super.key,
      required this.name,
      required this.options,
      this.validator,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return FormBuilderCheckboxGroup(
      name: name,
      validator: validator,
      initialValue: initialValue,
      options: options
          .map((option) => FormBuilderFieldOption(
                value: option,
                child: Text(option),
              ))
          .toList(),
    );
  }
}
