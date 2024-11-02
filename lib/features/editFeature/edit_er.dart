import 'package:dashboard/api_requests/updateRecord.dart';
import 'package:dashboard/features/viewFeature/viewSummary.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/helperFunctions.dart';
import 'package:dashboard/initializedList.dart';
import 'package:dashboard/screens/home_page.dart';
import 'package:dashboard/screens/pincode.dart';
import 'package:dashboard/widgets/formWidgets/formTextArea.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../core/models/_models.dart';
import '../../widgets/formWidgets/formWidgets.dart';

import '../../globals.dart' as globals;

import 'dart:convert';
import '../../widgets/widgets.dart';

var uuid = const Uuid();
DateTime current = DateTime.now();

// ignore: camel_case_types
class editER extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;
  final Map<String, dynamic> erData;
  final Map<String, dynamic> record;

  const editER({
    super.key,
    required this.erData,
    required this.onBack,
    required this.patientData,
    required this.fullRecord,
    required this.record,
  });

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
      home: EditER(
          erData: erData,
          record: record,
          onBack: onBack,
          patientData: patientData,
          fullRecord: fullRecord),
    );
  }
}

// ignore: camel_case_types
class EditER extends StatefulWidget {
  final Map<String, dynamic> erData;
  final VoidCallback onBack;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final Map<String, dynamic> record;
  const EditER(
      {super.key,
      required this.erData,
      required this.patientData,
      required this.fullRecord,
      required this.record,
      required this.onBack});

  @override
  // ignore: library_private_types_in_public_api
  EditERState createState() => EditERState();
}

// ignore: camel_case_types
class EditERState extends State<EditER> with SingleTickerProviderStateMixin {
  // Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Address
  String address = "";

  // Full Record
  late Map<String, dynamic> record;

  // Screens
  bool isLoading = false;
  bool isSending = false;
  bool isSentSuccessfully = false;

  // ER Data
  var isAlive = "";
  bool visibleTransferDetails = false;
  bool visiblePatientArrivalStatus = false;
  bool visibleOutrightSurgery = false;
  late Map<String, dynamic> erData;

  late TabController _tabController;

  String currentDate() {
    var date = DateTime.now();
    var formattedDate = DateFormat('').format(date);

    return formattedDate;
  }

  String formatDate(DateTime date) {
    String init = " ";

    return init;
  }

  void addToHistory(List editHistory, Map<String, dynamic> editedItem) {
    if (editHistory.length >= 3) {
      editHistory.removeAt(0); // Remove the oldest history
    }
    editHistory.add(editedItem);
  }

