import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class ViewER extends StatelessWidget {
  final Map<String, dynamic> patientRecord;
  const ViewER({super.key, required this.patientRecord});

  @override
  Widget build(BuildContext context) {
    var record = patientRecord;
    // print("ER: $record");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 48.0,
          runSpacing: 20.0,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (record['isTransferred'] == "yes")
                  Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    alignment: WrapAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Patient is Transferred",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (record['isReferred'] != null)
                            Info(
                                label: "Is reffered?",
                                value: record['isReferred']),
                          if (record['previousHospitalID'] != null)
                            Info(
                              label: "Originating Hospital ID",
                              value: record['previousHospitalID'],
                            ),
                          if (record['previousPhysicianID'] != null)
                            Info(
                              label: "Previous Physician ID",
                              value: record['previousPhysicianID'],
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Status upon reaching Facility/Hospital",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${record['statusOnArrival']}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "${record['aliveCategory']}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                Wrap(spacing: 48.0, runSpacing: 20.0, children: [
                  if (record['transportation'] != null)
                    Info(
                      label: "Transportation",
                      value: "${record['transportation']}",
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient Status Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (record['initialImpression'] != null)
                        Info(
                          label: "Initial Impression",
                          value: "${record['initialImpression']}",
                        ),
                      // if (record['natureofInjuryICD'] != null)
                      //   Info(
                      //     label: "IDC-10 Code/s: Nature of Injury",
                      //     value: "${record['natureofInjuryICD']}",
                      //   ),
                      // if (record['externalCauseICD'] != null)
                      //   Info(
                      //     label: "IDC-10 Code/s: External cause of Injury",
                      //     value: "${record['externalCauseICD']}",
                      //   ),
                      if (record['isSurgical'] != null)
                        Info(
                          label: "Outright Surgical",
                          value: "${record['isSurgical']}",
                        ),
                      if (record['cavityInvolved'] != null)
                        Info(
                          label: "Cavity Involved",
                          value: "${record['cavityInvolved']}",
                        ),
                      if (record['servicesOnboard'].isNotEmpty)
                        InfoCol(
                          itemList: record['servicesOnboard'],
                          title: "Services on Board",
                        ),
                      if (record['dispositionER'] != null)
                        Info(
                          label: "Patient Disposition",
                          value: "${record['dispositionER']}",
                        ),
                      if (record['outcome'] != null)
                        Info(
                          label: "Outcome",
                          value: "${record['outcome']}",
                        ),
                    ],
                  ),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [

                  //   ],
                  // ),
                ]),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
