import 'package:dashboard/widgets/accept_button.dart';
import 'package:dashboard/widgets/add_button.dart';
import 'package:flutter/material.dart';

import '../../../widgets/edit_button.dart';

Widget viewRowWidget(String role, Map<String, dynamic> patient,
    Map<String, dynamic> record, Map<String, dynamic> unparsedRecord) {
  switch (role) {
    case "Pre-Hospital Staff":
      return Row(
        children: [
          EditButton(
            text: "Edit PreHospital Data",
            role: role,
            patient: patient,
            record: record,
            unparsedRecord: unparsedRecord,
          ),
        ],
      );
    case "ER Staff":
      return Row(
        children: [
          if (record['er'].isEmpty &&
              record['patientStatus'] == "Emergency Room") ...[
            const SizedBox(width: 10),
            AddButton(
              text: "Add ER Data",
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
          if (record['er'].isNotEmpty) ...[
            EditButton(
              text: "Edit Emergency Room Data",
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
        ],
      );
    case "In-Hospital Staff":
      return Row(
        children: [
          if (record['inHospital'].isEmpty &&
              record['patientStatus'] == "In-Hospital") ...[
            const SizedBox(width: 10),
            AddButton(
              text: "Add consultation",
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
          if (record['inHospital'].isNotEmpty) ...[
            EditButton(
              text: "Add/Edit Consultation",
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
        ],
      );
    case 'Surgery Staff':
      return Row(
        children: [
          if (record['patientStatus'] == "Pending Surgery" ||
              record['patientStatus'] == "In-Surgery") ...[
            AcceptButton(
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
          if (record['patientStatus'] != "Pending Surgery" &&
              record['patientStatus'] != "In-Surgery" &&
              record['surgery'].isNotEmpty) ...[
            EditButton(
              text: "Edit Surgery Data",
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
        ],
      );
    case 'Discharge Staff':
      return Row(
        children: [
          if (record['discharge'].isEmpty &&
              record['patientStatus'] == "Pending Discharge") ...[
            const SizedBox(width: 10),
            AddButton(
              text: "Discharge Patient",
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
          if (record['discharge'].isNotEmpty) ...[
            EditButton(
              text: "Edit Discharge Data",
              role: role,
              patient: patient,
              record: record,
              unparsedRecord: unparsedRecord,
            ),
          ],
        ],
      );
    default:
      return const Row(
        children: [
          Text(''),
        ],
      );
  }
}
