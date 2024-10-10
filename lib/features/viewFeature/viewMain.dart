// import 'package:dashboard/features/editFeature/editER.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/widgets/accept_button.dart';
import 'package:dashboard/widgets/add_button.dart';
import 'package:dashboard/widgets/edit_button.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
import '../../widgets/widgets.dart';
import 'view.dart';

// ignore: must_be_immutable
class ViewMain extends StatefulWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> patient;
  final Map<String, dynamic> unparsedPatient;

  const ViewMain({
    super.key,
    required this.patient,
    required this.onBack,
    required this.unparsedPatient,
  });

  @override
  ViewMainState createState() => ViewMainState();
}

class ViewMainState extends State<ViewMain> {
  bool ddGeneralData = false;
  bool ddPreAdmissionData = false;
  bool ddERData = false;
  bool ddHospitalData = false;
  bool ddSurgeryData = false;
  bool ddDischargeData = false;

  @override
  void initState() {
    super.initState();
  }

  Widget getRowWidget(String role, Map<String, dynamic> patient,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // const MiniAppBar(),
          MiniAppBarBack(
            onBack: () {
              Navigator.pop(this.context);
            },
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              children: [
                const SizedBox(height: 20),
                PatientBox(
                  viewMoreStatus: true,
                  patient: widget.patient,
                ),
                const SizedBox(height: 20),
                getRowWidget(role, widget.patient['general'],
                    widget.patient['record'], widget.unparsedPatient),
                const SizedBox(height: 20),
                ExpandButton(
                  isExpanded: ddGeneralData,
                  text: "General Data",
                  onTap: () {
                    setState(() {
                      ddGeneralData = !ddGeneralData;
                    });
                  },
                  widget: ViewGeneral(
                    patientDetail: widget.patient['general'],
                    patientRecord: widget.patient['record'],
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
                      patientRecord: widget.patient['record']['preHospital']
                          .cast<String, dynamic>()),
                ),
                if (!widget.patient['record']['er'].isEmpty)
                  ExpandButton(
                    isExpanded: ddERData,
                    text: "ER Data",
                    onTap: () {
                      setState(() {
                        ddERData = !ddERData;
                      });
                    },
                    widget: ViewER(
                        patientRecord: widget.patient['record']['er']
                            .cast<String, dynamic>()),
                  ),
                if (!widget.patient['record']['inHospital'].isEmpty)
                  ExpandButton(
                    isExpanded: ddHospitalData,
                    text: "Hospital Data",
                    onTap: () {
                      setState(() {
                        ddHospitalData = !ddHospitalData;
                      });
                    },
                    widget: ViewInHospital(
                        patientRecord: widget.patient['record']['inHospital']
                            .cast<String, dynamic>()),
                  ),
                if (!widget.patient['record']['surgery'].isEmpty)
                  ExpandButton(
                    isExpanded: ddSurgeryData,
                    text: "Surgery Data",
                    onTap: () {
                      setState(() {
                        ddSurgeryData = !ddSurgeryData;
                      });
                    },
                    widget: ViewSurgery(
                        patientRecord: widget.patient['record']['surgery']
                            .cast<String, dynamic>()),
                  ),
                if (!widget.patient['record']['discharge'].isEmpty)
                  ExpandButton(
                    isExpanded: ddDischargeData,
                    text: "Discharge Data",
                    onTap: () {
                      setState(() {
                        ddDischargeData = !ddDischargeData;
                      });
                    },
                    widget: ViewDischarge(
                        patientRecord: widget.patient['record']['discharge']
                            .cast<String, dynamic>()),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
