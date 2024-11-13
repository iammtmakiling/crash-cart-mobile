import 'package:dashboard/features/viewFeature/components/view_expand.dart';
import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '_view.dart';

class ViewSummary extends StatefulWidget {
  final Map<String, dynamic> patient;
  final Map<String, dynamic> patientData;

  const ViewSummary(
      {super.key, required this.patient, required this.patientData});

  @override
  ViewSummaryState createState() => ViewSummaryState();
}

class ViewSummaryState extends State<ViewSummary> {
  late Map<String, dynamic> patient;
  late Map<String, dynamic> patientData;
  bool ddGeneralData = false;
  bool ddPreAdmissionData = false;
  bool ddERData = false;
  bool ddHospitalData = false;
  bool ddSurgeryData = false;
  bool ddDischargeData = false;

  @override
  void initState() {
    super.initState();
    patient = widget.patient;
    patientData = widget.patientData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                // const SizedBox(height: 20),
                // PatientBox(
                //   viewMoreStatus: true,
                //   patient: patient,
                // ),
                // const SizedBox(height: 20),
                ExpandButton(
                  isExpanded: ddGeneralData,
                  text: "General Data",
                  onTap: () {
                    setState(() {
                      ddGeneralData = !ddGeneralData;
                    });
                  },
                  widget: ViewGeneral(
                    patientDetail: patientData,
                    patientRecord: patient,
                  ),
                ),
                ExpandButton(
                  isExpanded: ddPreAdmissionData,
                  text: "Preadmission Data",
                  onTap: () {
                    setState(() {
                      ddPreAdmissionData = !ddPreAdmissionData;
                    });
                  },
                  widget: ViewPreHospital(
                    patientRecord:
                        patient['preHospital'].cast<String, dynamic>(),
                  ),
                ),
                if (!patient['er'].isEmpty)
                  ExpandButton(
                    isExpanded: ddERData,
                    text: "ER Data",
                    onTap: () {
                      setState(() {
                        ddERData = !ddERData;
                      });
                    },
                    widget: ViewER(
                      patientRecord: patient['er'].cast<String, dynamic>(),
                    ),
                  ),
                if (!patient['inHospital'].isEmpty)
                  ExpandButton(
                    isExpanded: ddHospitalData,
                    text: "Hospital Data",
                    onTap: () {
                      setState(() {
                        ddHospitalData = !ddHospitalData;
                      });
                    },
                    widget: ViewInHospital(
                      patientRecord:
                          patient['inHospital'].cast<String, dynamic>(),
                    ),
                  ),
                if (!patient['surgery'].isEmpty)
                  ExpandButton(
                    isExpanded: ddSurgeryData,
                    text: "Surgery Data",
                    onTap: () {
                      setState(() {
                        ddSurgeryData = !ddSurgeryData;
                      });
                    },
                    widget: ViewSurgery(
                      patientRecord: patient['surgery'].cast<String, dynamic>(),
                    ),
                  ),
                if (!patient['discharge'].isEmpty)
                  ExpandButton(
                    isExpanded: ddDischargeData,
                    text: "Discharge Data",
                    onTap: () {
                      setState(() {
                        ddDischargeData = !ddDischargeData;
                      });
                    },
                    widget: ViewDischarge(
                      patientRecord:
                          patient['discharge'].cast<String, dynamic>(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
