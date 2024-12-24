import 'package:dashboard/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormRadio extends StatelessWidget {
  final String name;
  final List<String> values;
  final List<String> texts;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool enabled;

  const FormRadio({
    super.key,
    required this.name,
    required this.values,
    required this.texts,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      builder: (field) {
        return Container(
          alignment: Alignment.centerLeft,
          child: Wrap(
            runSpacing: 8.0,
            children: List.generate((values.length / 2).ceil(), (rowIndex) {
              return Row(
                children: List.generate(2, (colIndex) {
                  final index = rowIndex * 2 + colIndex;
                  if (index >= values.length) return const Spacer();

                  return Expanded(
                    child: GestureDetector(
                      onTap: enabled
                          ? () {
                              final isSelected = field.value == values[index];
                              final newValue =
                                  isSelected ? null : values[index];
                              field.didChange(newValue);
                              if (onChanged != null) onChanged!(newValue);
                            }
                          : null,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          fillColor: Colors.transparent,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Radio<String>(
                              value: values[index],
                              groupValue: field.value,
                              onChanged: enabled
                                  ? (value) {
                                      final isSelected = field.value == value;
                                      final newValue =
                                          isSelected ? null : value;
                                      field.didChange(newValue);
                                      if (onChanged != null)
                                        onChanged!(newValue);
                                    }
                                  : null,
                              activeColor: AppColors.primary,
                            ),
                            Flexible(
                              child: Text(
                                texts[index],
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        );
      },
    );
  }
}
