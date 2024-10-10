import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';

class ViewInHospital extends StatefulWidget {
  final Map<String, dynamic> patientRecord;

  const ViewInHospital({super.key, required this.patientRecord});

  @override
  // ignore: library_private_types_in_public_api
  _ViewInHospitalState createState() => _ViewInHospitalState();
}

class _ViewInHospitalState extends State<ViewInHospital> {
  late Map<String, dynamic> record;
  List<Widget> inreferralsList = [];

  Widget consultationWidget({required int index}) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Consultation ${index + 1}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (record['consultations'][index]['service'] != null)
            Info(
                label: "Services",
                value: record['consultations'][index]['service']),
          const SizedBox(height: 8),
          if (record['consultations'][index]['physician'] != null)
            Info(
                label: "Physician",
                value: record['consultations'][index]['physician']),
          const SizedBox(height: 8),
          if (record['consultations'][index]['consultationTimestamp'] != null)
            Info(
                label: "Date and Time",
                value: record['consultations'][index]['consultationTimestamp']),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void renderInHospitalWidgets() {
    if (record['consultations'] != []) {
      int lengthList = record['consultations'].length;
      for (var index = 0; index < lengthList; index++) {
        setState(() {
          inreferralsList.add(consultationWidget(index: index));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    record = widget.patientRecord;

    if (record.isNotEmpty) {
      renderInHospitalWidgets();
    }
  }

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width * 0.9;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (record != {})
          Column(
            children: [
              Wrap(
                spacing: 48.0,
                runSpacing: 20.0,
                children: [
                  Info(label: "Caprini Score", value: record['capriniScore']),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "VTE Prophylaxis",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (record['vteProphylaxis']['inclusion'] != null)
                            Info(
                              label: "Inclusion",
                              value: record['vteProphylaxis']['inclusion'],
                            ),
                          if (record['vteProphylaxis']['type'] != null)
                            Info(
                              label: "Type",
                              value: record['vteProphylaxis']['type'],
                            ),
                          // if (record['vteProphylaxis']['date'] != null)
                          //   Info(
                          //     label: "Date",
                          //     value: record['vteProphylaxis']['date'],
                          //   ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Life Support Withdrawal:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (record['lifeSupportWithdrawal']['lswTimestamp'] !=
                          null)
                        Info(
                          label: "Date and Time",
                          value: record['lifeSupportWithdrawal']
                              ['lswTimestamp'],
                        ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "ICU Timeframe:",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (record['icu']['arrival'] != null)
                        Info(
                          label: "Arrival",
                          value: record['icu']['arrival'],
                        ),
                      if (record['icu']['exit'] != null)
                        Info(
                          label: "Exit",
                          value: record['icu']['exit'],
                        ),
                      if (record['icu']['lengthOfStay'] != null)
                        Info(
                          label: "Length of Stay",
                          value: record['icu']['lengthOfStay'].toString(),
                        ),
                    ],
                  ),
                  if (record['comorbidities'].isNotEmpty)
                    InfoCol(
                        itemList: record['comorbidities'],
                        title: 'Comorbidities'),
                  if (record['complications'].isNotEmpty)
                    InfoCol(
                        itemList: record['complications'],
                        title: 'Complications'),
                  Info(
                      label: "Disposition",
                      value: record['dispositionInHospital']),
                  if (record['consultations'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "List of Consultations:",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (inreferralsList.isNotEmpty)
                          SizedBox(
                            // you may want to use an aspect ratio here for tablet support
                            height: 290.0,
                            width: widthScreen,
                            child: ListView.builder(
                              // store this controller in a State to save the carousel scroll position
                              // controller: PageController(viewportFraction: 0.9),
                              itemCount: inreferralsList.length,
                              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                              itemBuilder: (context, index) {
                                return inreferralsList[index];
                              },
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        if (record.isEmpty)
          const Center(
              child: Text(
            "No In Hospital Record",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ))
      ],
    );
  }
}
