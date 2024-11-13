import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/features/viewFeature/components/view_expand.dart';
import 'package:dashboard/features/viewFeature/components/view_row.dart';
import 'package:dashboard/screens/RecordsScreen/widgets/patient_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '_view.dart';

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
  final Map<String, bool> expandedSections = {
    "General Data": false,
    "Preadmission Data": false,
    "ER Data": false,
    "Hospital Data": false,
    "Surgery Data": false,
    "Discharge Data": false,
  };

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title:
            Text("View Patient", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            widget.onBack();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                children: [
                  PatientBox(
                    viewMoreStatus: true,
                    patient: widget.patient,
                    isTile: false,
                  ),
                  // const SizedBox(height: 20),
                  viewRowWidget(
                    userProvider.user!.role,
                    widget.patient['general'],
                    widget.patient['record'],
                    widget.unparsedPatient,
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Colors.black.withOpacity(0.1),
                  ),
                  ..._buildExpandButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildExpandButtons() {
    return [
      _createExpandButton(
          "General Data", widget.patient['general'], widget.patient['record']),
      _createExpandButton(
          "Preadmission Data", widget.patient['record']['preHospital']),
      if (!widget.patient['record']['er'].isEmpty)
        _createExpandButton("ER Data", widget.patient['record']['er']),
      if (!widget.patient['record']['inHospital'].isEmpty)
        _createExpandButton(
            "Hospital Data", widget.patient['record']['inHospital']),
      if (!widget.patient['record']['surgery'].isEmpty)
        _createExpandButton(
            "Surgery Data", widget.patient['record']['surgery']),
      if (!widget.patient['record']['discharge'].isEmpty)
        _createExpandButton(
            "Discharge Data", widget.patient['record']['discharge']),
    ];
  }

  Widget _createExpandButton(String title, dynamic patientRecord,
      [Map<String, dynamic>? additionalRecord]) {
    return ExpandButton(
      isExpanded: expandedSections[title]!,
      text: title,
      onTap: () {
        setState(() {
          expandedSections[title] = !expandedSections[title]!;
        });
      },
      widget: _getViewWidget(title, patientRecord, additionalRecord),
    );
  }

  Widget _getViewWidget(String title, dynamic patientRecord,
      [Map<String, dynamic>? additionalRecord]) {
    switch (title) {
      case "General Data":
        return ViewGeneral(
          patientDetail: patientRecord,
          patientRecord: additionalRecord!,
        );
      case "Preadmission Data":
        return ViewPreHospital(
            patientRecord: patientRecord.cast<String, dynamic>());
      case "ER Data":
        return ViewER(patientRecord: patientRecord.cast<String, dynamic>());
      case "Hospital Data":
        return ViewInHospital(
            patientRecord: patientRecord.cast<String, dynamic>());
      case "Surgery Data":
        return ViewSurgery(
            patientRecord: patientRecord.cast<String, dynamic>());
      case "Discharge Data":
        return ViewDischarge(
            patientRecord: patientRecord.cast<String, dynamic>());
      default:
        return SizedBox.shrink();
    }
  }
}
