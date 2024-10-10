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
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../widgets/formWidgets/formWidgets.dart';
import '../../globals.dart' as globals;
import 'package:dashboard/api_requests/updateRecord.dart';
import 'dart:convert';
import '../../widgets/widgets.dart';

DateTime current = DateTime.now();

// ignore: camel_case_types
class addER extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final Map<String, dynamic> record;
  final VoidCallback onBack;

  const addER(
      {super.key,
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
        ),
      ),
      home: AddER(
          record: record,
          onBack: onBack,
          patientData: patientData,
          fullRecord: fullRecord),
    );
  }
}

// ignore: camel_case_types
class AddER extends StatefulWidget {
  final Map<String, dynamic> record;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;

  const AddER({
    super.key,
    required this.record,
    required this.onBack,
    required this.patientData,
    required this.fullRecord,
  });

  @override
  // ignore: library_private_types_in_public_api
  AddERState createState() => AddERState();
}

// ignore: camel_case_types
class AddERState extends State<AddER> with SingleTickerProviderStateMixin {
  String address = "";
  // Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Screens
  bool isLoading = false;
  bool isSending = false;
  bool isSentSuccessfully = false;

  // General Data
  String patientStatus = 'In-Hospital';
  late Map<String, dynamic> record;

  // ER Data
  bool visibleTransferDetails = false;
  bool visiblePatientArrivalStatus = false;
  bool visibleOutrightSurgery = false;

  // Start of arrays to transfer to centralized data file
  List<String> phase = [
    'Pending Surgery',
    'In-Hospital',
    'Pending Discharge',
    'Deceased'
  ];

  late TabController _tabController;

  //Start of ER Widgets

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
            onChanged: (valuePatientTransferred) {
              if (valuePatientTransferred == "yes") {
                setState(() {
                  visibleTransferDetails =
                      true; //verify for conditional rendering
                });
              } else {
                setState(() {
                  visibleTransferDetails =
                      false; //verify for conditional rendering
                });
              }
            },
            values: const ['yes', 'no'],
            texts: const ['Yes', 'No'],
          ),
          Visibility(
            visible: visibleTransferDetails,
            child: Card(
              // elevation: 5,
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
          onChanged: (valuePatientArrival) {
            if (valuePatientArrival == "Alive") {
              setState(() {
                visiblePatientArrivalStatus = true;
              });
            } else {
              patientStatus = 'Deceased';
              _formKey.currentState!.fields['outcome']!.didChange('Died');

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
            // elevation: 5,
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
            name: "modeOfTransport",
            items: modeOfTranspo,
          )
        ],
      ),
    );
  }

  Padding patientStatusDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 8),
        // const Text(
        //   "Initial Impression",
        //   style: TextStyle(
        //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: 8),
        const FormTextArea(
          name: 'initialImpression',
          labelName: "Initial Impression",
        ),
        const SizedBox(height: 16),
        const Text(
          "Outcome",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormRadio(
          enabled: patientStatus == 'Deceased' ? false : true,
          name: 'outcome',
          onChanged: (value) {
            if (value == 'Died') {
              patientStatus = 'Deceased';
            }
          },
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
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Is Referred?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            FormRadio(
              enabled: true,
              name: "isReferred",
              values: ["yes", "no"],
              texts: ["yes", "no"],
            ),
            SizedBox(height: 16),
            Text(
              "Originating Hospital (ID)",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FormTextField(name: "originatingHospitalID", labelName: ""),
            SizedBox(height: 16),
            Text(
              "Previous Physician (ID)",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FormTextField(name: "previousPhysicianID", labelName: ''),
          ]),
    );
  }

  Padding condArrivalStatus() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
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
            values: ["Conscious", "Unconscious", "In Extremis"],
            texts: ["Conscious", "Unconscious", "In Extremis"],
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
          FormRadio(
            enabled: true,
            name: "cavityForSurgery",
            values: cavitiesForSurgery,
            texts: cavitiesForSurgery,
          ),
          const SizedBox(height: 16),
          const Text(
            "Services on Board",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormCheckbox(name: "servicesOnboardSurgery", options: servicesOnboard)
        ],
      ),
    );
  }

  //End of ER Widget

  //Start of Layout Widgets
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Patient Status:',
                textAlign: TextAlign.center,
              ),
              FormDropdown(
                name: "patientStatus",
                initialValue: patientStatus,
                items: phase,
                onChange: (value) {
                  patientStatus = value.toString();
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

  Padding buttonNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
              style: ButtonStyle(
                side: WidgetStateProperty.all(
                  const BorderSide(color: Colors.cyan),
                ),
              ),
              child: const Text(
                "Reset",
                style: TextStyle(color: Colors.cyan),
              ),
              onPressed: () {
                _formKey.currentState!.save();
                _formKey.currentState!.reset();
              },
            ),
          ),
        ],
      ),
    );
  }

  //End of Layout Widgets

  Future<void> _insertData(Map<String, dynamic> formValues) async {
    if (visiblePatientArrivalStatus == false) {
      _formKey.currentState!.fields['statusOnArrival']!
          .didChange('Dead on Arrival');
    }

    var createHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    Map<String, dynamic> er = {
      "isTransferred": nullChecker(formValues["patientTransferred"]),
      "previousHospitalID": formValues["originatingHospitalID"],
      "previousPhysicianID": formValues["previousPhysicianID"],
      "isReferred": nullChecker(formValues["isReferred"]),
      "servicesOnboard": encryptList(formValues["servicesOnboardSurgery"]),
      "editHistory": [],
      "createHistory": createHistory,
      "aliveCategory": nullChecker(formValues["aliveStatus"]),
      "cavityInvolved": nullChecker(formValues["cavityForSurgery"]),
      "dispositionER": nullChecker(patientStatus),
      "externalCauseICD": null,
      "natureofInjuryICD": null,
      "initialImpression": nullChecker(formValues["initialImpression"]),
      "isSurgical": nullChecker(formValues["outrightSurgical"]),
      "outcome": nullChecker(formValues["outcome"]),
      "statusOnArrival": nullChecker(formValues["statusOnArrival"]),
      "transportation": nullChecker(formValues["modeOfTransport"]),
    };

    record['patientStatus'] = nullChecker(patientStatus);
    record['er'] = er;

    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));
    await updateRecord(encodedpatientID, record, bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

  @override
  void initState() {
    super.initState();
    record = widget.record;
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
                                    "Adding",
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
        ),
      ],
      body: Column(
        children: [
          Expanded(
            // child: Scaffold(
            //   body: FormBuilder(
            //     key: _formKey,
            //     autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
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
