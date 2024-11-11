import 'package:dashboard/features/viewFeature/viewMain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PatientBox extends StatelessWidget {
  final bool viewMoreStatus;
  final Map<String, dynamic> patient;

  const PatientBox({
    super.key,
    required this.patient,
    required this.viewMoreStatus,
  });

  String getFormattedName(Map<String, dynamic> patientGeneralData) {
    String firstName = patientGeneralData['firstName'];
    String middleName = patientGeneralData['middleName'] != null
        ? "${patientGeneralData['middleName'][0]}."
        : '';
    String lastName = patientGeneralData['lastName'];
    return "$lastName, $firstName $middleName";
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Emergency Room':
        return Colors.yellow;
      case 'Pending Surgery':
        return const Color(0xFFF3B43F); // Orange #FF7F00
      case 'In-Surgery':
        return const Color(0xFFD42323); // Red
      case 'In-Hospital':
        return const Color(0xFF2E2EAA); // Blue
      case 'Pending Discharge':
        return Colors.lightGreen;
      case 'Discharged':
        return const Color(0xFF2EBB2E); // Green
      default:
        return const Color(0xFF353535); // Grey as default
    }
  }

  String formatDate(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
    } catch (e) {
      print('Error parsing date: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientRecord = patient['record'];
    final patientGeneralData = patient['general'];
    final name = getFormattedName(patientGeneralData);
    final admissionDate =
        formatDate(patientRecord['preHospital']['injuryTimestamp']);
    final statusColor = getStatusColor(patientRecord['patientStatus']);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.2),
                radius: 12,
                child: Icon(Icons.circle, color: statusColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                patientRecord['patientStatus'],
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              Text(
                admissionDate,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.6),
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            calculateAge(patientGeneralData['birthday']),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(0.8),
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                patientRecord['patientID'],
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.black.withOpacity(0.6),
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: Icon(
                  LucideIcons.arrowRightCircle,
                  color: Colors.black.withOpacity(0.8),
                ),
                onPressed: () {
                  Get.to(
                    ViewMain(
                      onBack: () {},
                      patient: patient,
                      unparsedPatient: patient['unparsedRecord'],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String calculateAge(String birthday) {
  DateTime birthDate = DateTime.parse(birthday);
  DateTime today = DateTime.now();

  int years = today.year - birthDate.year;
  int months = today.month - birthDate.month;
  int days = today.day - birthDate.day;

  // Adjust for cases where the birthday hasn't occurred yet this year
  if (months < 0 || (months == 0 && days < 0)) {
    years--;
    months += (months < 0 ? 12 : 0);
  }

  if (years > 0) {
    return "$years years old";
  } else {
    return "$months months old";
  }
}
