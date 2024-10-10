import 'package:dashboard/widgets/info.dart';
import 'package:flutter/material.dart';
// import '../mockData/records.dart';

class ViewDischarge extends StatelessWidget {
  final Map<String, dynamic> patientRecord;

  const ViewDischarge({super.key, required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    var record = patientRecord;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          spacing: 48.0,
          runSpacing: 20.0,
          children: [
            Info(
              label: "Treatment Complete",
              value: "${record['isTreatmentComplete']}",
            ),
            Info(
              label: "Final Dianosis",
              value: "${record['finalDiagnosis']}",
            ),
            Info(
              label: "Disposition Discharge",
              value: "${record['dispositionDischarge']}",
            ),
          ],
        )
      ],
    );
  }
}
