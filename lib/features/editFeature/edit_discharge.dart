import 'package:dashboard/api_requests/updateRecord.dart';
import 'package:dashboard/features/viewFeature/viewSummary.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/helperFunctions.dart';
import 'package:dashboard/screens/home_page.dart';
import 'package:dashboard/screens/pincode.dart';
import 'package:dashboard/widgets/formWidgets/formTextArea.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../globals.dart' as globals;

import 'dart:convert';

import '../../widgets/widgets.dart';
import '../../widgets/formWidgets/formWidgets.dart';

// import 'package:dashboard/globals.dart';

var uuid = const Uuid();
DateTime current = DateTime.now();

// ignore: camel_case_types, must_be_immutable
class editDischarge extends StatelessWidget {
  final Map<String, dynamic> dischargeData;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;

  final Map<String, dynamic> record;
  const editDischarge(
      {super.key,
      required this.dischargeData,
      required this.patientData,
      required this.fullRecord,
      required this.record,
      required this.onBack});

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
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: Colors.black,
            fontSizeFactor: 1.0,
            decoration: TextDecoration.none,
          )),
      home: EditDischarge(
          discharge: dischargeData,
          record: record,
          onBack: onBack,
          patientData: patientData,
          fullRecord: fullRecord),
    );
  }
}

// ignore: camel_case_types
class EditDischarge extends StatefulWidget {
  final Map<String, dynamic> discharge;
  final Map<String, dynamic> record;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;
  const EditDischarge(
      {super.key,
      required this.discharge,
      required this.record,
      required this.patientData,
      required this.fullRecord,
      required this.onBack});

  @override
  // ignore: library_private_types_in_public_api
  EditDischargeState createState() => EditDischargeState();
}

// ignore: camel_case_types
class EditDischargeState extends State<EditDischarge>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late Map<String, dynamic> dischargeData;

  //Full Record
  late Map<String, dynamic> record;
  String patientStatus = 'Discharged';

  //Screens
  bool isLoading = false;
  bool isSending = false;
  bool isSentSuccessfully = false;

  //List
  // Discharge Data
  // ignore: non_constant_identifier_names
  // List<dynamic> ICDCodes = [];
  // ignore: non_constant_identifier_names
  List<String> ICDCodesArray = [];
  List dischargeDispositionArray = [
    'Home Discharge',
    'Discharge Against Medical Advice (DAMA)',
    'Transfer to Another Facility',
    'Hospice Care',
    'Rehabilitation Facility',
    'Long-Term Care Facility',
    'Observation Status',
    'Transferred to Psychiatric Facility',
    'Left Against Medical Advice (LAMA)',
    'Deceased'
  ];

  late TabController _tabController;

  void addToHistory(List editHistory, Map<String, dynamic> editedItem) {
    if (editHistory.length >= 3) {
      editHistory.removeAt(0); // Remove the oldest history
    }
    editHistory.add(editedItem);
  }

  Future<void> _insertData(Map<String, dynamic> formValues) async {
    Map<String, dynamic> newEditHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    List editHistory = record['editHistory'] ?? [];
    addToHistory(editHistory, newEditHistory);

    Map<String, dynamic> discharge = {
      "createHistory": dischargeData['createHistory'],
      "editHistory": editHistory,
      "isTreatmentComplete":
          nullChecker(formValues["treatmentCompletedDischarge"]),
      "finalDiagnosis": nullChecker(formValues["icdCodeDischarge"]),
      "dispositionDischarge": nullChecker(formValues["dispositionDischarge"])
    };

    record['discharge'] = discharge;

    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));
    await updateRecord(encodedpatientID, record, bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

  Widget treatmentCompleted(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: widthScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Treatment Completed?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            FormRadio(
              enabled: true,
              name: "treatmentCompletedDischarge",
              values: const ["yes", "no"],
              texts: const ["yes", "no"],
              initialValue: dischargeData["isTreatmentComplete"].toString(),
              validator: FormBuilderValidators.required(),
            ),
          ],
        ),
      ),
    );
  }

  Widget icdCodeAndDiagnosis(BuildContext context) {
    // var widthScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // const Text(
          //   "Final Diagnosis",
          //   style: TextStyle(
          //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          // ),
          // const Text(
          //   "(Description)",
          //   style: TextStyle(
          //       color: Colors.black87,
          //       fontSize: 12,
          //       fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 8),
          FormTextArea(
            name: "icdCodeDischarge",
            labelName: "Final Diagnosis",
            initialValue: dischargeData["finalDiagnosis"].toString(),
          )
          // FormBuilderSearchableDropdown(
          //   name: "icdCodeDischarge",
          //   decoration: const InputDecoration(
          //     // labelText: "Final Diagnosis (ICD Code and Description)",
          //     contentPadding:
          //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //     ),
          //   ),
          //   initialValue: dischargeData["finalDiagnosis"].toString(),
          //   items: ICDCodesArray,
          //   validator: FormBuilderValidators.required(),
          // ),
        ],
      ),
    );
  }

  Widget dischargeDisposition(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: widthScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              "Disposition on Discharge?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            FormBuilderRadioGroup(
              name: "dispositionDischarge",
              // initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]["discharge"]["dispositionDischarge"],
              initialValue: dischargeData['dispositionDischarge'].toString(),
              validator: FormBuilderValidators.required(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                // labelText: "Disposition on Discharge?",
                labelStyle: TextStyle(fontSize: 18),
              ),
              options: dischargeDispositionArray
                  .map((dispoItem) => FormBuilderFieldOption(
                        value: dispoItem,
                        child: Text('$dispoItem'),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == 'Deceased') {
                  patientStatus = 'Deceased';
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: const Text(
            'Are you sure you want to change the Discharge Data?',
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
                      "Yes",
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

  // End of Discharge Data Widgets

  @override
  void initState() {
    dischargeData = widget.discharge;
    record = widget.record;
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }

  Widget firstPage(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        FormBottomButton(
          formKey: _formKey,
          onSubmitPressed: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              _showConfirmationDialog();
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
            //       key: _formKey,
            //       autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    treatmentCompleted(context),
                    icdCodeAndDiagnosis(context),
                    dischargeDisposition(context)
                  ],
                ),
              ),
            ),
          ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
