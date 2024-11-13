import 'package:dashboard/features/viewFeature/components/view_info_row.dart';
import 'package:flutter/material.dart';

import '../../core/models/_models.dart';
import '../../widgets/widgets.dart';

class ViewPreHospital extends StatelessWidget {
  final Map<String, dynamic> patientRecord;

  const ViewPreHospital({super.key, required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> record = parsePreHospitalRecord(patientRecord);
    Map<String, dynamic> vehicularAccident = record['vehicularAccident'];

    String dateOfInjury = "";
    String timeOfInjury = "";

    if (record['injuryTimestamp'] != null) {
      DateTime dateTimeOfInjury = DateTime.parse(record['injuryTimestamp']);
      dateOfInjury =
          '${dateTimeOfInjury.month.toString().padLeft(2, '0')}/${dateTimeOfInjury.day.toString().padLeft(2, '0')}/${dateTimeOfInjury.year}';
      timeOfInjury =
          '${dateTimeOfInjury.hour.toString().padLeft(2, '0')}:${dateTimeOfInjury.minute.toString().padLeft(2, '0')}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Injury Details",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        if (dateOfInjury.isNotEmpty)
          viewInfoRow("Date of Injury", dateOfInjury),
        viewInfoRow("Time of Injury", "$timeOfInjury hr"),
        if (record['injuryIntent'] != null)
          viewInfoRow("Injury Intent", record['injuryIntent']),
        if (record['externalCauses'].isNotEmpty)
          viewInfoRow("External Cause/s of Injury", record['externalCauses']),
        if (record['natureOfInjury'].isNotEmpty)
          viewInfoRow("Nature of Injury/ies", record['natureOfInjury']),
        if (record['natureOfInjuryExtraInfo'] != null)
          viewInfoRow("Additional Nature of Injury Info",
              record['natureOfInjuryExtraInfo']),
        if (record['medicolegal']?['medicolegalCategory'] != null)
          viewInfoRow("Medicolegal Category",
              record['medicolegal']['medicolegalCategory']),
        const SizedBox(height: 16),
        if (record['firstAid']?['isGiven'] == "yes")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "First Aid Given",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              if (record['firstAid']['methodGiven'] != null)
                viewInfoRow("Method Given", record['firstAid']['methodGiven']),
              if (record['firstAid']['firstAider'] != null)
                viewInfoRow("First Aider ID", record['firstAid']['firstAider']),
            ],
          ),
        if (record['placeOfInjury']?['cityMun'] != null ||
            record['placeOfInjury']?['region'] != null ||
            record['placeOfInjury']?['province'] != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Place of Injury",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.black.withOpacity(0.8),
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (record['placeOfInjury']['region'] != null)
                    viewInfoRow("Region", record['placeOfInjury']['region']),
                  if (record['placeOfInjury']['province'] != null)
                    viewInfoRow(
                        "Province", record['placeOfInjury']['province']),
                  if (record['placeOfInjury']['cityMun'] != null)
                    viewInfoRow("City/Municipality",
                        record['placeOfInjury']['cityMun']),
                ],
              ),
            ],
          ),
        if (vehicularAccident['preInjuryActivity'].isNotEmpty ||
            vehicularAccident['isVehicular'] == "yes")
          _buildVehicularAccidentDetails(context, vehicularAccident),
      ],
    );
  }

  Widget _buildVehicularAccidentDetails(
      BuildContext context, Map<String, dynamic> vehicularAccident) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          "Vehicular Accident Details",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.black.withOpacity(0.8),
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 4),
        if (vehicularAccident['preInjuryActivity'].isNotEmpty)
          viewInfoRow("Activity at the Time of the Incident",
              vehicularAccident['preInjuryActivity']),
        if (vehicularAccident['type'] != null)
          viewInfoRow("Type of Vehicle", vehicularAccident['type']),
        if (vehicularAccident['collision'] != null)
          viewInfoRow("Collision", vehicularAccident['collision']),
        if (vehicularAccident['vehiclesInvolved']?['patientVehicle'] != null)
          viewInfoRow("Patient's Vehicle",
              vehicularAccident['vehiclesInvolved']['patientVehicle']),
        if (vehicularAccident['vehiclesInvolved']?['otherVehicle'] != null)
          viewInfoRow("Other Vehicle",
              vehicularAccident['vehiclesInvolved']['otherVehicle']),
        if (vehicularAccident['position'] != null)
          viewInfoRow("Position", vehicularAccident['position']),
        if (vehicularAccident['placeOfOccurrence'] != null)
          viewInfoRow(
              "Place of Occurrence", vehicularAccident['placeOfOccurrence']),
        if (vehicularAccident['safetyIssues'].isNotEmpty)
          InfoCol(
            title: "Safety Issues",
            itemList: vehicularAccident['safetyIssues'],
          ),
      ],
    );
  }
}
