import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/features/viewFeature/view_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PatientBox extends StatelessWidget {
  final bool viewMoreStatus;
  final Map<String, dynamic> patient;
  final bool isTile;

  const PatientBox({
    super.key,
    required this.patient,
    required this.viewMoreStatus,
    required this.isTile,
  });

  @override
  Widget build(BuildContext context) {
    final patientRecord = patient['record'];
    final patientGeneralData = patient['general'];
    final name = getFormattedName(patientGeneralData);
    final admissionDate =
        formatDate(patientRecord['preHospital']['injuryTimestamp']);
    final statusColor = getStatusColor(patientRecord['patientStatus']);

    return Container(
      margin:
          isTile ? const EdgeInsets.symmetric(vertical: 8.0) : EdgeInsets.zero,
      padding: isTile ? const EdgeInsets.all(16.0) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isTile ? Colors.white : Colors.transparent,
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
            calculateAgeString(patientGeneralData['birthday']),
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
              if (isTile)
                IconButton(
                  icon: Icon(
                    LucideIcons.arrowRightCircle,
                    color: Colors.black.withOpacity(0.8),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewMain(
                          onBack: () {
                            SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                                statusBarColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                systemNavigationBarColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          patient: patient,
                          unparsedPatient: patient['unparsedRecord'],
                        ),
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
