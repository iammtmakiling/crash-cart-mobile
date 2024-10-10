import 'package:flutter/material.dart';

import '../../widgets/info.dart';
// import '../mockData/records.dart';
// import '../mockData/users.dart';

class ViewGeneral extends StatelessWidget {
  final Map<String, dynamic> patientRecord;
  final Map<String, dynamic> patientDetail;

  const ViewGeneral(
      {super.key, required this.patientRecord, required this.patientDetail});

//PatientStatus
  @override
  Widget build(BuildContext context) {
    // var record = patientRecord;
    // var patient = generalData;
    final Map<String, dynamic> general = patientDetail;
    final Map<String, dynamic> record = patientRecord;

    // print("Patient Record: $patientRecord");
    // print("General Data: $generalData");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          spacing: 48.0,
          runSpacing: 20.0,
          children: [
            Info(
              label: "Record ID",
              value: "${record['recordID']}",
            ),
            Info(
              label: "Hospital Patient ID No.",
              value: "${record['hospitalID']}",
            ),
            Info(
              label: "Type of Patient",
              value: "${record['patientType']}",
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Name of Patient",
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
                    Info(
                      label: "Last Name",
                      value: "${general['lastName']}",
                    ),
                    Info(
                      label: "First Name",
                      value: "${general['firstName']}",
                    ),
                    if (general['middleName'] != null)
                      Info(
                        label: "Middle Name",
                        value: "${general['middleName']}",
                      ),
                    if (general['suffix'] != null)
                      Info(
                        label: "Suffix",
                        value: "${general['suffix']}",
                      ),
                  ],
                ),
              ],
            ),
            Wrap(
              spacing: 48.0,
              runSpacing: 20.0,
              children: [
                if (general['sex'] != null)
                  Info(
                    label: "Sex",
                    value: "${general['sex']}",
                  ),
                if (general['birthday'] != null)
                  Info(
                    label: "Birthdate",
                    value: "${general['birthday']}", // mm/dd/yyyy
                  ),
                if (general['philHealthID'] != null)
                  Info(
                    label: "Philhealth #",
                    value: "${general['philHealthID']}",
                  ),
              ],
            ),
            Wrap(
              spacing: 48.0,
              runSpacing: 20.0,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Permanent Address",
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
                        if (general['permanentAddress']?['region'] != null)
                          Info(
                            label: "Region",
                            value: "${general['permanentAddress']['region']}",
                          ),
                        if (general['permanentAddress']?['province'] != null)
                          Info(
                            label: "Province",
                            value: "${general['permanentAddress']['province']}",
                          ),
                        if (general['permanentAddress']?['cityMun'] != null)
                          Info(
                            label: "City/Municipality",
                            value: "${general['permanentAddress']['cityMun']}",
                          ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Present Address",
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
                        if (general['presentAddress']?['region'] != null)
                          Info(
                            label: "Region",
                            value: "${general['presentAddress']['region']}",
                          ),
                        if (general['presentAddress']?['province'] != null)
                          Info(
                            label: "Province",
                            value: "${general['presentAddress']['province']}",
                          ),
                        if (general['presentAddress']?['cityMun'] != null)
                          Info(
                            label: "City/Municipality",
                            value: "${general['presentAddress']['cityMun']}",
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
