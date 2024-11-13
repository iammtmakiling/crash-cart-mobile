import 'package:dashboard/features/viewFeature/components/view_info_row.dart';
import 'package:flutter/material.dart';

class ViewGeneral extends StatelessWidget {
  final Map<String, dynamic> patientRecord;
  final Map<String, dynamic> patientDetail;

  const ViewGeneral(
      {super.key, required this.patientRecord, required this.patientDetail});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> general = patientDetail;
    final Map<String, dynamic> record = patientRecord;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        viewInfoRow("Record ID", "${record['recordID']}"),
        viewInfoRow("Hospital Patient ID No.", "${record['hospitalID']}"),
        viewInfoRow("Type of Patient", "${record['patientType']}"),
        // Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     const Text(
        //       "Name of Patient",
        //       style: TextStyle(
        //         color: Colors.black,
        //         fontSize: 14,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     viewInfoRow("Last Name", "${general['lastName']}"),
        //     viewInfoRow("First Name", "${general['firstName']}"),
        //     if (general['middleName'] != null)
        //       viewInfoRow("Middle Name", "${general['middleName']}"),
        //     if (general['suffix'] != null)
        //       viewInfoRow("Suffix", "${general['suffix']}"),
        //   ],
        // ),
        if (general['sex'] != null) viewInfoRow("Sex", "${general['sex']}"),
        if (general['birthday'] != null)
          viewInfoRow("Birthdate", "${general['birthday']}"),
        if (general['philHealthID'] != null)
          viewInfoRow("Philhealth #", "${general['philHealthID']}"),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Permanent Address",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            if (general['permanentAddress']?['region'] != null)
              viewInfoRow("Region", "${general['permanentAddress']['region']}"),
            if (general['permanentAddress']?['province'] != null)
              viewInfoRow(
                  "Province", "${general['permanentAddress']['province']}"),
            if (general['permanentAddress']?['cityMun'] != null)
              viewInfoRow("City/Municipality",
                  "${general['permanentAddress']['cityMun']}"),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Present Address",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            if (general['presentAddress']?['region'] != null)
              viewInfoRow("Region", "${general['presentAddress']['region']}"),
            if (general['presentAddress']?['province'] != null)
              viewInfoRow(
                  "Province", "${general['presentAddress']['province']}"),
            if (general['presentAddress']?['cityMun'] != null)
              viewInfoRow("City/Municipality",
                  "${general['presentAddress']['cityMun']}"),
          ],
        ),
      ],
    );
  }
}
