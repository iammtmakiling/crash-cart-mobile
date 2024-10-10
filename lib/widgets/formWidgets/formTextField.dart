import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormTextField extends StatelessWidget {
  final String name;
  final String labelName;
  final String? initialValue;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final bool? enabled;
  final Icon? prefixIcon;

  const FormTextField(
      {super.key,
      required this.name,
      required this.labelName,
      this.enabled,
      this.initialValue,
      this.onChanged,
      this.validator,
      this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled ?? true;
    return InkWell(
      child: FormBuilderTextField(
          initialValue: initialValue,
          name: name,
          autocorrect: false,
          enabled: isEnabled,
          onChanged: onChanged,
          decoration: InputDecoration(
              labelText: labelName,
              labelStyle: const TextStyle(color: Colors.grey),
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              prefixIcon: prefixIcon),
          validator: validator),
    );
  }
}