  Future<void> _insertData(
    Map<String, dynamic> formValues,
  ) async {
    Map<String, dynamic> newEditHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    List editHistory = [];
    addToHistory(editHistory, newEditHistory);
    Map<String, dynamic> er = {
      "isTransferred": nullChecker(formValues["patientTransferred"]),
      "previousHospitalID": formValues["originatingHospitalID"],
      "previousPhysicianID": formValues["previousPhysicianID"],
      "isReferred": nullChecker(formValues["isReferred"]),
      "servicesOnboard": encryptList(formValues["servicesOnboardSurgery"]),
      "editHistory": editHistory,
      "createHistory": record['er']['createHistory'],
      "aliveCategory": nullChecker(formValues["aliveStatus"]),
      "cavityInvolved": nullChecker(formValues["cavityForSurgery"]),
      "dispositionER": record['er']['dispositionER'],
      "externalCauseICD": null,
      "natureofInjuryICD": null,
      "initialImpression": nullChecker(formValues["initialImpression"]),
      "isSurgical": nullChecker(formValues["outrightSurgical"]),
      "outcome": nullChecker(formValues["outcome"]),
      "statusOnArrival": nullChecker(formValues["statusOnArrival"]),
      "transportation": nullChecker(formValues["modeOfTransport"]),
    };

    record['er'] = er;

    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));

    await updateRecord(encodedpatientID, record, bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

  //layout modules for ER Data

  Padding patientTransferDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Patient Transferred?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            name: 'patientTransferred',
            initialValue: erData['isTransferred'],
            onChanged: (valuePatientTransferred) {
              if (valuePatientTransferred == "yes") {
                setState(() {
                  visibleTransferDetails = true;
                });
              } else {
                setState(() {
                  visibleTransferDetails = false;
                });
              }
            },
            values: const ['yes', 'no'],
            texts: const ['Yes', 'No'],
          ),
          Visibility(
            visible: visibleTransferDetails,
            child: Card(
              // // elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: condTransferDetails(),
            ),
          ),
        ],
      ),
    );
  }

  Padding patientArrivalDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        const Text(
          "Status on Arrival?",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormRadio(
          enabled: true,
          name: "statusOnArrival",
          initialValue: isAlive,
          onChanged: (valuePatientArrival) {
            if (valuePatientArrival == "Alive") {
              setState(() {
                visiblePatientArrivalStatus = true;
              });
            } else {
              setState(() {
                visiblePatientArrivalStatus = false;
              });
            }
          },
          values: const ['Dead on Arrival', 'Alive'],
          texts: const ['Dead on Arrival', 'Alive'],
        ),
        Visibility(
          visible: visiblePatientArrivalStatus,
          child: Card(
            // // elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            child: condArrivalStatus(),
          ),
        ),
      ]),
    );
  }

  Padding patientTransportationDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Model of Transportation",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormDropdown(
            initialValue: erData["transportation"],
            name: "modeOfTransport",
            items: modeOfTranspo,
            // labelName: "Mode of Transportation?",
          )
        ],
      ),
    );
  }

  Padding patientStatusDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        // const Text(
        //   "Initial Impression",
        //   style: TextStyle(
        //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: 8),
        FormTextArea(
            initialValue: erData['initialImpression'],
            name: 'initialImpression',
            labelName: "Initial Impression"),
        const SizedBox(height: 16),
        // const Text(
        //   "ICD 10 Code/s: Nature of Injury:",
        //   style: TextStyle(
        //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 8),
        // FormBuilderSearchableDropdown(
        //   initialValue: erData["natureofInjuryICD"].toString(),
        //   name: "natureofInjuryICD",
        //   decoration: const InputDecoration(
        //     contentPadding:
        //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
        //     ),
        //   ),
        //   items: ICDCodesArray,
        // ),
        // const SizedBox(height: 16),
        // const Text(
        //   "ICD 10 Code/s: External Cause of Injury:",
        //   style: TextStyle(
        //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        // const SizedBox(height: 8),
        // FormBuilderSearchableDropdown(
        //   name: "externalCauseICD",
        //   initialValue: erData["externalCauseICD"].toString(),
        //   decoration: const InputDecoration(
        //     contentPadding:
        //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
        //     ),
        //   ),
        //   items: ICDCodesArray,
        //   // validator: FormBuilderValidators.required(),
        // ),
        // const SizedBox(height: 16),
        // const Text(
        //   "Patient Disposition",
        //   style: TextStyle(
        //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        // FormRadio(
        //   enabled: true,
        //   initialValue: erData['dispositionER'],
        //   name: "patientDisposition",
        //   values: disposition,
        //   texts: disposition,
        // ),
        const SizedBox(height: 16),
        const Text(
          "Outcome",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormRadio(
          enabled: true,
          name: 'outcome',
          initialValue: erData['outcome'],
          values: const ['Improved', 'Unimproved', 'Died'],
          texts: const ['Improved', 'Unimproved', 'Died'],
        ),
      ]),
    );
  }

  Padding patientOutrightSurgeryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        const Text(
          "Outright Surgery",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormRadio(
          enabled: true,
          name: 'outrightSurgical',
          initialValue: erData['isSurgical'],
          onChanged: (valueSurgical) {
            if (valueSurgical == "yes") {
              setState(() {
                visibleOutrightSurgery = true;
              });
            } else {
              setState(() {
                visibleOutrightSurgery = false;
              });
            }
          },
          values: const [
            'yes',
            'no',
          ],
          texts: const [
            'Yes',
            'No',
          ],
        ),
        Visibility(
          visible: visibleOutrightSurgery,
          child: Card(
            // elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            child: condSurgicalDetails(),
          ),
        ),
      ]),
    );
  }

  Padding condTransferDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Is Referred?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            initialValue: erData['isReferred'],
            name: "isReferred",
            values: const ["yes", "no"],
            texts: const ["yes", "no"],
          ),
          const SizedBox(height: 16),
          const Text(
            "Originating Hospital (ID)",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormTextField(
              initialValue: erData['previousHospitalID'],
              name: "originatingHospitalID",
              labelName: ""),
          const SizedBox(height: 16),
          const Text(
            "Previous Physician (ID)",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormTextField(
              initialValue: erData['previousPhysicianID'],
              name: "previousPhysicianID",
              labelName: ''),
        ],
      ),
    );
  }

  Padding condArrivalStatus() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "State on Arrival?",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          FormRadio(
            enabled: true,
            name: "aliveStatus",
            initialValue: erData['aliveCategory'],
            values: const ["Conscious", "Unconscious", "In Extremis"],
            texts: const ["Conscious", "Unconscious", "In Extremis"],
          )
        ],
      ),
    );
  }

  Padding condSurgicalDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cavity for surgery:",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormTextField(
            initialValue: erData['cavityInvolved'],
            name: "cavityForSurgery",
            labelName: "",
          ),
          const SizedBox(height: 16),
          const Text(
            "Services on Board",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormCheckbox(
            initialValue: erData['servicesOnboard'],
            name: "servicesOnboardSurgery",
            options: servicesOnboard,
          )
        ],
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
            'Are you sure you want to change the ER Data?',
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

  @override
  void initState() {
    super.initState();
    erData = parseERRecord(widget.erData);
    record = widget.record;

    visibleTransferDetails = erData['isTransferred'] == "yes";

    if (erData['aliveCategory'] != "Dead on Arrival") {
      visiblePatientArrivalStatus = true;
      isAlive = "Alive";
    } else {
      isAlive = "Dead on Arrival";
    }

    visibleOutrightSurgery = erData['isSurgical'] == "yes";
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
          if (!isSending && !isSentSuccessfully && !isLoading)
            MiniAppBarBack(
              onBack: widget.onBack,
            ),
          isLoading
              ? const LoadingWidget()
              : isSending
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
            // child:
            // DefaultTabController(
            //   initialIndex: 0,
            //   length: 3,
            // child: Scaffold(
            //   body: FormBuilder(
            //     key: _formKey,
            //     autovalidateMode: AutovalidateMode.onUserInteraction,
            //     child: Scaffold(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            patientTransferDetails(),
                            patientArrivalDetails(),
                            patientTransportationDetails(),
                            patientStatusDetails(),
                            patientOutrightSurgeryDetails(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // ),
            ),
            // ),
            // ),
            // ),
          ),
        ],
      ),
    );
  }
}
