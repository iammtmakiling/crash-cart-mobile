// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/core/theme/app_text_theme.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CustomDateTimePicker extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final bool ifPatientExist;
  final Future<Map<String, dynamic>> Function(Map<String, dynamic> value)
      checkIfPatientExist;
  final void Function(BuildContext context, dynamic patient)
      showExistingPatient;
  final String name;
  final void Function(DateTime?)? onChanged;

  const CustomDateTimePicker({
    super.key,
    required this.formKey,
    required this.ifPatientExist,
    required this.checkIfPatientExist,
    required this.showExistingPatient,
    required this.name,
    this.onChanged,
  });

  @override
  CustomDateTimePickerState createState() => CustomDateTimePickerState();
}

class CustomDateTimePickerState extends State<CustomDateTimePicker> {
  @override
  Widget build(BuildContext context) {
    return FormBuilderDateTimePicker(
      inputType: InputType.date,
      name: widget.name,
      enabled: !widget.ifPatientExist,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      format: DateFormat('yyyy-MM-dd'),
      onChanged: (DateTime? value) async {
        var patientAge;

        if (!widget.ifPatientExist) {
          widget.formKey.currentState!.save();
          Map<String, dynamic>? patientData = await widget
              .checkIfPatientExist(widget.formKey.currentState!.value);

          if (patientData['isFound'] == true) {
            // ignore: use_build_context_synchronously
            widget.showExistingPatient(context, patientData['patient']);
          }
        }

        setState(() {
          if (value != null) {
            patientAge = calculateAge(value);
            widget.formKey.currentState!.fields['age']!
                .didChange(patientAge.toString());
          }
        });

        // Call the provided onChanged callback if it's not null
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      decoration: InputDecoration(
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
