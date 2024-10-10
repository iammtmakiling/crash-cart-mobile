import 'package:get/get.dart';

import '../features/viewFeature/viewMain.dart';
import 'package:flutter/material.dart';

class PatientBox extends StatefulWidget {
  final bool viewMoreStatus;
  final Map<String, dynamic> patient;

  const PatientBox({
    super.key,
    required this.patient,
    required this.viewMoreStatus,
  });

  @override
  _PatientBoxState createState() => _PatientBoxState();
}

class _PatientBoxState extends State<PatientBox> {
  late Map<String, dynamic> patientGeneralData = {};
  // Map<String, dynamic> patientData = {};
  late Map<String, dynamic> patientRecord;

  String admissionDate = "";
  late String name = "";
  late String fullName = "";
  late Color colorHexCode;
  // late String patientStatus;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    initializeData();
  }

  Future<void> initializeData() async {
    patientRecord = widget.patient['record'];
    patientGeneralData = widget.patient['general'];
    fullName = widget.patient['fullName'];

    if (patientGeneralData['middleName'] != null) {
      name =
          "${patientGeneralData['firstName'][0]}. ${patientGeneralData['middleName'][0]}. ${patientGeneralData['lastName']}";
    } else {
      name =
          "${patientGeneralData['firstName'][0]}. ${patientGeneralData['lastName']}";
    }
    colorHexCode = await getStatusColor(patientRecord['patientStatus']);

    admissionDate =
        extractDate(patientRecord['preHospital']['injuryTimestamp']);

    setState(() {
      isLoading = false;
    });
  }

  // Future<void> fetchRecordAndPatient() async {
  //   await Future.wait([
  //     fetchRecord(),
  //     fetchPatient(),
  //   ]);
  // }

  Future<Color> getStatusColor(String status) async {
    switch (status) {
      case 'Emergency Room':
        return Colors.yellow;
      case 'Pending Surgery':
        return const Color.fromARGB(255, 243, 180, 63); // Orange #FF7F00
      case 'In-Surgery':
        return const Color.fromARGB(255, 212, 35, 35); // Red
      case 'In-Hospital':
        return const Color.fromARGB(255, 46, 46, 170); // Blue
      case 'Pending Discharge':
        return Colors.lightGreen; // Yellow
      case 'Discharged':
        return const Color.fromARGB(255, 46, 187, 46); // Green
      default:
        return const Color.fromARGB(255, 53, 53, 53); // White (default color)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width *
                  (!widget.viewMoreStatus ? 0.9 : 1.0),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Row(
                          children: [
                            if (!widget.viewMoreStatus)
                              Container(
                                height: 100,
                                width: 20,
                                decoration: BoxDecoration(
                                  color: colorHexCode,
                                ),
                              ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(
                                    widget.viewMoreStatus ? 0 : 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          !widget.viewMoreStatus
                                              ? name
                                              : fullName,
                                          style: TextStyle(
                                            fontSize: !widget.viewMoreStatus
                                                ? 16
                                                : 20,
                                            color: (!widget.viewMoreStatus
                                                ? Colors.black54
                                                : Colors.cyan),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          admissionDate,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      patientRecord['patientID'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          patientRecord['patientStatus'],
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (!widget.viewMoreStatus)
                                          TextButton(
                                            onPressed: () {
                                              Get.to(
                                                ViewMain(
                                                  onBack: () {},
                                                  patient: widget.patient,
                                                  unparsedPatient:
                                                      widget.patient[
                                                          'unparsedRecord'],
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              "View",
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  String extractDate(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      String formattedDate =
          "${dateTime.year}-${dateTime.month}-${dateTime.day}";
      return formattedDate;
    } catch (e) {
      print('Error parsing date: $e');
      // Return a default or empty value when the date is invalid
      return '';
    }
  }
}
