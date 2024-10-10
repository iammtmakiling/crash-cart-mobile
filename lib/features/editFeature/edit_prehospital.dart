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
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../initializedList.dart';
import '../../widgets/formWidgets/formWidgets.dart';
import '../../globals.dart' as globals;

import 'dart:convert';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';

var uuid = const Uuid();
DateTime current = DateTime.now();

// ignore: camel_case_types
class editPreHospital extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;
  final Map<String, dynamic> preHospitalData;
  final Map<String, dynamic> record;

  const editPreHospital(
      {super.key,
      required this.preHospitalData,
      required this.patientData,
      required this.onBack,
      required this.record,
      required this.fullRecord});

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
      home: EditPreHospital(
          patientData: patientData,
          preHospitalData: preHospitalData,
          record: record,
          onBack: onBack,
          fullRecord: fullRecord),
    );
  }
}

// ignore: camel_case_types
class EditPreHospital extends StatefulWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> fullRecord;
  final Map<String, dynamic> preHospitalData;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> record;
  const EditPreHospital(
      {super.key,
      required this.preHospitalData,
      required this.record,
      required this.patientData,
      required this.fullRecord,
      required this.onBack});

  @override
  // ignore: library_private_types_in_public_api
  EditPreHospitalState createState() => EditPreHospitalState();
}

