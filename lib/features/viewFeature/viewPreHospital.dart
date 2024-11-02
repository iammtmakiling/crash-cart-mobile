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
            // Place of Injury
            if (record['placeOfInjury']?['cityMun'] != null ||
                record['placeOfInjury']?['region'] != null ||
                record['placeOfInjury']?['province'] != null)
              _buildPlaceOfInjury(record['placeOfInjury']),

            // Date and Time of Injury
            if (dateOfInjury.isNotEmpty)
              _buildDateTimeOfInjury(dateOfInjury, timeOfInjury),

            // Injury Intent
            if (record['injuryIntent'] != null)
              Info(
                label: "Injury Intent",
                value: record['injuryIntent'],
              ),

            // First Aid Given
            if (record['firstAid']?['isGiven'] == "yes")
              _buildFirstAid(record['firstAid']),

            // External Causes of Injury
            if (record['externalCauses'].isNotEmpty)
              InfoCol(
                title: "External Cause/s of Injury",
                itemList: record['externalCauses'],
              ),

            // Nature of Injury
            if (record['natureOfInjury'].isNotEmpty)
              InfoCol(
                title: "Nature of Injury/ies",
                itemList: record['natureOfInjury'],
              ),

            // Additional Nature of Injury Info
            if (record['natureOfInjuryExtraInfo'] != null)
              Info(
                label: "Additional Nature of Injury Info",
                value: record['natureOfInjuryExtraInfo'],
              ),

            // Vehicular Accident Details
            if (vehicularAccident['preInjuryActivity'].isNotEmpty ||
                vehicularAccident['isVehicular'] == "yes")
              _buildVehicularAccidentDetails(vehicularAccident),

            // Medicolegal
            if (record['medicolegal']?['medicolegalCategory'] != null)
              Info(
                label: "Medicolegal Category",
                value: record['medicolegal']['medicolegalCategory'],
              ),
          ],
        ),
      ],
    );
  }
}

// Helper method for Place of Injury
Widget _buildPlaceOfInjury(Map<String, dynamic> placeOfInjury) {
  return Column(
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
        children: [
          if (placeOfInjury['region'] != null)
            Info(label: "Region", value: placeOfInjury['region']),
          if (placeOfInjury['province'] != null)
            Info(label: "Province", value: placeOfInjury['province']),
          if (placeOfInjury['cityMun'] != null)
            Info(label: "City/Municipality", value: placeOfInjury['cityMun']),
        ],
      ),
    ],
  );
}

// Helper method for Date and Time of Injury
Widget _buildDateTimeOfInjury(String dateOfInjury, String timeOfInjury) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Info(
        label: "Date of Injury",
        value: dateOfInjury,
      ),
      const SizedBox(height: 20),
      Info(
        label: "Time of Injury",
        value: "$timeOfInjury hr", // Military Time
      ),
    ],
  );
}

// Helper method for First Aid details
Widget _buildFirstAid(Map<String, dynamic> firstAid) {
  return Column(
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
      if (firstAid['methodGiven'] != null)
        Info(
          label: "Method Given",
          value: firstAid['methodGiven'],
        ),
      if (firstAid['firstAider'] != null)
        Info(
          label: "First Aider ID",
          value: firstAid['firstAider'],
        ),
    ],
  );
}

// Helper method for Vehicular Accident details
Widget _buildVehicularAccidentDetails(Map<String, dynamic> vehicularAccident) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (vehicularAccident['preInjuryActivity'].isNotEmpty)
        InfoCol(
          title: "Activity at the Time of the Incident",
          itemList: vehicularAccident['preInjuryActivity'],
        ),
      if (vehicularAccident['isVehicular'] == "yes") ...[
        const Text(
          "For Transport/Vehicular Accident Only:",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (vehicularAccident['type'] != null)
          Info(
            label: "Type of Vehicle",
            value: vehicularAccident['type'],
          ),
        if (vehicularAccident['collision'] != null)
          Info(
            label: "Collision",
            value: vehicularAccident['collision'],
          ),
        if (vehicularAccident['vehiclesInvolved']?['patientVehicle'] != null)
          Info(
            label: "Patient's Vehicle",
            value: vehicularAccident['vehiclesInvolved']['patientVehicle'],
          ),
        if (vehicularAccident['vehiclesInvolved']?['otherVehicle'] != null)
          Info(
            label: "Other Vehicle",
            value: vehicularAccident['vehiclesInvolved']['otherVehicle'],
          ),
        if (vehicularAccident['position'] != null)
          Info(
            label: "Position",
            value: vehicularAccident['position'],
          ),
        if (vehicularAccident['placeOfOccurrence'] != null)
          Info(
            label: "Place of Occurrence",
            value: vehicularAccident['placeOfOccurrence'],
          ),
        if (vehicularAccident['safetyIssues'].isNotEmpty)
          InfoCol(
            title: "Safety Issues",
            itemList: vehicularAccident['safetyIssues'],
          ),
      ],
    ],
  );
}
