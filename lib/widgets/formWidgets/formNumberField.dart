import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormNumberField extends StatelessWidget {
  final String name;
  final String labelName;
  final String? Function(dynamic)? validator;
  final String? initialValue;

  const FormNumberField(
      {super.key,
      required this.name,
      required this.labelName,
      this.validator,
      this.initialValue});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      // widthFactor: 0.95,
      child: InkWell(
        child: FormBuilderTextField(
            name: name,
            initialValue: initialValue,
            autocorrect: false,
            // keyboardType: TextInputType.number, // Set keyboard type to number
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
            validator: validator),
      ),
    );
  }
}
