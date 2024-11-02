import 'package:dashboard/core/api_requests/updateRecord.dart';
import 'package:dashboard/features/viewFeature/viewSummary.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/initializedList.dart';
import 'package:dashboard/screens/home_page.dart';
import 'package:dashboard/screens/pincode.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../core/models/_models.dart';
import '../../globals.dart' as globals;

// dependent dropdowns
// import 'package:snippet_coder_utils/FormHelper.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';
import '../../widgets/formWidgets/formWidgets.dart';

var uuid = const Uuid();
DateTime current = DateTime.now();

// ignore: camel_case_types
class editSurgery extends StatelessWidget {
  final Map<String, dynamic> patientData;

  final Map<String, dynamic> fullRecord;
  final Map<String, dynamic> surgeryData;
  final Map<String, dynamic> record;
  final VoidCallback onBack;
  const editSurgery(
      {super.key,
      required this.onBack,
      required this.surgeryData,
      required this.patientData,
      required this.fullRecord,
      required this.record});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('az');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
      ],
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      // title: 'Add Patient',
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: Colors.black,
            fontSizeFactor: 1.0,
            decoration: TextDecoration.none,
          )),
      home: EditSurgery(
          surgeryData: surgeryData,
          record: record,
          onBack: onBack,
          patientData: patientData,
          fullRecord: fullRecord),
    );
  }
}

class EditSurgery extends StatefulWidget {
  final Map<String, dynamic> surgeryData;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final Map<String, dynamic> record;
  final VoidCallback onBack;

  const EditSurgery(
      {super.key,
      required this.surgeryData,
      required this.record,
      required this.patientData,
      required this.fullRecord,
      required this.onBack});

  @override
  EditSurgeryState createState() => EditSurgeryState();
}

