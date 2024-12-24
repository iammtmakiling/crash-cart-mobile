import 'package:flutter/material.dart';
import 'package:dashboard/widgets/custom_modal.dart';
import 'package:dashboard/widgets/formWidgets/form_dropdown.dart';

class SubmitModal extends StatelessWidget {
  final String patientStatus;
  final List<String> statusOptions;
  final Function(String) onStatusChange;
  final VoidCallback onSubmit;

  const SubmitModal({
    super.key,
    required this.patientStatus,
    required this.statusOptions,
    required this.onStatusChange,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return CustomModal(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Status',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 16),
          FormDropdown(
            name: 'patientStatus',
            initialValue: patientStatus,
            items: statusOptions,
            onChange: (newValue) {
              onStatusChange(newValue.toString());
            },
          ),
        ],
      ),
      actionText: "Confirm",
      onActionPressed: onSubmit,
    );
  }
}