// ignore: camel_case_types
class EditPreHospitalState extends State<EditPreHospital>
    with SingleTickerProviderStateMixin {
  // Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Address
  String address = "";

  // Full Record
  late Map<String, dynamic> record;
  List<dynamic> externalCauses = [];
  List<dynamic> naturesOfInjuryList = [];
  List<String> errorFields = [];

  // General Data
  String POIRegionId = "";
  String POIProvincesId = "";
  String POICitiesId = "";
  String POIRegionDesc = "";
  String POIProvincesDesc = "";
  String POICitiesDesc = "";

  // Pre-Hospital Data
  late Map<String, dynamic> preHospitalData;
  late Map<String, dynamic> vehicularAccident;
  List<dynamic> regions = [];
  List<dynamic> provincesMaster = [];
  List<dynamic> provinces = [];
  List<dynamic> citiesMaster = [];
  List<dynamic> cities = [];

  // Visibility
  bool visibleFirstAidGiven = false;
  bool visibleVehicularAccident = false;
  bool visibleMedicolegal = false;
  bool visibleColision = false;

  // Screens
  bool isSending = false;
  bool isSentSuccessfully = false;
  bool isLoading = true;

  late TabController _tabController;

  Future<void> readJsonRegions() async {
    final String response =
        await rootBundle.loadString('assets/json/refregion.json');
    final data = await json.decode(response);
    setState(() {
      regions = data["RECORDS"];
      for (var region in regions) {
        if (region["regDesc"].toString() == POIRegionId) {
          POIRegionId = region["regCode"].toString();
          break;
        }
      }
    });
  }

  Future<void> readJsonProvinces() async {
    final String response =
        await rootBundle.loadString('assets/json/refprovince.json');
    final data = await json.decode(response);
    setState(() {
      provincesMaster = data["RECORDS"];
      for (var province in provincesMaster) {
        if (province["provDesc"].toString() == POIProvincesId) {
          POIProvincesId = province["provCode"].toString();
          break;
        }
      }
    });
  }

  Future<void> readJsonCities() async {
    final String response =
        await rootBundle.loadString('assets/json/refcitymun.json');
    final data = await json.decode(response);
    setState(() {
      citiesMaster = data["RECORDS"];
      for (var city in citiesMaster) {
        if (city["citymunDesc"].toString() == POICitiesId) {
          POICitiesId = city["citymunCode"].toString();
          break;
        }
      }
    });
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
    //Variables
    Map<String, dynamic> newEditHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    List editHistory = [];
    addToHistory(editHistory, newEditHistory);

    Map<String, dynamic> prehospital = {
      "externalCauses": encryptList(externalCauses),
      "editHistory": editHistory,
      "injuryTimestamp": formValues["dateTimeInjury"].toString(),
      "createHistory": record['preHospital']['createHistory'],
      "chiefComplaint": nullChecker(formValues["chiefComplaint"]),
      "firstAid": {
        "firstAider": formValues["firstAider"],
        "isGiven": nullChecker(formValues["firstAidGiven"]),
        "isStandard": nullChecker(formValues["firstAidGivenProperly"]),
        "methodGiven": nullChecker(formValues["methodGiven"]),
      },
      "injuryIntent": nullChecker(formValues["injuryType"]),
      "placeOfInjury": {
        "region": POIRegionId.isNotEmpty ? nullChecker(POIRegionDesc) : null,
        "province":
            POIProvincesId.isNotEmpty ? nullChecker(POIProvincesDesc) : null,
        "cityMun": POICitiesId.isNotEmpty ? nullChecker(POICitiesDesc) : null
      },
      "massInjury": nullChecker(formValues["massInjury"]),
      "medicolegal": {
        "isMedicolegal": nullChecker(formValues["medicolegalCase"]),
        "medicolegalCategory": nullChecker(formValues["medicolegalCategory"])
      },
      "natureOfInjury": encryptList(naturesOfInjuryList),
      "natureOfInjuryExtraInfo":
          nullChecker(formValues["natureOfInjuryExtraInfo"]),
      "vehicularAccident": {
        "preInjuryActivity": encryptList(formValues["activityDuringAccident"]),
        "collision": nullChecker(formValues["collisionOrNonCollision"]),
        "safetyIssues": encryptList(formValues["safetyIssues"]),
        "otherRisksFactors": encryptList(formValues["otherRisksFactors"]),
        "type": nullChecker(formValues["typeVehicularAccident"]),
        "placeOfOccurrence": nullChecker(formValues["placeOfOccurrence"]),
        "position": nullChecker(formValues["positionOfPatient"]),
        "isVehicular": nullChecker(formValues["vehicularAccidentBool"]),
        "vehiclesInvolved": {
          "otherVehicle": nullChecker(formValues["otherVehicle"]),
          "patientVehicle": nullChecker(formValues["patientVehicle"]),
        }
      },
    };

    record['patientType'] = encryp(formValues["patientType"]);
    record['preHospital'] = prehospital;

    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));

    await updateRecord(encodedpatientID, record, bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

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
              initialValue: DateTime.parse(
                (preHospitalData['injuryTimestamp'] == "")
                    ? null
                    : preHospitalData['injuryTimestamp'],
              ),
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
                labelText: "",
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
          FormTextField(
              initialValue: preHospitalData['firstAid']["firstAider"],
              name: "firstAider",
              labelName: ""),
          const SizedBox(height: 16),
          const Text(
            "Is first aid given properly?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            initialValue: preHospitalData['firstAid']["isStandard"],
            name: "firstAidGivenProperly",
            values: yesNoList,
            texts: yesNoList,
          ),
          const SizedBox(height: 16),
          const Text(
            "Method given:",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormTextField(
            initialValue: preHospitalData['firstAid']["methodGiven"],
            name: "methodGiven",
            labelName: "",
          ),
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
            initialValue: vehicularAccident['type'],
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
            initialValue: vehicularAccident["collision"],
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
            initialValue: vehicularAccident['vehiclesInvolved']
                ["patientVehicle"],
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
              initialValue: vehicularAccident['vehiclesInvolved']
                  ["otherVehicle"],
              name: 'otherVehicle',
              values: ['(none) Pedestrian', ...vehiclesList],
              texts: ['(none) Pedestrian', ...vehiclesList],
            ),
          const SizedBox(height: 8),
          const Text(
            "Position of Patient?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            name: 'positionOfPatient',
            initialValue: vehicularAccident["position"],
            values: positionOfPatientList,
            texts: positionOfPatientList,
          ),
          const SizedBox(height: 8),
          const Text(
            "Place of Occurence?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormTextField(
              name: 'placeOfOccurrence',
              initialValue: vehicularAccident["placeOfOccurrence"] ?? 'Unknown',
              labelName: ''),
          const SizedBox(height: 16),
          const Text(
            "Activity During Injury?",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormCheckbox(
            name: 'activityDuringAccident',
            initialValue: vehicularAccident["preInjuryActivity"],
            options: const ['Sports', 'Leisure', 'Work-related', 'Unknown'],
          ),
          const SizedBox(height: 16),
          const Text(
            "Other risk factors at the time of the incident:",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormCheckbox(
              initialValue: vehicularAccident['otherRisksFactors'],
              name: "otherRisksFactors",
              options: otherRisksFactors),
          const SizedBox(height: 16),
          const Text(
            "Safety Issues? (Select all that apply)",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormCheckbox(
            initialValue: vehicularAccident['safetyIssues'],
            name: 'safetyIssues',
            options: safetyIssues,
          )
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
          FormTextField(
            initialValue: preHospitalData['medicolegal']["medicolegalCategory"],
            name: "medicolegalCategory",
            labelName: "",
          ),
          // FormRadio(
          //   enabled: true,
          //   // initialValue: preHospitalData['medicolegal']["medicolegalCategory"],
          //   name: "medicolegalCategory",
          //   values: medicolegalList,
          //   texts: medicolegalList,
          // ),
        ],
      ),
    );
  }

  Padding patientType() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Type of Patient",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          FormRadio(
            name: 'patientType',
            initialValue: decryp(record['patientType']),
            enabled: true,
            values: const ['ER', 'OPD', 'In-Patient', 'BHS', 'RHU'],
            texts: const ['ER', 'OPD', 'In-Patient', 'BHS', 'RHU'],
            validator: FormBuilderValidators.required(),
          ),
        ],
      ),
    );
  }

  Padding injuryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Place of Injury",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormAddress(
            enabled: true,
            regionId: POIRegionId,
            provincesId: POIProvincesId,
            citiesId: POICitiesId,
            onRegionIDChanged: (String? newValue) {
              setState(() {
                POIRegionId = newValue!;
              });
            },
            onProvincesIDChanged: (String? newValue) {
              setState(() {
                POIProvincesId = newValue!;
              });
            },
            onCitiesIDChanged: (String? newValue) {
              setState(() {
                POICitiesId = newValue!;
              });
            },
            onRegionDescChanged: (String? newValue) {
              setState(() {
                POIRegionDesc = newValue!;
              });
            },
            onProvincesDescChanged: (String? newValue) {
              setState(() {
                POIProvincesDesc = newValue!;
              });
            },
            onCitiesDescChanged: (String? newValue) {
              setState(() {
                POICitiesDesc = newValue!;
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
              initialValue: preHospitalData["injuryIntent"],
              name: 'injuryType',
              values: injuryTypeList,
              texts: injuryTypeList),
        ],
      ),
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
          initialValue: preHospitalData["firstAid"]['isGiven'],
          onChanged: (valueFirstAidGiven) {
            if (valueFirstAidGiven == "yes") {
              setState(() {
                visibleFirstAidGiven = true;
              });
            } else {
              setState(() {
                visibleFirstAidGiven = false;
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
          MultiSelectBottomSheetField(
            initialValue: preHospitalData["natureOfInjury"] ?? [],
            chipDisplay: MultiSelectChipDisplay(
              height: 50,
              scroll: true,
            ),
            listType: MultiSelectListType.LIST,
            title: const Text("Add"),
            searchable: true,
            searchIcon: const Icon(Icons.search),
            items: naturesOfInjury.map((e) => MultiSelectItem(e, e)).toList(),
            onConfirm: (selectedItems) {
              setState(
                () {
                  naturesOfInjuryList = selectedItems;
                },
              );
            },
          ),
          // FormCheckbox(
          //     initialValue: preHospitalData["natureOfInjury"],
          //     name: "naturesOfInjury",
          //     options: naturesOfInjury),
          const SizedBox(height: 12),
          FormTextArea(
            initialValue: preHospitalData["natureOfInjuryExtraInfo"],
            name: "natureOfInjuryExtraInfo",
            labelName: "Additional Details",
          ),
          // ),
          // FormTextField(
          //     initialValue: preHospitalData["natureOfInjuryExtraInfo"],
          //     name: "natureOfInjuryExtraInfo",
          //     labelName: "Additional Details"),
          const SizedBox(height: 16),
          const Text(
            "External Cause of Injury",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          MultiSelectBottomSheetField(
            chipDisplay: MultiSelectChipDisplay(
              height: 50,
              scroll: true,
            ),
            listType: MultiSelectListType.LIST,
            initialValue: preHospitalData['externalCauses'],
            searchable: true,
            title: const Text("Add"),
            searchIcon: const Icon(Icons.search),
            items:
                externalCausesInjury.map((e) => MultiSelectItem(e, e)).toList(),
            onConfirm: (selectedItems) {
              setState(
                () {
                  externalCauses = selectedItems;
                },
              );
            },
          ),
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
              initialValue: vehicularAccident['isVehicular'],
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
                // elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white,
                child: condVehicularAccident(),
              ),
            ),
          ]),
    );
  }

  // Padding activityDetails() {
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const SizedBox(height: 16),

  //       ],
  //     ),
  //   );
  // }

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
          initialValue: preHospitalData['medicolegal']['isMedicolegal'],
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
            // elevation: 5,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Chief Complaint",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          FormTextField(
            initialValue: preHospitalData['chiefComplaint'] ?? "Unknown",
            name: 'chiefComplaint',
            labelName: '',
          ),
        ],
      ),
    );
  }

  Padding massInjuryTF() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mass Injury",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormRadio(
            enabled: true,
            initialValue: preHospitalData['massInjury'],
            name: 'massInjury',
            values: const ['yes', 'no'],
            texts: const ['Yes', 'No'],
          ),
        ],
      ),
    );
  }

  Future<void> _showMissingDialog() async {
    var widthScreen = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please fill the missing details.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  // you may want to use an aspect ratio here for tablet support
                  height: 200.0,
                  width: widthScreen * 90,
                  child: ListView.builder(
                    // store this controller in a State to save the carousel scroll position
                    // controller: PageController(viewportFraction: 0.9),
                    itemCount: errorFields.length,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    itemBuilder: (context, index) {
                      return Text(
                        errorFields[index],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ],
            ),
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
                      errorFields = [];
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.cyan),
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

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: const Text(
            'Are you sure you want to change the PreHospital Data?',
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
    initializeData();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {
    preHospitalData = widget.preHospitalData;
    record = widget.record;

    if (preHospitalData['externalCauses'].isNotEmpty) {
      externalCauses = preHospitalData['externalCauses'];
    }
    if (preHospitalData['natureOfInjury'].isNotEmpty) {
      naturesOfInjuryList = preHospitalData['natureOfInjury'];
    }
    POIRegionId = preHospitalData['placeOfInjury']['region'] ?? "";
    POIProvincesId = preHospitalData['placeOfInjury']['province'] ?? "";
    POICitiesId = preHospitalData['placeOfInjury']['cityMun'] ?? "";

    visibleFirstAidGiven = preHospitalData['firstAid']['isGiven'] == "yes";
    vehicularAccident = preHospitalData['vehicularAccident'];
    visibleVehicularAccident = vehicularAccident['isVehicular'] == "yes";
    visibleColision = vehicularAccident['collision'] == "Collision";
    visibleMedicolegal =
        preHospitalData['medicolegal']['isMedicolegal'] == "yes";

    // Initialize async tasks
    List<Future> asyncTasks = [
      readJsonRegions(),
      readJsonProvinces(),
      readJsonCities(),
    ];

    // Wait for all async tasks to complete
    await Future.wait(asyncTasks);

    // Once all async tasks are completed, set isLoading to false
    setState(() {
      isLoading = false;
    });
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
            var value = _formKey.currentState!.value;

            if (value['patientType'] == null) {
              errorFields.add('patient type');
            }

            if (externalCauses.isEmpty) {
              errorFields.add('external causes');
            }

            if (naturesOfInjuryList.isEmpty) {
              errorFields.add('natures of injury');
            }

            if (POIRegionId == "" &&
                POIProvincesId == "" &&
                POICitiesId == "") {
              errorFields.add('place of injury');
            }

            if (value['medicolegalCase'] == null) {
              errorFields.add('Is Medicolegal');
            }

            if (value['vehicularAccidentBool'] == "yes") {
              if (value['collisionOrNonCollision'] == null) {
                errorFields.add('collision');
              }

              if (value['typeVehicularAccident'] == null) {
                errorFields.add('Vehicular Accident Type');
              }

              if (value['placeOfOccurrence'] == null) {
                errorFields.add('Vehicular Place of Occurence');
              }

              if (value['positionOfPatient'] == null) {
                errorFields.add('Vehicular Patient Position');
              }

              if (value['activityDuringAccident'] == null) {
                errorFields.add('Vehicular Patient PreInjury Activity');
              }
            }

            if (errorFields.isEmpty) {
              _showConfirmationDialog();
            } else {
              _showMissingDialog();
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
            //       body: Scaffold(
            // persistentFooterButtons: [buttonNav(context)],
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
                          patientType(),
                          injuryDetails(),
                          firstAidDetails(),
                          chiefComplaint(),
                          massInjuryTF(),
                          natureOfInjuryDetails(),
                          vehicularDetails(),
                          // activityDetails(),
                          medicolegalDetails(),
                        ],
                      ),
                    ),
                  ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ),
            // ),
          ),
        ],
      ),
    );
  }
}
