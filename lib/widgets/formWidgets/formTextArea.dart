import 'package:dashboard/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormTextArea extends StatelessWidget {
  final String name;
  final String labelName;
  final String? initialValue;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final bool? enabled;
  final Icon? prefixIcon;
  final int? minLines;
  final int? maxLines;

  const FormTextArea({
    super.key,
    required this.name,
    required this.labelName,
    this.enabled,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.minLines = 3,
    this.maxLines = 8,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled ?? true;
    return FormBuilderTextField(
      initialValue: initialValue,
      name: name,
      autocorrect: false,
      enabled: isEnabled,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: TextInputType.multiline,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.primaryVariant.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: AppColors.primaryVariant.withOpacity(0.1),
          ),
        ),
        labelText: labelName,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: Theme.of(context).textTheme.bodyMedium,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 15.0,
        ),
        prefixIcon: prefixIcon,
      ),
      validator: validator,
    );
  }
}
