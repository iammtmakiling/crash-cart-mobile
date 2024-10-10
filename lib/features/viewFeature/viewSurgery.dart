import 'package:flutter/material.dart';
import '../../widgets/widgets.dart';

class ViewSurgery extends StatefulWidget {
  final Map<String, dynamic> patientRecord;

  const ViewSurgery({super.key, required this.patientRecord});

  @override
  ViewSurgeryState createState() => ViewSurgeryState();
}

class ViewSurgeryState extends State<ViewSurgery> {
  late Map<String, dynamic> record;
  List<Widget> surgeryList = [];

  Widget surgeryTemplate(int index, String rvscode) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Surgery #${index + 1}",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            spacing: 48.0,
            runSpacing: 20.0,
            children: [
              if (record['surgeriesList'][index]['placeOfSurgery'] != null)
                Info(
                  label: "Place of Surgery",
                  value: "${record['surgeriesList'][index]['placeOfSurgery']}",
                ),
              if (record['surgeriesList'][index]['rvsCode'] != null)
                Info(
                  label: "RVS Code",
                  value: "${record['surgeriesList'][index]['rvsCode']}",
                ),
              if (record['surgeriesList'][index]['cavityInvolved'] != null)
                Info(
                  label: "Cavity Involved",
                  value: "${record['surgeriesList'][index]['cavityInvolved']}",
                ),
              if (record['surgeriesList'][index]['servicesPresent'].isNotEmpty)
                InfoCol(
                  itemList: record['surgeriesList'][index]['servicesPresent'],
                  title: "Services Present",
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Surgery Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Wrap(
            spacing: 48.0,
            runSpacing: 20.0,
            children: [
              if (record['surgeriesList'][index]['phaseBegun'] != null)
                Info(
                  label: "Phase begun",
                  value: "${record['surgeriesList'][index]['phaseBegun']}",
                ),
              if (record['surgeriesList'][index]['surgeryType'] != null)
                Info(
                  label: "Surgery Type",
                  value: "${record['surgeriesList'][index]['surgeryType']}",
                ),
              if (record['surgeriesList'][index]['surgeon'] != null)
                Info(
                  label: "Surgeon ID",
                  value: "${record['surgeriesList'][index]['surgeon']}",
                ),
              // if (record['surgeriesList'][index]['startTimestamp'] != null)
              //   Info(
              //     label: "Start Time",
              //     value: "${record['surgeriesList'][index]['startTimestamp']}",
              //   ),
              // if (record['surgeriesList'][index]['endTimestamp'] != null)
              //   Info(
              //     label: "End Time",
              //     value: "${record['surgeriesList'][index]['endTimestamp']}",
              //   ),
            ],
          ),
          const SizedBox(height: 16),
          if (record['surgeriesList'][index]['hemorrhageControl']
                  ['hemorrhageType'] !=
              null)
            Info(
              label: "Hemorrhage Control Type",
              value:
                  "${record['surgeriesList'][index]['hemorrhageControl']['hemorrhageType']}",
            ),
          if (record['surgeriesList'][index]['hemorrhageControl']
                  ['hemorrhageTimestamp'] !=
              null)
            Info(
              label: "Hemorrhage Controlled Date & Time",
              value:
                  "${record['surgeriesList'][index]['hemorrhageControl']['hemorrhageTimestamp']}",
            ),
          if (record['surgeriesList'][index]['dispositionSurgery'] != null)
            Info(
              label: "Disposition after surgery",
              value: "${record['surgeriesList'][index]['dispositionSurgery']}",
            ),
        ],
      ),
    );
  }

  void renderSurgeryWidgets() {
    if (record['surgeriesList'] != []) {
      int lengthList = record['surgeriesList'].length;
      for (var index = 0; index < lengthList; index++) {
        String rvscode = record['surgeriesList'][index]['rvsCode'];
        setState(() {
          surgeryList.add(surgeryTemplate(index, rvscode));
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    record = widget.patientRecord;
    renderSurgeryWidgets();
  }

  @override
  Widget build(BuildContext context) {
    // var widthScreen = MediaQuery.of(context).size.width * 0.9;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Wrap(
        //   spacing: 48.0,
        //   runSpacing: 20.0,
        //   children: [
        if (surgeryList.isNotEmpty)
          SizedBox(
            // you may want to use an aspect ratio here for tablet support
            height: 290.0,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              // store this controller in a State to save the carousel scroll position
              // controller: PageController(viewportFraction: 0.9),
              itemCount: surgeryList.length,
              // padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              itemBuilder: (context, index) {
                return surgeryList[index];
              },
            ),
          ),
        // Flexible(
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     // physics: const NeverScrollableScrollPhysics(),
        //     itemCount: surgeryList.length,
        //     itemBuilder: (context, index) {
        //       return surgeryList[index];
        //     },
        //   ),
        // ),
      ],
      //   )
      // ],
    );
  }
}
