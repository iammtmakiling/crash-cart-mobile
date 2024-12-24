import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_theme.dart';

class FormDateTimePicker extends StatelessWidget {
  final String name;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateFormat? format;
  final String? labelText;
  final bool? enabled;
  final Function(DateTime?)? onChanged;
  final bool isRequired;

  const FormDateTimePicker({
    super.key,
    required this.name,
    this.firstDate,
    this.lastDate,
    this.format,
    this.labelText,
    this.enabled,
    this.onChanged,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      name: name,
      enabled: enabled ?? true,
      firstDate: firstDate ?? DateTime(1900),
      lastDate: lastDate ?? DateTime.now(),
      format: format ?? DateFormat('yyyy-MM-dd HH:mm:ss'),
      validator: isRequired ? FormBuilderValidators.required() : null,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: const Icon(Icons.calendar_month, color: AppColors.primary),
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
      ),
    );
  }
}
