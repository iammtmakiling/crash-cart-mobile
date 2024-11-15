import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormCheckbox extends StatelessWidget {
  final String name;
  final List<dynamic> options;
  final String? Function(dynamic)? validator;
  final List<dynamic>? initialValue;

  const FormCheckbox({
    super.key,
    required this.name,
    required this.options,
    this.validator,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 0,
        children: List.generate(options.length, (i) {
          final textSpan = TextSpan(
            text: options[i].toString(),
            style: Theme.of(context).textTheme.bodySmall,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
            maxLines: 1,
          )..layout();

          final shouldUseFullWidth =
              textPainter.width > MediaQuery.of(context).size.width * 0.25;

          return SizedBox(
            width: shouldUseFullWidth
                ? MediaQuery.of(context).size.width - 16
                : MediaQuery.of(context).size.width / 2.7,
            child: FormBuilderCheckboxGroup(
              name: name + i.toString(),
              initialValue: initialValue?.contains(options[i]) == true
                  ? [options[i]]
                  : [],
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              options: [
                FormBuilderFieldOption(
                  value: options[i],
                  child: Text(
                    options[i].toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
