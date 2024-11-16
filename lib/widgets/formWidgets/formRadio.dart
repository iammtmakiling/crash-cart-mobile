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
      child: FormBuilderRadioGroup(
        name: name,
        onChanged: onChanged,
        initialValue: initialValue,
        activeColor: AppColors.primary,
        orientation: OptionsOrientation.horizontal,
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        options: List.generate(values.length, (i) {
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
              textPainter.width > MediaQuery.of(context).size.width * 0.2;

          return FormBuilderFieldOption(
            value: values[i],
            child: SizedBox(
              width: shouldUseFullWidth
                  ? MediaQuery.of(context).size.width - 32
                  : MediaQuery.of(context).size.width / 5,
              child: Text(
                texts[i],
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          );
        }),
      ),
    );
  }
}
