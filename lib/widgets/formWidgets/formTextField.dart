import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/core/theme/app_text_theme.dart';
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
            filled: true,
            fillColor: AppColors.primaryVariant.withOpacity(0.1),
            labelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
            hintStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
              color: AppColors.textTertiary,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.error),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.error),
              borderRadius: BorderRadius.circular(8),
            ),
            prefixIcon: prefixIcon,
          ),
          validator: validator),
    );
  }
}
