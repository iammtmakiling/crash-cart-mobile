import '../../core/api_requests/_api.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/main/main_navigation.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../widgets/formWidgets/formWidgets.dart';
import '../../globals.dart' as globals;
import '../../core/utils/helper_utils.dart';
import '../../initializedList.dart';

DateTime current = DateTime.now();

// ignore: camel_case_types
class addPreHospital extends StatelessWidget {
  final Map<String, dynamic> patient;
  final String patientType;

  final VoidCallback onBack;

  const addPreHospital(
      {super.key,
      required this.patient,
      required this.patientType,
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
      home: AddPreHospital(
          patient: patient, patientType: patientType, onBack: onBack),
    );
  }
}

// ignore: camel_case_types
class AddPreHospital extends StatefulWidget {
  final Map<String, dynamic> patient;
  final String patientType;

  final VoidCallback onBack;
  // const addPatient({super.key, required this.onBack});

  const AddPreHospital(
      {super.key,
      required this.patient,
      required this.patientType,
      required this.onBack});

  @override
  // ignore: library_private_types_in_public_api
  AddPreHospitalState createState() => AddPreHospitalState();
}

// ignore: camel_case_types
class AddPreHospitalState extends State<AddPreHospital>
    with SingleTickerProviderStateMixin {
  String address = "";
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> patient;
  late String patientType;
  //Screens
  bool isLoading = false;
  bool isSending = false;
  bool isSentSuccessfully = false;

  //General Data
  var patientStatus = "";

  //Place of Injury
  String regionId = "";
  String provincesId = "";
  String citiesId = "";
  String regionDesc = "";
  String provincesDesc = "";
  String citiesDesc = "";

  //Pre-Hospital Data
  bool visibleFirstAidGiven = false;
  bool visibleVehicularAccident = false;
  bool visibleMedicolegal = false;
  bool visibleColision = false;

  List<String> phase = [
    'For Surgery',
    'For Admission',
    'For Discharge',
    'For Transfer',
    'Died',
  ];

  //Dropdown Values
  String ddChiefComplaint = 'Trauma/Injuries...';
  String ddMethodGiven = "";
  String ddPlaceofOccurence = "";
  String ddMedicolegal = "";
  String ddCavityForSurgery = "";

  List<String> errorFields = [];
  late TabController _tabController;

  //Start of PreHospital Widgets
  Padding dateTimeInjury() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          FractionallySizedBox(
            widthFactor: 0.95,
            child: FormBuilderDateTimePicker(
              name: 'dateTimeInjury',
              firstDate: DateTime(1900),
              lastDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute),
              format: DateFormat('yyyy-MM-dd HH:mm:ss'),
              onChanged: (DateTime? value) {},
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                labelText: "Date and Time of Injury",
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 10.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding condFirstAiderDetails() {
    // need validators for ID format
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Name of First Aider:",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const FormTextField(name: "firstAider", labelName: ""),
          const SizedBox(height: 16),
          const Text(
            "Is first aid given properly?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
              enabled: true,
              name: "firstAidGivenProperly",
              values: yesNoList,
              texts: yesNoList),
          const SizedBox(height: 16),
          const Text(
            "Method given:",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormDropdown(name: "methodGiven", items: firstAidMethods),
        ],
      ),
    );
  }

  Padding condVehicularAccident() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Type of Vehicular Accident?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            name: 'typeVehicularAccident',
            values: vehicleAccidentType,
            texts: vehicleAccidentType,
          ),
          const SizedBox(height: 16),
          const Text(
            "Collision or Non-Collision",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            name: 'collisionOrNonCollision',
            values: const ['Collision', 'Non-Colision'],
            texts: const ['Collision', 'Non-Colision'],
            onChanged: (collisionValue) {
              if (collisionValue == "Collision") {
                setState(() {
                  visibleColision = true;
                });
              } else {
                setState(() {
                  visibleColision = false;
                });
              }
            },
          ),
          const SizedBox(height: 8),
          const Text(
            "Patient's Vehicle",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            name: 'patientVehicle',
            values: ['(none) Pedestrian', ...vehiclesList],
            texts: ['(none) Pedestrian', ...vehiclesList],
          ),
          const SizedBox(height: 8),
          if (visibleColision)
            const Text(
              "Other Party's Vehicle",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          if (visibleColision) const SizedBox(height: 8),
          if (visibleColision)
            FormRadio(
                enabled: true,
                name: 'otherVehicle',
                values: vehiclesList,
                texts: vehiclesList),
          const SizedBox(height: 8),
          const Text(
            "Position of Patient?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
              enabled: true,
              name: 'positionOfPatient',
              values: positionOfPatientList,
              texts: positionOfPatientList),
          const SizedBox(height: 8),
          const Text(
            "Place of Occurence?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const FormTextField(
              name: 'placeOfOccurrence',
              labelName: 'Place of Occurence? (Type "Unknown" if not known)'),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Padding condMedicolegal() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Cetegory",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            name: "medicolegalCategory",
            values: medicolegalList,
            texts: medicolegalList,
          ),
        ],
      ),
    );
  }

  Padding injuryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "Place of Injury",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormAddress(
          enabled: true,
          regionId: regionId,
          provincesId: provincesId,
          citiesId: citiesId,
          onRegionIDChanged: (String? newValue) {
            setState(() {
              regionId = newValue!;
            });
          },
          onProvincesIDChanged: (String? newValue) {
            setState(() {
              provincesId = newValue!;
            });
          },
          onCitiesIDChanged: (String? newValue) {
            setState(() {
              citiesId = newValue!;
            });
          },
          onRegionDescChanged: (String? newValue) {
            setState(() {
              regionDesc = newValue!;
            });
          },
          onProvincesDescChanged: (String? newValue) {
            setState(() {
              provincesDesc = newValue!;
            });
          },
          onCitiesDescChanged: (String? newValue) {
            setState(() {
              citiesDesc = newValue!;
            });
          },
        ),
        const SizedBox(height: 16),
        const Text(
          "Date and Time of Injury",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        dateTimeInjury(),
        const SizedBox(height: 16),
        const Text(
          "Injury Intent",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormRadio(
            enabled: true,
            name: 'injuryType',
            values: injuryTypeList,
            texts: injuryTypeList),
      ]),
    );
  }

  Padding firstAidDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          "First Aid Given",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormRadio(
          enabled: true,
          name: 'firstAidGiven',
          onChanged: (valueFirstAidGiven) {
            if (valueFirstAidGiven == "yes") {
              setState(() {
                visibleFirstAidGiven = true; //verify for conditional rendering
              });
            } else {
              setState(() {
                visibleFirstAidGiven = false; //verify for conditional rendering
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
          visible: visibleFirstAidGiven,
          child: Card(
            // elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            child: condFirstAiderDetails(),
          ),
        ),
      ]),
    );
  }

  Padding natureOfInjuryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Nature of Injury",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormCheckbox(name: "naturesOfInjury", options: naturesOfInjury),
          const SizedBox(height: 12),
          const FormTextField(
              name: "natureOfInjuryExtraInfo", labelName: "Additional Details"),
          const SizedBox(height: 16),
          const Text(
            "External Cause of Injury",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          FormCheckbox(
              name: 'externalCauseOfInjury', options: externalCausesInjury)
          // FormDropdown(
          //   name: 'externalCauseOfInjury',
          //   items: externalCausesInjury,
          //   labelName: "External Causes of Injury",
          // ),
        ],
      ),
    );
  }

  Padding vehicularDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vehicular Accident?",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            FormRadio(
              enabled: true,
              name: 'vehicularAccidentBool',
              onChanged: (valueVehicularAccident) {
                if (valueVehicularAccident == "yes") {
                  setState(() {
                    visibleVehicularAccident = true;
                  });
                } else {
                  setState(() {
                    visibleVehicularAccident = false;
                  });
                }
              },
              values: const ['yes', 'no'],
              texts: const ['Yes', 'No'],
            ),
            Visibility(
              visible: visibleVehicularAccident,
              child: Card(
                // // elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: condVehicularAccident(),
              ),
            ),
          ]),
    );
  }

  Padding activityDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        const Text(
          "Activity During Injury?",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const FormCheckbox(
          name: 'activityDuringAccident',
          options: ['Sports', 'Leisure', 'Work-related', 'Unknown'],
        ),
        const SizedBox(height: 16),
        const Text(
          "Other risk factors at the time of the incident:",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        FormCheckbox(name: "otherRisksFactors", options: otherRisksFactors),
        // const FormTextField(
        //   name: 'otherRisksFactors',
        //   labelName: 'Other Risk Factors? (Type "Unknown" if not known)',
        // ),
        const SizedBox(height: 16),
        const Text(
          "Safety Issues? (Select all that apply)",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormCheckbox(name: 'safetyIssues', options: safetyIssues)
      ]),
    );
  }

  Padding medicolegalDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        const Text(
          "Medicolegal Case?",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        FormRadio(
          enabled: true,
          name: 'medicolegalCase',
          onChanged: (valueMedicolegalCase) {
            if (valueMedicolegalCase == "yes") {
              setState(() {
                visibleMedicolegal = true;
              });
            } else {
              setState(() {
                visibleMedicolegal = false;
              });
            }
          },
          values: const ['yes', 'no'],
          texts: const ['Yes', 'No'],
        ),
        Visibility(
          visible: visibleMedicolegal,
          child: Card(
            // // elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.white,
            child: condMedicolegal(),
          ),
        ),
      ]),
    );
  }

  Padding chiefComplaint() {
    // need validators for ID format
    return const Padding(
        padding: EdgeInsets.fromLTRB(16.0, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Chief Complaint",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FormTextField(name: 'chiefComplaint', labelName: 'Chief Complaint'),
          ],
        ));
  }

  Padding massInjuryTF() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mass Injury",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            name: 'massInjury',
            values: ['yes', 'no'],
            texts: ['Yes', 'No'],
          ),
        ],
      ),
    );
  }

  //End of PreHospital Widgets

  //Start of Layout Widgets
  // Future<void> _showConfirmationDialog() async {
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: false, // user must tap button!
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         // title: const Text('Next Phase'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             const Text(
  //               'Patient Status:',
  //               textAlign: TextAlign.center,
  //             ),
  //             FormDropdown(
  //               name: "patientStatus",
  //               items: phase,
  //               labelName: "",
  //               onChange: (value) {
  //                 if (value == "For Surgery") {
  //                   patientStatus = "Pending Surgery";
  //                 } else if (value == "For Admission") {
  //                   patientStatus = 'In-Hospital';
  //                 } else if (value == "Died" || value == "For Discharge") {
  //                   patientStatus = 'Pending Discharge';
  //                 } else {
  //                   patientStatus = value.toString();
  //                 }
  //               },
  //             ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Expanded(
  //                 child: OutlinedButton(
  //                   style: ButtonStyle(
  //                     side: MaterialStateProperty.all(
  //                       const BorderSide(color: Colors.cyan),
  //                     ),
  //                   ),
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: const Text(
  //                     "Cancel",
  //                     style: TextStyle(color: Colors.cyan),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 20),
  //               Expanded(
  //                 child: MaterialButton(
  //                   color: Colors.cyan,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20.0),
  //                   ),
  //                   onPressed: () async {
  //                     Navigator.of(context).pop();
  //                     _formKey.currentState!.save();
  //                     if (_formKey.currentState!.validate()) {
  //                       var result = await Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (BuildContext context) =>
  //                                 const PinCodeScreen(),
  //                             fullscreenDialog: true,
  //                           ));

  //                       if (result == true) {
  //                         setState(() {
  //                           isSending = true;
  //                         });

  //                         // Simulate sending data with a delay of 2 seconds
  //                         Future.delayed(const Duration(seconds: 2), () {
  //                           // Set isSending back to false when done
  //                           setState(() {
  //                             isSending = false;
  //                             isSentSuccessfully = true;
  //                           });
  //                         });

  //                         // Navigator.of(context).pop();
  //                         await _insertData(_formKey.currentState!.value);
  //                       }
  //                     }
  //                   },
  //                   child: const Text(
  //                     "Confirm",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

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

  Future<String> generateRecordID() async {
    // get number of records in a hospital
    final document = await getCurrentPatients(hospitalID, bearerToken);

    int numberOfRecords = document.length + 1;

    // add leading zeros if necessary to make sure it's 5 digits
    final paddedCount = numberOfRecords.toString().padLeft(5, '0');
    var recordID = '$hospitalID-$paddedCount';

    return recordID;
  }

  Future<void> _insertData(Map<String, dynamic> formValues) async {
    var createHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    final recordDesc = await generateRecordID();
    final encryptedRecordID = encryp(recordDesc);

    Map<String, dynamic> prehospital = {
      "externalCauses": formValues["externalCauseOfInjury"] != null
          ? encryptList(formValues["externalCauseOfInjury"])
          : null,
      "editHistory": [],
      "injuryTimestamp": formValues["dateTimeInjury"].toString(),
      "createHistory": createHistory,
      "chiefComplaint": formValues["chiefComplaint"] != null
          ? encryp(formValues["chiefComplaint"])
          : null,
      "firstAid": {
        "firstAider": formValues["firstAider"], //
        "isGiven": formValues["firstAidGiven"] != null
            ? encryp(formValues["firstAidGiven"])
            : null,
        "isStandard": formValues["firstAidGivenProperly"] != null
            ? encryp(formValues["firstAidGivenProperly"])
            : null,
        "methodGiven": formValues["methodGiven"] != null
            ? encryp(formValues["methodGiven"])
            : null,
      },
      "injuryIntent": formValues["injuryType"] != null
          ? encryp(formValues["injuryType"])
          : null,
      "placeOfInjury": {
        "region": regionDesc != "" ? encryp(regionDesc) : null,
        "province": provincesDesc != "" ? encryp(provincesDesc) : null,
        "cityMun": citiesDesc != "" ? encryp(citiesDesc) : null
      },
      "massInjury": formValues["massInjury"] != null
          ? encryp(formValues["massInjury"])
          : null,
      "medicolegal": {
        "isMedicolegal": formValues["medicolegalCase"] != null
            ? encryp(formValues["medicolegalCase"])
            : null,
        "medicolegalCategory": formValues["medicolegalCategory"] != null
            ? encryp(formValues["medicolegalCategory"])
            : null
      },
      "natureOfInjury": formValues["naturesOfInjury"] != null
          ? encryptList(formValues["naturesOfInjury"])
          : null,
      "natureOfInjuryExtraInfo": formValues["natureOfInjuryExtraInfo"] != null
          ? encryp(formValues["natureOfInjuryExtraInfo"])
          : null, // Added (only String)
      "vehicularAccident": {
        "preInjuryActivity":
            formValues["activityDuringAccident"] != null //CHange to list
                ? encryptList(formValues["activityDuringAccident"])
                : null,
        "collision": formValues["collisionOrNonCollision"] != null
            ? encryp(formValues["collisionOrNonCollision"])
            : null,
        "safetyIssues": formValues["safetyIssues"] != null
            ? encryptList(formValues["safetyIssues"])
            : null,
        "otherRisksFactors": formValues["otherRisksFactors"] != null //list
            ? encryptList(formValues["otherRisksFactors"])
            : null,
        "type": formValues["typeVehicularAccident"] != null
            ? encryp(formValues["typeVehicularAccident"])
            : null,
        "placeOfOccurrence": formValues["placeOfOccurrence"] != null
            ? encryp(formValues["placeOfOccurrence"])
            : null,
        "position": formValues["positionOfPatient"] != null
            ? encryp(formValues["positionOfPatient"])
            : null,
        "isVehicular": formValues["vehicularAccidentBool"] != null
            ? encryp(formValues["vehicularAccidentBool"])
            : null,
        "vehiclesInvolved": {
          "otherVehicle": formValues["otherVehicle"] != null
              ? encryp(formValues["otherVehicle"])
              : null,
          "patientVehicle": formValues["patientVehicle"] != null
              ? encryp(formValues["patientVehicle"])
              : null,
        }
      },
    };

    Map<String, dynamic> newRecord = {
      "hospitalID": hospitalID,
      "patientID": encryp(patient['patientID']),
      "patientStatus": encryp("Emergency Room"),
      "patientType": encryp(widget.patientType),
      "recordID": encryptedRecordID,
      "general": patient['general'],
      "preHospital": prehospital,
      "er": {},
      "surgery": {},
      "inHospital": {},
      "discharge": {},
    };

    await addNewRecord(newRecord, globals.bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

  @override
  void initState() {
    super.initState();
    patient = widget.patient;
    patientType = widget.patientType;
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
          isSending
              ? const SendingWidget()
              : isSentSuccessfully
                  ? SuccessfulWidget(
                      message: "Successful!",
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const MainNavigation(),
                          ),
                        );
                      },
                    )
                  : Expanded(
                      child: Scaffold(
                        // appBar: AppBar(
                        //   centerTitle: true,
                        //   title: const Text(
                        //     "Adding PreHospital Data",
                        //     style: TextStyle(
                        //         color: Colors.cyan,
                        //         fontWeight: FontWeight.bold),
                        //     textAlign: TextAlign.start,
                        //   ),
                        // ),
                        // persistentFooterButtons: [
                        //   FormBottomButton(
                        //     formKey: _formKey,
                        //     onSubmitPressed: () async {
                        //       _formKey.currentState!.save();
                        //       if (_formKey.currentState!.validate()) {
                        //         // _showConfirmationDialog();
                        //         var result = await Navigator.push(
                        //             context,
                        //             MaterialPageRoute(
                        //               builder: (BuildContext context) =>
                        //                   const PinCodeScreen(),
                        //               fullscreenDialog: true,
                        //             ));

                        //         if (result == true) {
                        //           setState(() {
                        //             isSending = true;
                        //           });

                        //           // Simulate sending data with a delay of 2 seconds
                        //           // Navigator.of(context).pop();
                        //           await _insertData(
                        //               _formKey.currentState!.value);
                        //         }
                        //       } else {
                        //         ScaffoldMessenger.of(context).showSnackBar(
                        //           const SnackBar(
                        //             content: Text("Fill all required fields"),
                        //             duration: Duration(seconds: 5),
                        //           ),
                        //         );
                        //       }
                        //     },
                        //   ),
                        // ],
                        body: FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                        injuryDetails(),
                                        firstAidDetails(),
                                        chiefComplaint(),
                                        massInjuryTF(),
                                        natureOfInjuryDetails(),
                                        vehicularDetails(),
                                        activityDetails(),
                                        medicolegalDetails(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
