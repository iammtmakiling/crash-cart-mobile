import 'package:dashboard/core/theme/app_colors.dart';
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
    return Container(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 0,
        children: List.generate(values.length, (i) {
          final textSpan = TextSpan(
            text: texts[i],
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
            child: FormBuilderRadioGroup(
              name: name + i.toString(),
              onChanged: (value) {
                if (value != null) {
                  onChanged!(values[i]);
                }
              },
              initialValue: initialValue == values[i] ? values[i] : null,
              activeColor: AppColors.primary,
              orientation: OptionsOrientation.horizontal,
              decoration: const InputDecoration(
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              options: [
                FormBuilderFieldOption(
                  value: values[i],
                  child: Text(
                    texts[i],
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
