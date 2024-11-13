import 'package:flutter/material.dart';
import 'package:dashboard/features/viewFeature/components/view_info_row.dart';
import '../../core/models/_models.dart';

class ViewER extends StatelessWidget {
  final Map<String, dynamic> patientRecord;

  const ViewER({super.key, required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    var record = parseERRecord(patientRecord);
    print(record);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Status upon Reaching Facility/Hospital",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4.0),
            if (record['statusOnArrival'] != null)
              viewInfoRow("Arrival Status", "${record['statusOnArrival']}"),
            if (record['aliveCategory'] != null)
              viewInfoRow("Alive Category", "${record['aliveCategory']}"),
          ],
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Patient is Transferred",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8.0),
            if (record['isReferred'] != null)
              viewInfoRow("Is referred?", "${record['isReferred']}"),
            if (record['previousHospitalID'] != null)
              viewInfoRow(
                  "Originating Hospital ID", "${record['previousHospitalID']}"),
            if (record['previousPhysicianID'] != null)
              viewInfoRow(
                  "Previous Physician ID", "${record['previousPhysicianID']}"),
            const SizedBox(height: 16.0),
          ],
        ),

        // Transportation Info
        if (record['transportation'] != null)
          viewInfoRow("Transportation", "${record['transportation']}"),
        const SizedBox(height: 16.0),

        // Patient Status Details
        Text(
          "Patient Status Details",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4.0),
        if (record['initialImpression'] != null)
          viewInfoRow("Initial Impression", "${record['initialImpression']}"),
        if (record['isSurgical'] != null)
          viewInfoRow("Outright Surgical", "${record['isSurgical']}"),
        if (record['cavityInvolved'] != null)
          viewInfoRow("Cavity Involved", "${record['cavityInvolved']}"),
        if (record['servicesOnboard']?.isNotEmpty ?? false)
          viewInfoRow(
            "Services on Board",
            record['servicesOnboard'],
          ),
        if (record['dispositionER'] != null)
          viewInfoRow("Patient Disposition", "${record['dispositionER']}"),
        if (record['outcome'] != null)
          viewInfoRow("Outcome", "${record['outcome']}"),
      ],
    );
  }
}
