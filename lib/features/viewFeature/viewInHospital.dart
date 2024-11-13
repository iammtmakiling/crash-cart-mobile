import 'package:dashboard/features/viewFeature/components/view_info_row.dart';
import 'package:flutter/material.dart';

import '../../core/models/_models.dart';
import '../../widgets/widgets.dart';

class ViewInHospital extends StatefulWidget {
  final Map<String, dynamic> patientRecord;

  const ViewInHospital({super.key, required this.patientRecord});

  @override
  _ViewInHospitalState createState() => _ViewInHospitalState();
}

class _ViewInHospitalState extends State<ViewInHospital> {
  late Map<String, dynamic> record;
  List<Widget> inreferralsList = [];

  Widget consultationWidget({required int index}) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            viewInfoRow(
                "Services", "${record['consultations'][index]['service']}"),
          const SizedBox(height: 8),
          if (record['consultations'][index]['physician'] != null)
            viewInfoRow(
                "Physician", "${record['consultations'][index]['physician']}"),
          const SizedBox(height: 8),
          if (record['consultations'][index]['consultationTimestamp'] != null)
            viewInfoRow("Date and Time",
                "${record['consultations'][index]['consultationTimestamp']}"),
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
    record = parseInHospitalRecord(widget.patientRecord);

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  viewInfoRow("Caprini Score", "${record['capriniScore']}"),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "VTE Prophylaxis",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (record['vteProphylaxis']['inclusion'] != null)
                        viewInfoRow("Inclusion",
                            "${record['vteProphylaxis']['inclusion']}"),
                      if (record['vteProphylaxis']['type'] != null)
                        viewInfoRow(
                            "Type", "${record['vteProphylaxis']['type']}"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Life Support Withdrawal",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (record['lifeSupportWithdrawal']['lswTimestamp'] !=
                          null)
                        viewInfoRow("Date and Time",
                            "${record['lifeSupportWithdrawal']['lswTimestamp']}"),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ICU Timeframe",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      if (record['icu']['arrival'] != null)
                        viewInfoRow("Arrival", "${record['icu']['arrival']}"),
                      if (record['icu']['exit'] != null)
                        viewInfoRow("Exit", "${record['icu']['exit']}"),
                      if (record['icu']['lengthOfStay'] != null)
                        viewInfoRow("Length of Stay",
                            "${record['icu']['lengthOfStay']}"),
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
                  viewInfoRow(
                      "Disposition", "${record['dispositionInHospital']}"),
                  if (record['consultations'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "List of Consultations",
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.black.withOpacity(0.8),
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        if (inreferralsList.isNotEmpty)
                          SizedBox(
                            height: 290.0,
                            width: widthScreen,
                            child: ListView.builder(
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
            ),
          ),
      ],
    );
  }
}