class EditSurgeryState extends State<EditSurgery>
    with SingleTickerProviderStateMixin {
// Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // General Data
  var patientStatus = "";
  late Map<String, dynamic> record;
  late Map<String, dynamic> surgeryData;
  late List<Map<String, dynamic>> surgeries;
  bool isInSurgery = false;

  // Screens
  bool isLoading = false;
  bool isSending = false;
  bool isSentSuccessfully = false;

  // Surgery Data
  List<dynamic> RVSCodes = [];
  List<String> RVSList = [];
  List<Widget> surgeryCardList = [];
  late int initialSurgeriesNumber; // Needed for patientStream

  // Disposition List
  List<String> disposition = [
    'In-Hospital',
    'Pending Discharge',
    'Discharged',
    'Deceased'
  ];

  late TabController _tabController;

  Widget surgeryTemplateForEdit(int listIndex, String rvscode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Text(
                  "Surgery # ${listIndex + 1}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                ),
              ),
              FormBuilderRadioGroup(
                  initialValue: surgeries[listIndex]['placeOfSurgery'] ?? "",
                  decoration: const InputDecoration(
                    labelText: 'Place of Surgery',
                  ),
                  name: "placeOfSurgery${listIndex + 1}",
                  options: const [
                    FormBuilderFieldOption(
                        value: 'ER', child: Text('Emergency Room (ER)')),
                    FormBuilderFieldOption(
                        value: 'OR', child: Text('Operating Room (OR)')),
                  ]),
              const SizedBox(height: 8),
              Text(
                "RVS Code and Procedure",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 8),
              FormTextField(
                name: "rvsCode${listIndex + 1}",
                labelName: "",
                initialValue: rvscode,
              ),
              // if (rvscode != "")
              //   FormBuilderSearchableDropdown(
              //     initialValue: rvscode,
              //     decoration: const InputDecoration(
              //       labelText: 'RVS Code and Procedure',
              //     ),
              //     name: "rvsCode${listIndex + 1}",
              //     items: RVSList,
              //   ),
              // if (rvscode == "")
              //   FormBuilderSearchableDropdown(
              //     decoration: const InputDecoration(
              //       contentPadding:
              //           EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //       ),
              //     ),
              //     name: "rvsCode${getSurgeriesNumber() + 1}",
              //     items: RVSList,
              //   ),
              const SizedBox(height: 16),
              FormBuilderRadioGroup(
                initialValue: surgeries[listIndex]['cavityInvolved'] ?? "",
                name: "cavityInvolved${listIndex + 1}",
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: "Cavity Involved for Surgery?",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                options: cavitiesForSurgery
                    .map((cavityItem) => FormBuilderFieldOption(
                          value: cavityItem,
                          child: Text(cavityItem),
                        ))
                    .toList(),
              ),
              FormBuilderCheckboxGroup(
                initialValue: surgeries[listIndex]['servicesPresent'] ?? [],
                name: "servicesPresent${listIndex + 1}",
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: "Services Present?",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                options: servicesOnboard
                    .map((serviceItem) => FormBuilderFieldOption(
                          value: serviceItem,
                          child: Text(serviceItem),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                "Surgery Details: ",
                style: TextStyle(color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 16),
              Text(
                "Surgery Type",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 16),
              FormTextField(
                name: "surgeryType${getSurgeriesNumber() + 1}",
                labelName: "",
                initialValue: surgeries[listIndex]['surgeryType'],
              ),
              // const SizedBox(height: 16),
              // FormBuilderTextField(
              //   initialValue: surgeries[listIndex]['phaseBegun'] ?? "",
              //   name: "phaseBegun${listIndex + 1}",
              //   decoration: const InputDecoration(
              //     labelText: "Phase begun",
              //     contentPadding:
              //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                initialValue: surgeries[listIndex]['surgeonID'] ?? "",
                name: "surgeon${listIndex + 1}",
                decoration: const InputDecoration(
                  labelText: "Surgeon",
                  labelStyle: TextStyle(fontSize: 18),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                initialValue: surgeries[listIndex]['startTimestamp'] != null
                    ? DateTime.tryParse(
                            surgeries[listIndex]['startTimestamp']) ??
                        DateTime.now()
                    : DateTime.now(),
                name: "startDateTime${listIndex + 1}",
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                firstDate: DateTime(2000),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                decoration: const InputDecoration(
                  labelText: "Surgery Start Date & Time",
                  labelStyle: TextStyle(fontSize: 18),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                initialValue: surgeries[listIndex]['endTimestamp'] != null
                    ? DateTime.tryParse(surgeries[listIndex]['endTimestamp']) ??
                        DateTime.now()
                    : DateTime.now(),
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                name: "endDateTime${listIndex + 1}",
                firstDate: DateTime(2000),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                decoration: const InputDecoration(
                  labelText: "Surgery End Date & Time",
                  labelStyle: TextStyle(fontSize: 18),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Hemorrhage Control Types",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 16),
              FormTextField(
                name: "hemorrhageControlType${getSurgeriesNumber() + 1}",
                labelName: "Types",
                initialValue: surgeries[listIndex]['hemorrhageControl']
                        ['hemmorhageType'] ??
                    "",
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                initialValue: surgeries[listIndex]['hemorrhageControl']
                            ['hemmorhageTimestamp'] !=
                        null
                    ? DateTime.parse(surgeries[listIndex]['hemorrhageControl']
                        ['hemmorhageTimestamp'])
                    : DateTime.now(),
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                name: "hemorrhageControlDateTime${listIndex + 1}",
                firstDate: DateTime(2000),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                decoration: const InputDecoration(
                  labelText: "Hemorrhage Controlled Date & Time",
                  labelStyle: TextStyle(fontSize: 18),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderRadioGroup(
                name: "outcome${getSurgeriesNumber() + 1}",
                initialValue: surgeries[listIndex]['outcome'] ?? "",
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: "Outcome?",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                options: const [
                  FormBuilderFieldOption(
                      value: 'Improved', child: Text('Improved')),
                  FormBuilderFieldOption(
                      value: 'Unimproved', child: Text('Unimproved')),
                  FormBuilderFieldOption(value: 'Died', child: Text('Died'))
                ],
                onChanged: (value) {
                  if (value == "Died") {
                    setState(() {
                      patientStatus = "Deceased";
                    });
                  } else {
                    patientStatus = "In-Hospital";
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void renderSurgeryWidgetsForEdit() {
    if (surgeries != []) {
      int lengthList = surgeries.length;
      for (var index = 0; index < lengthList; index++) {
        String rvscode = surgeries[index]['rvsCode'];

        setState(() {
          surgeryCardList.add(surgeryTemplateForEdit(index, rvscode));
        });
      }
    }
  }

  void addToHistory(List editHistory, Map<String, dynamic> editedItem) {
    if (editHistory.length >= 3) {
      editHistory.removeAt(0); // Remove the oldest history
    }
    editHistory.add(editedItem);
  }

  //end of arrays to transfer to centralized data file

  Future<void> _insertData(Map<String, dynamic> formValues) async {
    Map<String, dynamic> newEditHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    var createHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    List editHistory = record['editHistory'] ?? [];
    addToHistory(editHistory, newEditHistory);

    var surgeriesListForEdit = [];

    for (var index = 0; index < surgeryCardList.length; index++) {
      Map<String, dynamic> surgeriesListElement = {
        "placeOfSurgery": formValues["placeOfSurgery${index + 1}"],
        "rvsCode": nullChecker(formValues["rvsCode${index + 1}"]),
        "cavityInvolved": nullChecker(formValues["cavityInvolved${index + 1}"]),
        "servicesPresent":
            encryptList(formValues["servicesPresent${index + 1}"]),
        "phaseBegun": null,
        "startTimestamp": formValues["startDateTime${index + 1}"].toString(),
        "endTimestamp": formValues["endDateTime${index + 1}"].toString(),
        "surgeryType": nullChecker(formValues["surgeryType${index + 1}"]),
        "surgeonID": formValues["surgeon${index + 1}"],
        "hemorrhageControl": {
          "hemmorhageType": formValues["hemorrhageControlType${index + 1}"],
          "hemmorhageTimestamp":
              formValues["hemorrhageControlDateTime${index + 1}"].toString(),
        },
        "outcome": nullChecker(formValues["outcome${index + 1}"]),
      };

      surgeriesListForEdit.add(surgeriesListElement);
    }
    Map<String, dynamic> surgery = {
      "createHistory":
          isInSurgery ? createHistory : record['surgery']['createHistory'],
      "editHistory": editHistory,
      "needSurgery": encryp("yes"),
      "surgeriesList": surgeriesListForEdit,
      "dispositionSurgery": record['surgery']['dispositionSurgery'] != null
          ? encryp(record['surgery']['dispositionSurgery'])
          : null,
    };

    record['surgery'] = surgery;
    if (isInSurgery) {
      record['patientStatus'] = encryp(patientStatus);
    }

    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));

    await updateRecord(encodedpatientID, record, bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

  Future<void> readJsonCPT4Codes() async {
    final String response =
        await rootBundle.loadString('assets/json/cpt4.json');
    final data = await json.decode(response);
    setState(() {
      RVSCodes = data["CODES"];
      RVSList = RVSCodes.map(
              (RVSItem) => RVSItem["FIELD1"] + ": " + RVSItem["FIELD2"])
          .toList()
          .cast<String>();
    });
  }

  Widget surgeryTemplate({
    required int index,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        // elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Surgery # ${getSurgeriesNumber() + 1}",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Place of Surgery",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
                ),
              ),
              FormRadio(
                enabled: true,
                name: "placeOfSurgery${getSurgeriesNumber() + 1}",
                values: const ["ER", "OR"],
                texts: const ['Emergency Room (ER)', 'Operating Room (OR)'],
                validator: FormBuilderValidators.required(),
              ),
              Text(
                "RVS Code and Procedure",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 8),
              FormBuilderSearchableDropdown(
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                name: "rvsCode${getSurgeriesNumber() + 1}",
                items: RVSList,
              ),
              const SizedBox(height: 16),
              Text(
                "Cavity Involved for Surgery?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              FormBuilderRadioGroup(
                enabled: true,
                name: "cavityInvolved${getSurgeriesNumber() + 1}",
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // labelText: "Cav",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                options: cavitiesForSurgery
                    .map((cavityItem) => FormBuilderFieldOption(
                          value: cavityItem,
                          child: Text(cavityItem),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Text(
                "Services Present?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              FormBuilderCheckboxGroup(
                name: "servicesPresent${getSurgeriesNumber() + 1}",
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  // labelText: "Services Present?",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                options: servicesOnboard
                    .map((serviceItem) => FormBuilderFieldOption(
                          value: serviceItem,
                          child: Text(serviceItem),
                        ))
                    .toList(),
              ),
              Text(
                "Surgery Details",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 8),
              Text(
                "Surgery Type",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 8),
              FormBuilderSearchableDropdown(
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                name: "surgeryType${getSurgeriesNumber() + 1}",
                items: surgeryTypes,
              ),
              // FormTextField(
              //   name: "surgeryType${getSurgeriesNumber() + 1}",
              //   labelName: "Surgery Type",
              // ),
              // const SizedBox(height: 16),
              // FormTextField(
              //   name: "phaseBegun${getSurgeriesNumber() + 1}",
              //   labelName: "Phase Begun",
              //   // validator: FormBuilderValidators.required(),
              // ),
              const SizedBox(height: 8),
              FormTextField(
                name: "surgeon${getSurgeriesNumber() + 1}",
                labelName: "Surgeon ID",
                initialValue: userID,
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: "startDateTime${getSurgeriesNumber() + 1}",
                firstDate: DateTime(2000),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: "Surgery Start Date & Time",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: "endDateTime${getSurgeriesNumber() + 1}",
                firstDate: DateTime(2000),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: "Surgery End Date & Time",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Hemorrhage Control Types",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              const SizedBox(height: 8),
              FormBuilderSearchableDropdown(
                  decoration: const InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                  name: "hemorrhageControlType${getSurgeriesNumber() + 1}",
                  items: hemorrhageControlTypes),
              // FormTextField(
              //   name: ,
              //   labelName: "Hemorrhage Control Type (if any)",
              // ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: "hemorrhageControlDateTime${getSurgeriesNumber() + 1}",
                firstDate: DateTime(2000),
                lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day),
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                  labelText: "Hemorrhage Controlled Date & Time",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Disposition after Surgery:",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
              ),
              FormRadio(
                enabled: true,
                name: "dispositionSurgery",
                values: surgeryDispositions,
                texts: surgeryDispositions,
              ),
              FormBuilderRadioGroup(
                name: "outcome${getSurgeriesNumber() + 1}",
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  labelText: "Outcome?",
                  labelStyle: TextStyle(fontSize: 18),
                ),
                options: const [
                  FormBuilderFieldOption(
                      value: 'Improved', child: Text('Improved')),
                  FormBuilderFieldOption(
                      value: 'Unimproved', child: Text('Unimproved')),
                  FormBuilderFieldOption(value: 'Died', child: Text('Died'))
                ],
                onChanged: (value) {
                  if (value == "Died") {
                    setState(() {
                      patientStatus = "Deceased";
                    });
                  } else {
                    patientStatus = "In-Hospital";
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void addSurgeryWidget() {
    setState(() {
      surgeryCardList.add(surgeryTemplate(index: surgeryCardList.length));
    });
  }

  int getSurgeriesNumber() {
    return surgeryCardList.length;
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Next Phase'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Patient Status:',
                textAlign: TextAlign.center,
              ),
              FormDropdown(
                name: 'patientStatus',
                initialValue: patientStatus,
                items: disposition,
                // labelName: "",
                onChange: (newValue) {
                  setState(() {
                    patientStatus = newValue.toString();
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        const BorderSide(color: Colors.cyan),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: MaterialButton(
                    color: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _formKey.currentState!.save();
                      if (patientStatus != "") {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const PinCodeScreen(),
                              fullscreenDialog: true,
                            ));

                        if (result == true) {
                          setState(() {
                            isSending = true;
                          });
                          await _insertData(
                            _formKey.currentState!.value,
                          );
                          setState(() {
                            isSending = false;
                            isSentSuccessfully = true;
                          });
                        }
                      }
                      // }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog2() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: const Text(
            'I confirm that the Surgery Data is right.',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        const BorderSide(color: Colors.cyan),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: MaterialButton(
                    color: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _formKey.currentState!.save();
                      if (_formKey.currentState!.validate()) {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const PinCodeScreen(),
                              fullscreenDialog: true,
                            ));

                        if (result == true) {
                          setState(() {
                            isSending = true;
                          });
                          await _insertData(_formKey.currentState!.value);
                        }
                      }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    initializeData();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {
    await readJsonCPT4Codes();

    setState(() {
      initialSurgeriesNumber = getSurgeriesNumber();
      surgeryData = parseSurgeryRecord(widget.surgeryData);
      surgeries = surgeryData['surgeriesList'] ?? [];
      record = widget.record;
      isInSurgery = decryp(record['patientStatus']) == "In-Surgery";
    });
    print(surgeries);
    renderSurgeryWidgetsForEdit();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            if (!isSending && !isSentSuccessfully)
              MiniAppBarBack(
                onBack: widget.onBack,
              ),
            isSending
                ? const SendingWidget()
                : isSentSuccessfully
                    ? SuccessfulWidget(
                        message: "Successful!",
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                      )
                    : Expanded(
                        child: DefaultTabController(
                          length: 2, // Number of tabs
                          child: Scaffold(
                            appBar: AppBar(
                              backgroundColor: Colors.white,
                              toolbarHeight: 10,
                              bottom: TabBar(
                                controller: _tabController,
                                tabs: const [
                                  Tab(
                                    child: Text(
                                      "Editing",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Tab(
                                    child: Text(
                                      'View Docs',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.cyan,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            body: FormBuilder(
                              key: _formKey,
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  firstPage(context),
                                  ViewSummary(
                                      patientData: widget.patientData,
                                      patient: widget.fullRecord),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  Widget firstPage(BuildContext context) {
    return Scaffold(
      floatingActionButton: (isInSurgery)
          ? FloatingActionButton(
              onPressed: () {
                _formKey.currentState!.save();
                return addSurgeryWidget();
              },
              backgroundColor: Colors.cyan,
              shape: const CircleBorder(),
              elevation: 4, // Adjust the elevation as needed
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 42,
              ),
            )
          : null,
      persistentFooterButtons: [
        FormBottomButton(
          formKey: _formKey,
          onSubmitPressed: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              if (record['patientStatus'] == "In-Surgery") {
                _showConfirmationDialog();
              } else {
                _showConfirmationDialog2();
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Fill all required fields"),
                  duration: Duration(seconds: 5),
                ),
              );
            }
          },
        )
      ],
      body: Column(
        children: [
          Expanded(
            // child: Scaffold(
            //   body: FormBuilder(
            //     key: _formKey,
            //     autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (surgeryCardList.isNotEmpty)
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: surgeryCardList.length,
                        itemBuilder: (context, index) {
                          return surgeryCardList[index];
                        },
                      ),
                    ),
                  if (surgeryCardList.isEmpty)
                    Expanded(
                      child: Center(
                        child: Text(
                          "Surgery Data is Empty",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900]),
                        ),
                      ),
                    )
                ],
              ),
            ),
            //   ),
            // ),
          )
        ],
      ),
    );
  }
}
