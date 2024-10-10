import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormRadio extends StatelessWidget {
  final String name;
  final List<String> values;
  final List<String> texts;
  final void Function(dynamic)? onChanged;
  final String? Function(dynamic)? validator;
  final String? initialValue;
  final bool enabled;

  const FormRadio(
      {super.key,
      required this.name,
      required this.values,
      required this.texts,
      required this.enabled,
      this.onChanged,
      this.validator,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    List<FormBuilderFieldOption> options = [];
    for (int i = 0; i < values.length; i++) {
      options
          .add(FormBuilderFieldOption(value: values[i], child: Text(texts[i])));
    }

    return FormBuilderRadioGroup(
        name: name,
        onChanged: onChanged,
        // ignore: unnecessary_null_comparison
        enabled: enabled != null ? true : enabled,
        initialValue: initialValue,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          labelStyle: TextStyle(fontSize: 18),
        ),
        options: options,
        validator: validator);
  }
}
