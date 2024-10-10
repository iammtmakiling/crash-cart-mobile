import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class ViewPreHospital extends StatelessWidget {
  final Map<String, dynamic> patientRecord;

  const ViewPreHospital({super.key, required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> record = patientRecord;
    Map<String, dynamic> vehicularAccident = record['vehicularAccident'];

    String dateOfInjury = "";
    String timeOfInjury = "";

    if (record['injuryTimestamp'] != null) {
      DateTime dateTimeOfInjury = DateTime.parse(record['injuryTimestamp']);
      dateOfInjury =
          '${dateTimeOfInjury.month.toString().padLeft(2, '0')}/${dateTimeOfInjury.day.toString().padLeft(2, '0')}/${dateTimeOfInjury.year}';
      timeOfInjury =
          '${dateTimeOfInjury.hour.toString().padLeft(2, '0')}:${dateTimeOfInjury.minute.toString().padLeft(2, '0')}';
    } else {
      dateOfInjury = "";
      timeOfInjury = "";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 48.0,
          runSpacing: 20.0,
          children: [
            if (record['placeOfInjury']['cityMun'] != null ||
                record['placeOfInjury']['region'] != null ||
                record['placeOfInjury']['province'] != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Place of Injury:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    alignment: WrapAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      if (record['placeOfInjury']['region'] != null)
                        Info(
                          label: "Region",
                          value: "${record['placeOfInjury']['region']}",
                        ),
                      if (record['placeOfInjury']['province'] != null)
                        Info(
                          label: "Province",
                          value: "${record['placeOfInjury']['province']}",
                        ),
                      if (record['placeOfInjury']['cityMun'] != null)
                        Info(
                          label: "City/Municipality",
                          value: "${record['placeOfInjury']['cityMun']}",
                        ),
                    ],
                  ),
                ],
              ),
            if (dateOfInjury != "")
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Info(
                    label: "Date of Injury",
                    value: dateOfInjury, // mm/dd/yyyy
                  ),
                  const SizedBox(height: 20),
                  Info(
                    label: "Time of Injury",
                    value: "$timeOfInjury hr", //Military Time
                  ),
                ],
              ),
            if (record['injuryIntent'] != null)
              Info(
                label: "Injury Intent",
                value: "${record['injuryIntent']}",
              ),
            if (record['firstAid']['isGiven'].isNotEmpty &&
                record['firstAid']['isGiven'] == "yes")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "First Aid Given:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (record['firstAid']['methodGiven'] != null)
                        Info(
                          label: "Method Given",
                          value: "${record['firstAid']['methodGiven']}",
                        ),
                      if (record['firstAid']['firstAider'] != null)
                        Info(
                          label: "First Aider ID",
                          value: "${record['firstAid']['firstAider']}",
                        ),
                    ],
                  ),
                ],
              ),
            if (record['externalCauses'].isNotEmpty)
              InfoCol(
                itemList: record['externalCauses'],
                title: "External Cause/s of Injury",
              ),
            if (record['natureOfInjury'].isNotEmpty)
              InfoCol(
                itemList: record['natureOfInjury'],
                title: "Nature of Inury/ies",
              ),
            if (record['natureOfInjuryExtraInfo'] != null)
              Info(
                value: record['natureOfInjuryExtraInfo'],
                label: "Nature of Inury/ies",
              ),
            if (vehicularAccident['preInjuryActivity'].isNotEmpty)
              InfoCol(
                title: "Activity of the Patient at the time of the incident",
                itemList: vehicularAccident['preInjuryActivity'],
              ),
            if (vehicularAccident['otherRisksFactors'].isNotEmpty)
              InfoCol(
                title: "Other risk factors at the time of the incident",
                itemList: vehicularAccident['otherRisksFactors'],
              ),
            if (vehicularAccident['isVehicular'] == "yes")
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "FOR TRANSPORT/VEHICULAR ACCIDENT ONLY:",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (vehicularAccident['type'] != null)
                    Text(
                      vehicularAccident['type'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  if (vehicularAccident['collision'] != null)
                    Text(
                      vehicularAccident['collision'],
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  if (vehicularAccident['vehiclesInvolved']['patientVehicle'] !=
                      null)
                    Info(
                      label: "Patient's Vehicle",
                      value:
                          "${vehicularAccident['vehiclesInvolved']['patientVehicle']}",
                    ),
                  if (vehicularAccident['vehiclesInvolved']['otherVehicle'] !=
                      null)
                    Info(
                      label: "Other Vehicle",
                      value:
                          "${vehicularAccident['vehiclesInvolved']['otherVehicle']}",
                    ),
                  if (vehicularAccident['position'] != null)
                    Info(
                      label: "Position",
                      value: "${vehicularAccident['position']}",
                    ),
                  if (vehicularAccident['placeOfOccurrence'] != null)
                    Info(
                      label: "Place of Occurrence",
                      value: "${vehicularAccident['placeOfOccurrence']}",
                    ),
                  if (vehicularAccident['safetyIssues'].isNotEmpty)
                    InfoCol(
                        itemList: vehicularAccident['safetyIssues'],
                        title: "Safety Issues"),
                ],
              ),
            if (record['medicolegal']['medicolegalCategory'] != null)
              Info(
                label: "Medicolegal",
                value: "${record['medicolegal']['medicolegalCategory']}",
              ),
          ],
        ),
      ],
    );
  }
}
