// // import 'package:dashboard/api_requests/updatePatient.dart';
// import 'package:dashboard/firestoreDb/firestore.dart';
// import 'package:dashboard/firestoreDb/firestore_model.dart';
// import 'package:dashboard/screens/screens.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:intl/intl.dart';
// import 'package:multi_select_flutter/multi_select_flutter.dart';
// import 'package:uuid/uuid.dart';

// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
// import 'globals.dart' as globals;

// // dependent dropdowns
// import 'package:snippet_coder_utils/FormHelper.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// // import 'api_requests/updatePatient.dart';

// var uuid = const Uuid();
// DateTime current = DateTime.now();

// // ignore: camel_case_types
// class editRecord extends StatelessWidget {
//   const editRecord({Key? key, required this.patientDetails}) : super(key: key);

//   final List<Map<String, dynamic>> patientDetails;

//   @override
//   Widget build(BuildContext context) {
//     initializeDateFormatting('az');
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       supportedLocales: const [
//         Locale('de'),
//         Locale('en'),
//         Locale('es'),
//         Locale('fr'),
//         Locale('it'),
//       ],
//       localizationsDelegates: const [
//         FormBuilderLocalizations.delegate,
//       ],
//       title: 'Edit Patient Details',
//       theme: ThemeData(
//           primarySwatch: Colors.purple,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           backgroundColor: Colors.grey[300]),
//       home: editRecordWidget(patient: patientDetails),
//     );
//   }
// }

// // ignore: camel_case_types
// class editRecordWidget extends StatefulWidget {
//   const editRecordWidget({Key? key, required this.patient}) : super(key: key);

//   final List<Map<String, dynamic>> patient;

//   @override
//   _editRecordWidgetState createState() => _editRecordWidgetState();
// }

// // ignore: camel_case_types
// class _editRecordWidgetState extends State<editRecordWidget>
//     with SingleTickerProviderStateMixin {
//   String address = "";
//   final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

//   // "Global" details
//   late int patientDetailsIndex;

//   //Pre-Hospital Data
//   List<dynamic> regions = [];

//   List<dynamic> provincesMaster = [];
//   List<dynamic> provinces = [];

//   List<dynamic> citiesMaster = [];
//   List<dynamic> cities = [];

//   String? regionId;
//   String? provincesId;
//   String? citiesId;
//   bool visibleFirstAidGiven = false;
//   bool visibleVehicularAccident = false;
//   bool visibleMedicolegal = false;

//   //ER Data
//   bool visibleTransferDetails = false;
//   bool visiblePatientArrivalStatus = false;
//   bool visibleOutrightSurgery = false;

//   late TabController _controller;
//   int _selectedIndex = 0;

//   //Surgery Data

//   List<dynamic> RVSCodes = [];
//   List<String> RVSList = [];
//   List<Widget> surgeryCardList = [];
//   late int initialSurgeriesNumber; // needed for patientStream

//   //In-Hospital Data
//   List<Widget> inreferralsList = [];
//   List<dynamic> comorbidities = [];
//   List<dynamic> complications = [];

//   // Discharge Data
//   List<dynamic> ICDCodes = [];
//   List<String> ICDCodesArray = [];
//   List dischargeDispositionArray = [
//     'Treated and sent home',
//     'No intervention and sent home',
//     'HAMA/Refused Admission',
//     'Absconded',
//     'Died',
//     'Transferred'
//   ];

//   //start of arrays to transfer to centralized data file
//   List naturesOfInjury = [
//     'Blunt Trauma',
//     'Abrasion',
//     'Avulsion',
//     'Contusion',
//     'Burn',
//     'Fracture',
//     'Munition',
//     'Amputation',
//     'Others'
//   ];
//   List externalCausesInjury = [
//     'Bites',
//     'Strangulation',
//     'Fall',
//     'Drowning',
//     'Firecrackers',
//     'Mauling',
//     'Assault'
//   ];
//   List safetyIssues = [
//     'Sleepy',
//     'Alcohol',
//     'Drugs',
//     'Smoking',
//     'Seatbelt',
//     'Airbag',
//     'Helmet',
//     'Life Jacket'
//   ];
//   List modeOfTranspo = [
//     'Private Vehicle',
//     'Police Vehicle',
//     'Ambulance',
//     'Public Transportation',
//     'Others'
//   ];
//   List cavitiesForSurgery = [
//     'Head',
//     'Neck',
//     'Chest',
//     'Abdomen',
//     'Extremity',
//     'Superficial'
//   ];
//   List servicesOnboard = [
//     'General Surgery',
//     'Ortho',
//     'OB',
//     'Neurosurgery',
//     'Plastics',
//     'TCVS',
//     'Optha',
//     'ENT'
//   ];
//   List disposition = [
//     'Admit (Surgery)',
//     'Admit (In-Hospital)',
//     'Treated and for Discharge',
//     'No intervention and for Discharge',
//     'HAMA/Refused Admission',
//     'Absconded',
//     'Died',
//     'Transferred'
//   ];
//   //end of arrays to transfer to centralized data file

//   // functions executed before runtime

//   int recentPatientDetailsIndex() {
//     var index = (widget.patient[0]['patientHistory'].length) - 1;
//     return index;
//   }

//   String returnICDDiagnosis(String icdCode) {
//     String diagnosis = " ";

//     for (var element in ICDCodes) {
//       if (element["code"] == icdCode) {
//         diagnosis = element["desc"];
//         break;
//       }
//     }

//     return diagnosis;
//   }

//   Future<void> readJsonRegions() async {
//     final String response =
//         await rootBundle.loadString('assets/json/refregion.json');
//     final data = await json.decode(response);
//     setState(() {
//       regions = data["RECORDS"];
//       regionId = widget.patient[0]["patientHistory"][patientDetailsIndex]
//           ["preHospital"]["placeOfInjury"]["region"];
//     });
//     //print(data);
//   }

//   Future<void> readJsonProvinces() async {
//     final String response =
//         await rootBundle.loadString('assets/json/refprovince.json');
//     final data = await json.decode(response);
//     setState(() {
//       provincesMaster = data["RECORDS"];
//       provinces = provincesMaster
//           .where(
//             (provincesItem) =>
//                 provincesItem["regionCode"].toString() ==
//                 widget.patient[0]["patientHistory"][patientDetailsIndex]
//                         ["preHospital"]["placeOfInjury"]["region"]
//                     .toString(),
//           )
//           .toList();

//       provincesId = widget.patient[0]["patientHistory"][patientDetailsIndex]
//           ["preHospital"]["placeOfInjury"]["province"];
//     });
//     //print(data);
//   }

//   Future<void> readJsonCities() async {
//     final String response =
//         await rootBundle.loadString('assets/json/refcitymun.json');
//     final data = await json.decode(response);
//     setState(() {
//       citiesMaster = data["RECORDS"];
//       cities = citiesMaster
//           .where(
//             (citiesItem) =>
//                 citiesItem["provCode"].toString() ==
//                 widget.patient[0]["patientHistory"][patientDetailsIndex]
//                         ["preHospital"]["placeOfInjury"]["province"]
//                     .toString(),
//           )
//           .toList();

//       citiesId = widget.patient[0]["patientHistory"][patientDetailsIndex]
//           ["preHospital"]["placeOfInjury"]["cityMun"];
//     });
//     //print(data);
//   }

//   Future<void> readJsonCPT4Codes() async {
//     final String response =
//         await rootBundle.loadString('assets/json/cpt4.json');
//     final data = await json.decode(response);
//     setState(() {
//       RVSCodes = data["CODES"];
//       RVSList = RVSCodes.map(
//               (RVSItem) => RVSItem["FIELD1"] + ": " + RVSItem["FIELD2"])
//           .toList()
//           .cast<String>();
//     });
//     // print(RVSList);
//   }

//   Future<void> readJsonICDCodes() async {
//     final String response =
//         await rootBundle.loadString('assets/json/icd10_codes.json');
//     final data = await json.decode(response);
//     setState(() {
//       ICDCodes = data["CODES"];
//       ICDCodesArray =
//           ICDCodes.map((icdItem) => (icdItem["code"] + ": " + icdItem["desc"]))
//               .cast<String>()
//               .toList();
//     });
//     // print(data);
//   }

//   void setDependentDropDownAddress() {
//     setState(() {
//       regionId = widget.patient[0]["patientHistory"][patientDetailsIndex]
//           ["preHospital"]["placeOfInjury"]["region"];
//       provincesId = widget.patient[0]["patientHistory"][patientDetailsIndex]
//           ["preHospital"]["placeOfInjury"]["province"];
//       citiesId = widget.patient[0]["patientHistory"][patientDetailsIndex]
//           ["preHospital"]["placeOfInjury"]["cityMun"];
//     });
//   }

//   // calculation functions

//   calculateAge(DateTime birthDate) {
//     DateTime currentDate = DateTime.now();
//     int age = currentDate.year - birthDate.year;
//     int month1 = currentDate.month;
//     int month2 = birthDate.month;
//     if (month2 > month1) {
//       age--;
//     } else if (month1 == month2) {
//       int day1 = currentDate.day;
//       int day2 = birthDate.day;
//       if (day2 > day1) {
//         age--;
//       }
//     }
//     return age;
//   }

//   int getSurgeriesNumber() {
//     return surgeryCardList.length;
//   }

//   String decidePhase(String department, Map<String, dynamic> formValues) {
//     // ignore: prefer_typing_uninitialized_variables
//     var returnValue;

//     if (department == "Surgery Staff") {
//       returnValue =
//           formValues["nextPhase" + (surgeryCardList.length).toString()];
//     } else if (department == "Discharge Staff") {
//       returnValue = formValues["dispositionDischarge"];
//     } else if (department == "In-Hospital Staff") {
//       returnValue = formValues["nextPhaseInHospital"];
//     }

//     return returnValue;
//   }

//   // layout modules

//   Divider twoPix() {
//     return const Divider(
//       thickness: 2,
//     );
//   }

//   String _generateID() {
//     return uuid.v4();
//   }

//   Padding patientName() {
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         FractionallySizedBox(
//                           widthFactor: 0.95,
//                           child: FormBuilderTextField(
//                             initialValue: widget.patient[0]["general"]
//                                 ["lastName"],
//                             name: "lastName",
//                             autocorrect: false,
//                             decoration: const InputDecoration(
//                               labelText: 'Last Name',
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         FractionallySizedBox(
//                           widthFactor: 0.95,
//                           child: FormBuilderTextField(
//                             initialValue: widget.patient[0]["general"]
//                                 ["firstName"],
//                             name: "firstName",
//                             autocorrect: false,
//                             decoration: const InputDecoration(
//                               labelText: 'First Name',
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       children: [
//                         FractionallySizedBox(
//                           widthFactor: 0.95,
//                           child: FormBuilderTextField(
//                             initialValue: widget.patient[0]["general"]
//                                 ["middleName"],
//                             name: "middleName",
//                             autocorrect: false,
//                             decoration: const InputDecoration(
//                               labelText: 'Middle Name',
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: Column(
//                       children: [
//                         FractionallySizedBox(
//                           widthFactor: 0.95,
//                           child: FormBuilderTextField(
//                             initialValue: widget.patient[0]["general"]
//                                 ["suffix"],
//                             name: "suffix",
//                             autocorrect: false,
//                             decoration: const InputDecoration(
//                               labelText: 'Suffix',
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ));
//   }

//   Padding patientType() {
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderRadioGroup(
//               name: "patientType",
//               initialValue: widget.patient[0]["general"]["patientType"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Type of Patient",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'ER', child: Text('ER')),
//                 FormBuilderFieldOption(value: 'OPD', child: Text('OPD')),
//                 FormBuilderFieldOption(
//                     value: 'In-Patient', child: Text('In-Patient')),
//                 FormBuilderFieldOption(value: 'BHS', child: Text('BHS')),
//                 FormBuilderFieldOption(value: 'RHU', child: Text('RHU')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding genderPick() {
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderRadioGroup(
//               name: "gender",
//               initialValue: widget.patient[0]["general"]["gender"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Gender",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'Male', child: Text('Male')),
//                 FormBuilderFieldOption(value: 'Female', child: Text('Female')),
//                 FormBuilderFieldOption(
//                     value: 'Nonbinary', child: Text('Nonbinary')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding bdayAge() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FractionallySizedBox(
//                     widthFactor: 0.95,
//                     child: FormBuilderDateTimePicker(
//                       initialValue: DateTime.parse(
//                           widget.patient[0]["general"]["birthday"]),
//                       inputType: InputType.date,
//                       name: 'birthday',
//                       firstDate: DateTime(1900),
//                       lastDate: DateTime(DateTime.now().year,
//                           DateTime.now().month, DateTime.now().day),
//                       format: DateFormat('yyyy-MM-dd'),
//                       onChanged: (DateTime? value) {
//                         debugPrint(value.toString());
//                         // ignore: prefer_typing_uninitialized_variables
//                         var patientAge;
//                         setState(() {
//                           // ignore: unnecessary_null_comparison
//                           if (value == null) {
//                           } else {
//                             patientAge = calculateAge(value);
//                             _formKey.currentState!.fields['age']!
//                                 .didChange(patientAge.toString());
//                           }
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         labelText: 'Birthday',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   FractionallySizedBox(
//                     widthFactor: 0.95,
//                     child: FormBuilderTextField(
//                       enabled: false,
//                       initialValue:
//                           widget.patient[0]["general"]["age"].toString(),
//                       name: 'age',
//                       decoration: const InputDecoration(
//                         labelText: 'Age',
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Padding presentPermanentAddress() {
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
//         child: Column(
//           children: [
//             FractionallySizedBox(
//               widthFactor: 0.95,
//               child: FormBuilderTextField(
//                 initialValue: widget.patient[0]["general"]["presentAddress"],
//                 name: "presentAddress",
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   labelText: 'Present Address',
//                 ),
//               ),
//             ),
//             FractionallySizedBox(
//               widthFactor: 0.95,
//               child: FormBuilderTextField(
//                 initialValue: widget.patient[0]["general"]["permanentAddress"],
//                 name: "permanentAddress",
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   labelText: 'Permanent Address',
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }

//   Padding philhealthID() {
//     // need validators for ID format
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
//         child: Column(
//           children: [
//             FractionallySizedBox(
//               widthFactor: 0.95,
//               child: FormBuilderTextField(
//                 initialValue: widget.patient[0]["general"]["philhealthID"],
//                 name: "philhealthID",
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   labelText: 'Philhealth ID',
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }

//   Padding generateID() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: FormBuilderTextField(
//           name: 'centralRegistryID',
//           enabled: false,
//           initialValue: widget.patient[0]["centralRegistryID"],
//           textAlign: TextAlign.center,
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             errorBorder: InputBorder.none,
//             disabledBorder: InputBorder.none,
//             labelText: 'Centralized Registry Number',
//             labelStyle: TextStyle(fontSize: 18),
//           ),
//         ));
//   }

//   Padding dateCreatedField() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: FormBuilderTextField(
//           name: 'dateCreated',
//           enabled: false,
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["dateCreated"],
//           textAlign: TextAlign.center,
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             errorBorder: InputBorder.none,
//             disabledBorder: InputBorder.none,
//             labelText: 'Date and Time of Record Creation',
//             labelStyle: TextStyle(fontSize: 18),
//           ),
//         ));
//   }

//   String getHospitalID(String registryID) {
//     return [registryID.split("-")[0], registryID.split("-")[1]].join("-");
//   }

//   Future<void> _editData(Map<String, dynamic> formValues, String? regionId,
//       String? provincesId, String? citiesId) async {
//     // insert code here
//     var id = widget.patient[0]["centralRegistryID"];
//     var currentPhase;

//     // var citymunCode = globals.hospitalID.split("-")[0];
//     // var hospitalID = globals.hospitalID.split("-")[1];
//     var citymunCode = "137415";
//     var hospitalID = "1256";
//     var dateCreated =
//         widget.patient[0]["patientHistory"][patientDetailsIndex]["dateCreated"];

//     var editHistory = {
//       "user_email": globals.username,
//       "deviceUsed": globals.deviceUsed,
//       "editTimestamp": DateTime(
//           DateTime.now().year, DateTime.now().month, DateTime.now().day)
//     };

//     Map<String, dynamic> general = {
//       "fullName": [
//         widget.patient[0]["general"]["firstName"],
//         widget.patient[0]["general"]["middleName"],
//         widget.patient[0]["general"]["lastName"]
//       ].join(" ").toLowerCase(),
//       "patientType": formValues["patientType"],
//       "birthday": formValues["birthday"].toString().split(" ")[0],
//       "age": formValues["age"],
//       "gender": formValues["gender"],
//       "presentAddress": formValues["presentAddress"],
//       "permanentAddress": formValues["permanentAddress"],
//       "philhealthID": formValues["philhealthID"],
//       "lastName": formValues["lastName"],
//       "firstName": formValues["firstName"],
//       "middleName": formValues["middleName"],
//       "suffix": formValues["suffix"],
//     };

//     Map<String, dynamic> prehospital = {
//       "chiefComplaint": formValues["chiefComplaint"],
//       "massInjury": formValues["massInjury"],
//       "placeOfInjury": {
//         "region": regionId,
//         "province": provincesId,
//         "cityMun": citiesId
//       },
//       "injuryTimestamp": formValues["dateTimeInjury"].toString(),
//       "injuryIntent": formValues["injuryType"],
//       "firstAid": {
//         "isGiven": formValues["firstAidGiven"],
//         "firstAider": formValues["firstAider"],
//         "isStandard": formValues["firstAidGivenProperly"]
//       },
//       "natureOfInjury": formValues["natureOfInjury"],
//       "externalCauses": formValues["externalCauseOfInjury"],
//       "vehicularAccident": {
//         "isVehicular": formValues["vehicularAccidentBool"],
//         "vehicleType": formValues["typeVehicularAccident"],
//         "collision": formValues["collisionOrNonCollision"],
//         "partiesInvolved": formValues["partiesInvolved"],
//         "position": formValues["positionOfPatient"],
//         "placeOfOccurence": formValues["placeOfOccurence"],
//       },
//       "preInjuryActivity": formValues["activityDuringAccident"],
//       "safetyIssues": formValues["safetyIssues"],
//       "medicolegal": {
//         "isMedicolegal": formValues["medicolegalCase"],
//         "medicolegalCategory": formValues["medicolegalCategory"]
//       },
//     };

//     Map<String, dynamic> er = {
//       "isTransferred": formValues["patientTransferred"],
//       "isCoordinated": formValues["coordinatedTransfer"],
//       "originatingInstitution": formValues["originatingInstitution"],
//       "previousInCharge": formValues["previousInCharge"],
//       "positionPreviousInCharge": formValues["positionPreviousInCharge"],
//       "statusOnArrival": formValues["statusOnArrival"],
//       "aliveCategory": formValues["aliveStatus"],
//       "transportation": formValues["modeOfTransport"],
//       "initialImpression": formValues["initialImpression"],
//       "isSurgical": formValues["outrightSurgical"],
//       "cavityInvolved": formValues["cavityForSurgery"],
//       "servicesOnboard": formValues["servicesOnboardSurgery"],
//       "dispositionER": formValues["patientDisposition"],
//       "outcome": formValues["outcome"]
//     };

//     var surgeriesListForEdit = [];

//     for (var index = 0; index < surgeryCardList.length; index++) {
//       Map<String, dynamic> surgeriesListElement = {
//         "placeOfSurgery": formValues["placeOfSurgery" + (index + 1).toString()],
//         "rvsCode": formValues["rvsCode" + (index + 1).toString()],
//         "cavityInvolved": formValues["cavityInvolved" + (index + 1).toString()],
//         "servicesPresent":
//             formValues["servicesPresent" + (index + 1).toString()],
//         "phaseBegun": formValues["phaseBegun" + (index + 1).toString()],
//         "startTimestamp":
//             formValues["startDateTime" + (index + 1).toString()].toString(),
//         "endTimestamp":
//             formValues["endDateTime" + (index + 1).toString()].toString(),
//         "surgeryType": formValues["surgeryType" + (index + 1).toString()],
//         "surgeon": formValues["surgeon" + (index + 1).toString()],
//         "hemorrhageControl": {
//           "hemorrhageType":
//               formValues["hemorrhageControlType" + (index + 1).toString()],
//           "hemorrhageTimestamp":
//               formValues["hemorrhageControlDateTime" + (index + 1).toString()]
//                   .toString()
//         },
//         "dispositionSurgery": formValues["nextPhase" + (index + 1).toString()],
//       };

//       surgeriesListForEdit.add(surgeriesListElement);
//     }

//     Map<String, dynamic> surgery = {
//       "surgeryBoolean": formValues["forSurgery"],
//       "surgeriesList": surgeriesListForEdit
//     };

//     var inreferralsListForEdit = [];

//     for (var index = 0; index < inreferralsList.length; index++) {
//       Map<String, dynamic> inreferralsElement = {
//         "service": formValues["consultationService" + (index + 1).toString()],
//         "physician":
//             formValues["consultationPhysician" + (index + 1).toString()],
//         "consultationTimestamp":
//             formValues["consultationDate" + (index + 1).toString()].toString()
//       };

//       inreferralsListForEdit.add(inreferralsElement);
//     }

//     Map<String, dynamic> inhospital = {
//       "capriniScore": formValues["capriniScore"],
//       "comorbidities": comorbidities
//           .map((e) => {"icdCode": e, "diagnosis": returnICDDiagnosis(e)})
//           .toList(),
//       "complications": complications
//           .map((e) => {"icdCode": e, "diagnosis": returnICDDiagnosis(e)})
//           .toList(),
//       "consultations": inreferralsListForEdit,
//       "vteProphylaxis": {
//         "date": formValues["vteDateTime"] != null
//             ? formValues["vteDateTime"].toString()
//             : null,
//         "inclusion": formValues["vteInclusion"],
//         "type": formValues["vteType"]
//       },
//       "icu": {
//         "arrival": formValues["icuArrival"] != null
//             ? formValues["icuArrival"].toString()
//             : null,
//         "exit": formValues["icuExit"] != null
//             ? formValues["icuExit"].toString()
//             : null,
//         "lengthOfStay": formValues["icuLengthStay"],
//       },
//       "lifeSupportWithdrawal": {
//         "lswBoolean": formValues["withdrawLST"],
//         "lswTimestamp": formValues["withdrawLSTDate"] != null
//             ? formValues["withdrawLSTDate"].toString()
//             : null
//       },
//       "dispositionInHospital": formValues["nextPhaseInHospital"]
//     };

//     Map<String, dynamic> discharge = {
//       "isTreatmentComplete": formValues["treatmentCompletedDischarge"],
//       "finalDiagnosis": formValues["icdCodeDischarge"],
//       "dispositionDischarge": formValues["dispositionDischarge"]
//     };

//     Map<String, dynamic> updatedPatientEntry = {
//       "preHospital": prehospital,
//       "er": er,
//       "surgery": surgery,
//       "inHospital": inhospital,
//       "discharge": discharge,
//       "dateCreated": dateCreated
//     };

//     // currentPhase updater for patientStream except for surgeryData
//     currentPhase = decidePhase(globals.department, formValues);
//     // end of currentPhase updater

//     print("Current Phase after Edit: " + currentPhase);

//     Map<String, dynamic> patientStreamData = {
//       "currentPhase": currentPhase,
//       "hospitalID": getHospitalID(widget.patient[0]["centralRegistryID"]),
//       "centralRegistryID": widget.patient[0]["centralRegistryID"],
//       "firstName": formValues["firstName"],
//       "lastName": formValues["lastName"],
//       "gender": formValues["gender"],
//       "patientDocumentID": id
//     };

//     // update the most recent entry for patientHistory array
//     // since the most recent entry will be the patient's updated record

//     List<Map<String, dynamic>> patientHistory =
//         widget.patient[0]["patientHistory"].cast<Map<String, dynamic>>();
//     patientHistory[patientDetailsIndex] = updatedPatientEntry;

//     // end of updating the most recent entry

//     var updatePatientDetails = await updatePatientAPI(
//         widget.patient[0]["centralRegistryID"],
//         patientHistory,
//         globals.deviceUsed,
//         globals.bearerToken);

//     print(updatePatientDetails.message);

//     final data = FireStoreModel(formValues["centralRegistryID"], citymunCode,
//         hospitalID, editHistory, general, patientHistory);
//     // prehospital,
//     // er,
//     // surgery, // surgery
//     // inhospital, // inhospital
//     // discharge, // discharge
//     // edit_history);

//     //   print(data);

//     await FireStoreDatabase.updatePatient(data, id, patientStreamData);
//   }

//   Padding buttonRow(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Expanded(
//             child: OutlinedButton(
//               child: const Text(
//                 "Back",
//                 style: TextStyle(color: Color.fromRGBO(74, 20, 140, 1)),
//               ),
//               onPressed: () {
//                 if (_selectedIndex == 0) {
//                   Get.back();
//                 } else {
//                   _controller.animateTo(_selectedIndex -= 1);
//                 }
//               },
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: MaterialButton(
//               color: Color.fromRGBO(74, 20, 140, 1),
//               child: const Text(
//                 "Submit",
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () async {
//                 var result = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (BuildContext context) => const PinCodeScreen(),
//                       fullscreenDialog: true,
//                     ));

//                 if (result == globals.pin) {
//                   // render all remaining invisible widgets for values gathering
//                   setState(() {
//                     visibleFirstAidGiven = true;
//                     visibleVehicularAccident = true;
//                     visibleMedicolegal = true;

//                     visibleTransferDetails = true;
//                     visiblePatientArrivalStatus = true;
//                     visibleOutrightSurgery = true;
//                   });
//                   _formKey.currentState!.save();
//                   if (_formKey.currentState!.validate()) {
//                     print(_formKey.currentState!.value);
//                     // print(regionId);
//                     // print(provincesId);
//                     // print(citiesId);
//                     _editData(_formKey.currentState!.value, regionId,
//                         provincesId, citiesId);
//                     // _formKey.currentState!.value contains all the information in the patient forms
//                     _formKey.currentState!.reset();

//                     // reset state of all conditional rendered widgets
//                     setState(() {
//                       visibleFirstAidGiven = false;
//                       visibleVehicularAccident = false;
//                       visibleMedicolegal = false;

//                       visibleTransferDetails = false;
//                       visiblePatientArrivalStatus = false;
//                       visibleOutrightSurgery = false;
//                       regionId = "";
//                       provincesId = "";
//                       citiesId = "";
//                     });

//                     Get.back();
//                   } else {
//                     print("validation failed");
//                   }
//                 } else {
//                   print(result);
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Padding buttonNav(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: <Widget>[
//           Expanded(
//             child: OutlinedButton(
//               child: const Text(
//                 "Back",
//                 style: TextStyle(color: Color.fromRGBO(74, 20, 140, 1)),
//               ),
//               onPressed: () {
//                 if (_selectedIndex == 0) {
//                   Get.back();
//                 } else {
//                   _controller.animateTo(_selectedIndex -= 1);
//                 }
//               },
//             ),
//           ),
//           const SizedBox(width: 20),
//           Expanded(
//             child: MaterialButton(
//               color: Colors.purple[900],
//               child: const Text(
//                 "Next",
//                 style: TextStyle(color: Colors.white),
//               ),
//               onPressed: () {
//                 _controller.animateTo(_selectedIndex += 1);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   // end of layout modules

//   // pre-hospital data

//   Padding chiefComplaint() {
//     // need validators for ID format
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
//         child: Column(
//           children: [
//             FractionallySizedBox(
//               widthFactor: 0.95,
//               child: FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["preHospital"]["chiefComplaint"],
//                 name: "chiefComplaint",
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   labelText: 'Chief Complaint',
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }

//   Padding massInjuryTF() {
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderRadioGroup(
//               name: "massInjury",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["preHospital"]["massInjury"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Mass Injury?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding dateTimeInjury() {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           FractionallySizedBox(
//             widthFactor: 0.95,
//             child: FormBuilderDateTimePicker(
//               initialValue: DateTime.parse(widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["preHospital"]["injuryTimestamp"]),
//               name: 'dateTimeInjury',
//               firstDate: DateTime(1900),
//               lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                   DateTime.now().day),
//               format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//               decoration: const InputDecoration(
//                 labelText: 'Date and Time of Injury',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Padding injuryIntent() {
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderRadioGroup(
//               name: "injuryType",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["preHospital"]["injuryIntent"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Injury Type",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(
//                     value: 'unintentional', child: Text('Unintentional')),
//                 FormBuilderFieldOption(
//                     value: 'intentional', child: Text('Intentional')),
//                 FormBuilderFieldOption(
//                     value: 'self-inflicted', child: Text('Self-Inflicted')),
//                 FormBuilderFieldOption(
//                     value: 'undetermined', child: Text('Undetermined')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding firstAidGiven() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["preHospital"]
//             ["firstAid"]["isGiven"] ==
//         "yes") {
//       setState(() {
//         visibleFirstAidGiven = true;
//       });
//     } else {
//       setState(() {
//         visibleFirstAidGiven = false;
//       });
//     }
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderRadioGroup(
//               name: "firstAidGiven",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["preHospital"]["firstAid"]["isGiven"],
//               onChanged: (valueFirstAidGiven) {
//                 if (valueFirstAidGiven == "yes") {
//                   setState(() {
//                     visibleFirstAidGiven =
//                         true; //verify for conditional rendering
//                   });
//                 } else {
//                   setState(() {
//                     visibleFirstAidGiven =
//                         false; //verify for conditional rendering
//                   });
//                 }
//               },
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "First Aid Given?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding condFirstAiderDetails() {
//     // need validators for ID format
//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
//         child: Column(
//           children: [
//             FractionallySizedBox(
//               widthFactor: 0.95,
//               child: FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["preHospital"]["firstAid"]
//                     ["firstAider"],
//                 name: "firstAider",
//                 autocorrect: false,
//                 decoration: const InputDecoration(
//                   labelText: 'Given by whom?',
//                 ),
//               ),
//             ),
//             FormBuilderRadioGroup(
//               name: "firstAidGivenProperly",
//               initialValue: widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["preHospital"]["firstAid"]
//                   ["isStandard"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "First Aid Given Properly?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding natureInjury() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//       child: Column(children: [
//         FormBuilderDropdown(
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["preHospital"]["natureOfInjury"],
//           name: 'natureOfInjury',
//           decoration: const InputDecoration(
//             labelText: 'Nature of Injury',
//           ),
//           // initialValue: 'Male',
//           // allowClear: true,
//           // hint: const Text('Select Nature of Injury'),
//           items: naturesOfInjury
//               .map((natureItem) => DropdownMenuItem(
//                     value: natureItem,
//                     child: Text('$natureItem'),
//                   ))
//               .toList(),
//         )
//       ]),
//     );
//   }

//   Padding externalCauseInjury() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//       child: Column(children: [
//         FormBuilderDropdown(
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["preHospital"]["externalCauses"],
//           name: 'externalCauseOfInjury',
//           decoration: const InputDecoration(
//             labelText: 'External Cause of Injury',
//           ),
//           // initialValue: 'Male',
//           // allowClear: true,
//           // hint: const Text('Select Nature of Injury'),
//           items: externalCausesInjury
//               .map((extInjuryItem) => DropdownMenuItem(
//                     value: extInjuryItem,
//                     child: Text('$extInjuryItem'),
//                   ))
//               .toList(),
//         )
//       ]),
//     );
//   }

//   Padding vehicularAccidentTF() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["preHospital"]
//             ["vehicularAccident"]["isVehicular"] ==
//         "yes") {
//       setState(() {
//         visibleVehicularAccident = true; //verify for conditional rendering
//       });
//     } else {
//       setState(() {
//         visibleVehicularAccident = false; //verify for conditional rendering
//       });
//     }

//     return Padding(
//         padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             FormBuilderRadioGroup(
//               name: "vehicularAccidentBool",
//               initialValue: widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["preHospital"]["vehicularAccident"]
//                   ["isVehicular"],
//               onChanged: (valueVehicularAccident) {
//                 if (valueVehicularAccident == "yes") {
//                   setState(() {
//                     visibleVehicularAccident =
//                         true; //verify for conditional rendering
//                   });
//                 } else {
//                   setState(() {
//                     visibleVehicularAccident =
//                         false; //verify for conditional rendering
//                   });
//                 }
//               },
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Vehicular Accident?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding condVehicularAccident() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//       child: Column(
//         children: [
//           FormBuilderRadioGroup(
//             name: "typeVehicularAccident",
//             initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["preHospital"]["vehicularAccident"]
//                 ["vehicleType"],
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               labelText: "Type of Vehicular Accident?",
//               labelStyle: TextStyle(fontSize: 18),
//             ),
//             options: const [
//               FormBuilderFieldOption(value: 'Land', child: Text('Land')),
//               FormBuilderFieldOption(value: 'Air', child: Text('Air')),
//               FormBuilderFieldOption(value: 'Sea', child: Text('Sea')),
//             ],
//           ),
//           FormBuilderRadioGroup(
//             name: "collisionOrNonCollision",
//             initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["preHospital"]["vehicularAccident"]
//                 ["collision"],
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               labelText: "Collision or Non-collision?",
//               labelStyle: TextStyle(fontSize: 18),
//             ),
//             options: const [
//               FormBuilderFieldOption(
//                   value: 'Collision', child: Text('Collision')),
//               FormBuilderFieldOption(
//                   value: 'Non-Collision', child: Text('Non-Collision')),
//             ],
//           ),
//           FormBuilderCheckboxGroup(
//             initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["preHospital"]["vehicularAccident"]
//                 ["partiesInvolved"],
//             name: 'partiesInvolved',
//             decoration: const InputDecoration(
//               labelText: 'Parties involved (Select all that apply)',
//             ),
//             options: const [
//               FormBuilderFieldOption(
//                   value: 'Pedestrian', child: Text('Pedestrian')),
//               FormBuilderFieldOption(value: 'Sedan', child: Text('Sedan')),
//               FormBuilderFieldOption(value: 'Van', child: Text('Van')),
//               FormBuilderFieldOption(value: 'Bus', child: Text('Bus')),
//               FormBuilderFieldOption(
//                   value: 'Motorcycle', child: Text('Motorcycle')),
//               FormBuilderFieldOption(value: 'Bicycle', child: Text('Bicycle')),
//               FormBuilderFieldOption(
//                   value: 'Tricycle', child: Text('Tricycle')),
//               FormBuilderFieldOption(value: 'Jeepney', child: Text('Jeepney')),
//               FormBuilderFieldOption(value: 'Plane', child: Text('Plane')),
//               FormBuilderFieldOption(
//                   value: 'Helicopter', child: Text('Helicopter')),
//               FormBuilderFieldOption(value: 'Boat', child: Text('Boat')),
//             ],
//           ),
//           FormBuilderRadioGroup(
//             name: "positionOfPatient",
//             initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["preHospital"]["vehicularAccident"]
//                 ["position"],
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               labelText: "Position of Patient?",
//               labelStyle: TextStyle(fontSize: 18),
//             ),
//             options: const [
//               FormBuilderFieldOption(value: 'Driver', child: Text('Driver')),
//               FormBuilderFieldOption(
//                   value: 'Passenger', child: Text('Passenger')),
//               FormBuilderFieldOption(value: 'Captain', child: Text('Captain')),
//               FormBuilderFieldOption(value: 'Pilot', child: Text('Pilot')),
//               FormBuilderFieldOption(
//                   value: 'Crew Member', child: Text('Crew Member')),
//               FormBuilderFieldOption(
//                   value: 'Pedestrian', child: Text('Pedestrian')),
//             ],
//           ),
//           FractionallySizedBox(
//             widthFactor: 0.95,
//             child: FormBuilderTextField(
//               initialValue: widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["preHospital"]["vehicularAccident"]
//                   ["placeOfOccurence"],
//               name: "placeOfOccurence",
//               autocorrect: false,
//               decoration: const InputDecoration(
//                 labelText: 'Place of Occurence? (Type "Unknown" if not known)',
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Padding activityDuringInjury() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "activityDuringAccident",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["preHospital"]["preInjuryActivity"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Activity During Accident?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'Sports', child: Text('Sports')),
//                 FormBuilderFieldOption(
//                     value: 'Leisure', child: Text('Leisure')),
//                 FormBuilderFieldOption(
//                     value: 'Work-related', child: Text('Work-related')),
//                 FormBuilderFieldOption(
//                     value: 'Unknown', child: Text('Unknown')),
//               ],
//             ),
//           ],
//         ));
//   }

//   Padding safetyIssue() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//         child: Column(
//           children: [
//             FormBuilderCheckboxGroup(
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["preHospital"]["safetyIssues"],
//               name: 'safetyIssues',
//               decoration: const InputDecoration(
//                 labelText: 'Safety Issues (select all that apply)',
//               ),
//               options: safetyIssues
//                   .map((safetyIssuesItem) => FormBuilderFieldOption(
//                         value: safetyIssuesItem,
//                         child: Text('$safetyIssuesItem'),
//                       ))
//                   .toList(),
//             ),
//           ],
//         ));
//   }

//   Padding medicolegalTF() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["preHospital"]
//             ["medicolegal"]["isMedicolegal"] ==
//         "yes") {
//       setState(() {
//         visibleMedicolegal = true;
//       });
//     } else {
//       setState(() {
//         visibleMedicolegal = false;
//       });
//     }
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "medicolegalCase",
//               initialValue: widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["preHospital"]["medicolegal"]
//                   ["isMedicolegal"],
//               onChanged: (valueMedicolegalCase) {
//                 if (valueMedicolegalCase == "yes") {
//                   setState(() {
//                     visibleMedicolegal =
//                         true; //verify for conditional rendering
//                   });
//                 } else {
//                   setState(() {
//                     visibleMedicolegal =
//                         false; //verify for conditional rendering
//                   });
//                 }
//               },
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Medicolegal Case?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding condMedicolegal() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(children: [
//         FormBuilderRadioGroup(
//           name: "medicolegalCategory",
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["preHospital"]["medicolegal"]["medicolegalCategory"],
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             errorBorder: InputBorder.none,
//             disabledBorder: InputBorder.none,
//             labelText: "Medicolegal Category",
//             labelStyle: TextStyle(fontSize: 18),
//           ),
//           options: const [
//             FormBuilderFieldOption(
//                 value: 'Violence against Women',
//                 child: Text('Violence against Women')),
//             FormBuilderFieldOption(
//                 value: 'Violence against Children',
//                 child: Text('Violence against Children')),
//             FormBuilderFieldOption(value: 'Rape', child: Text('Rape')),
//             FormBuilderFieldOption(value: 'Assault', child: Text('Assault')),
//             FormBuilderFieldOption(value: 'War', child: Text('War')),
//           ],
//         )
//       ]),
//     );
//   }

//   //layout modules for ER Data

//   Padding patientTransferred() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["er"]
//             ["isTransferred"] ==
//         "yes") {
//       setState(() {
//         visibleTransferDetails = true;
//       });
//     } else {
//       setState(() {
//         visibleTransferDetails = false;
//       });
//     }

//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "patientTransferred",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["er"]["isTransferred"],
//               onChanged: (valuePatientTransferred) {
//                 if (valuePatientTransferred == "yes") {
//                   setState(() {
//                     visibleTransferDetails =
//                         true; //verify for conditional rendering
//                   });
//                 } else {
//                   setState(() {
//                     visibleTransferDetails =
//                         false; //verify for conditional rendering
//                   });
//                 }
//               },
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Patient Transferred?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ],
//             )
//           ],
//         ));
//   }

//   Padding condTransferDetails() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(children: [
//         FormBuilderRadioGroup(
//           name: "coordinatedTransfer",
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["er"]["isCoordinated"],
//           decoration: const InputDecoration(
//             border: InputBorder.none,
//             focusedBorder: InputBorder.none,
//             enabledBorder: InputBorder.none,
//             errorBorder: InputBorder.none,
//             disabledBorder: InputBorder.none,
//             labelText: "Coordinated Transfer?",
//             labelStyle: TextStyle(fontSize: 18),
//           ),
//           options: const [
//             FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//             FormBuilderFieldOption(value: 'no', child: Text('No')),
//           ],
//         ),
//         FormBuilderTextField(
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["er"]["originatingInstitution"],
//           name: "originatingInstitution",
//           autocorrect: false,
//           decoration: const InputDecoration(
//             labelText: 'Name of Originating Institution (code)',
//           ),
//         ),
//         FormBuilderTextField(
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["er"]["previousInCharge"],
//           name: "previousInCharge",
//           autocorrect: false,
//           decoration: const InputDecoration(
//             labelText: 'Name of Previous In-Charge',
//           ),
//         ),
//         FormBuilderTextField(
//           initialValue: widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["er"]["positionPreviousInCharge"],
//           name: "positionPreviousInCharge",
//           autocorrect: false,
//           decoration: const InputDecoration(
//             labelText: 'Position of Previous In-Charge',
//           ),
//         ),
//       ]),
//     );
//   }

//   Padding statusOnArrival() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["er"]
//             ["statusOnArrival"] ==
//         "Alive") {
//       setState(() {
//         visiblePatientArrivalStatus = true;
//       });
//     } else {
//       setState(() {
//         visiblePatientArrivalStatus = false;
//       });
//     }
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "statusOnArrival",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["er"]["statusOnArrival"],
//               onChanged: (valuePatientArrival) {
//                 if (valuePatientArrival == "Alive") {
//                   setState(() {
//                     visiblePatientArrivalStatus =
//                         true; //verify for conditional rendering
//                   });
//                 } else {
//                   setState(() {
//                     visiblePatientArrivalStatus =
//                         false; //verify for conditional rendering
//                   });
//                 }
//               },
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Status on Arrival?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(
//                     value: 'Dead on Arrival', child: Text('Dead On Arrival')),
//                 FormBuilderFieldOption(value: 'Alive', child: Text('Alive')),
//               ],
//             ),
//           ],
//         ));
//   }

//   Padding condArrivalStatus() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "aliveStatus",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["er"]["aliveCategory"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "State on Arrival? (For Alive Option)",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(
//                     value: 'Conscious', child: Text('Conscious')),
//                 FormBuilderFieldOption(
//                     value: 'Unconscious', child: Text('Unconscious')),
//                 FormBuilderFieldOption(
//                     value: 'In Extremis', child: Text('In Extremis')),
//               ],
//             ),
//           ],
//         ));
//   }

//   Padding modeOfTransport() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           FormBuilderDropdown(
//             initialValue: widget.patient[0]["patientHistory"]
//                 [patientDetailsIndex]["er"]["transportation"],
//             name: "modeOfTransport",
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               labelText: "Mode of Transportation?",
//               labelStyle: TextStyle(fontSize: 18),
//             ),
//             items: modeOfTranspo
//                 .map((transpoItem) => DropdownMenuItem(
//                       value: transpoItem,
//                       child: Text('$transpoItem'),
//                     ))
//                 .toList(),
//           )
//         ],
//       ),
//     );
//   }

//   Padding initialImpressions() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "initialImpression",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["er"]["initialImpression"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Initial Impression?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(
//                     value: 'Trauma with Intervention',
//                     child: Text('Trauma with Intervention')),
//                 FormBuilderFieldOption(
//                     value: 'Trauma without Intervention',
//                     child: Text('Trauma without Intervention')),
//                 FormBuilderFieldOption(value: 'Others', child: Text('Others')),
//               ],
//             ),
//           ],
//         ));
//   }

//   Padding surgicalTF() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["er"]
//             ["isSurgical"] ==
//         "yes") {
//       setState(() {
//         visibleOutrightSurgery = true;
//       });
//     } else {
//       setState(() {
//         visibleOutrightSurgery = false;
//       });
//     }
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "outrightSurgical",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["er"]["isSurgical"],
//               onChanged: (valueSurgical) {
//                 if (valueSurgical == "yes") {
//                   setState(() {
//                     visibleOutrightSurgery =
//                         true; //verify for conditional rendering
//                   });
//                 } else {
//                   setState(() {
//                     visibleOutrightSurgery =
//                         false; //verify for conditional rendering
//                   });
//                 }
//               },
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Outright Surgical?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ],
//             ),
//           ],
//         ));
//   }

//   Padding condSurgicalDetails() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Column(
//         children: [
//           FormBuilderRadioGroup(
//             name: "cavityForSurgery",
//             initialValue: widget.patient[0]["patientHistory"]
//                 [patientDetailsIndex]["er"]["cavityInvolved"],
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               labelText: "Cavity Involved for Surgery?",
//               labelStyle: TextStyle(fontSize: 18),
//             ),
//             options: cavitiesForSurgery
//                 .map((cavityItem) => FormBuilderFieldOption(
//                       value: cavityItem,
//                       child: Text('$cavityItem'),
//                     ))
//                 .toList(),
//           ),
//           FormBuilderCheckboxGroup(
//             name: "servicesOnboardSurgery",
//             initialValue: widget.patient[0]["patientHistory"]
//                 [patientDetailsIndex]["er"]["servicesOnboard"],
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               focusedBorder: InputBorder.none,
//               enabledBorder: InputBorder.none,
//               errorBorder: InputBorder.none,
//               disabledBorder: InputBorder.none,
//               labelText: "Services Onboard?",
//               labelStyle: TextStyle(fontSize: 18),
//             ),
//             options: servicesOnboard
//                 .map((serviceItem) => FormBuilderFieldOption(
//                       value: serviceItem,
//                       child: Text('$serviceItem'),
//                     ))
//                 .toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Padding patientDisposition() {
//     return Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             FormBuilderRadioGroup(
//               name: "patientDisposition",
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["er"]["dispositionER"],
//               decoration: const InputDecoration(
//                 border: InputBorder.none,
//                 focusedBorder: InputBorder.none,
//                 enabledBorder: InputBorder.none,
//                 errorBorder: InputBorder.none,
//                 disabledBorder: InputBorder.none,
//                 labelText: "Patient Disposition?",
//                 labelStyle: TextStyle(fontSize: 18),
//               ),
//               options: disposition
//                   .map((dispoItem) => FormBuilderFieldOption(
//                         value: dispoItem,
//                         child: Text('$dispoItem'),
//                       ))
//                   .toList(),
//             ),
//             FormBuilderRadioGroup(
//                 name: "outcome",
//                 initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["er"]["outcome"],
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   labelText: "Outcome?",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//                 options: const [
//                   FormBuilderFieldOption(
//                       value: 'Improved', child: Text('Improved')),
//                   FormBuilderFieldOption(
//                       value: 'Unimproved', child: Text('Unimproved')),
//                   FormBuilderFieldOption(value: 'Died', child: Text('Died'))
//                 ]),
//           ],
//         ));
//   }

//   //Surgery Data

//   Widget surgeryBoolean() {
//     // initializeDateFormatting('az');
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         color: Colors.white,
//         child: ListTile(
//           title: FormBuilderRadioGroup(
//               initialValue: widget.patient[0]["patientHistory"]
//                   [patientDetailsIndex]["surgery"]["surgeryBoolean"],
//               decoration: const InputDecoration(
//                 labelText: 'Patient Needing Surgery',
//               ),
//               name: "forSurgery",
//               options: const [
//                 FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                 FormBuilderFieldOption(value: 'no', child: Text('No')),
//               ]),
//         ),
//       ),
//     );
//   }

//   Widget surgeryTemplate() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         color: Colors.white,
//         child: ListTile(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                 child: Text(
//                   "Surgery # " + (getSurgeriesNumber() + 1).toString(),
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
//                 ),
//               ),

//               FormBuilderRadioGroup(
//                   decoration: const InputDecoration(
//                     labelText: 'Place of Surgery',
//                   ),
//                   name:
//                       "placeOfSurgery" + (getSurgeriesNumber() + 1).toString(),
//                   options: const [
//                     FormBuilderFieldOption(
//                         value: 'ER', child: Text('Emergency Room (ER)')),
//                     FormBuilderFieldOption(
//                         value: 'OR', child: Text('Operating Room (OR)')),
//                   ]),

//               // FormBuilderTextField(
//               //   decoration: const InputDecoration(labelText: 'RVS Code and Procedure',),
//               //   name: "rvsCode" + (getSurgeriesNumber() + 1).toString(),
//               //   ),

//               FormBuilderSearchableDropdown(
//                   decoration: const InputDecoration(
//                     labelText: 'RVS Code and Procedure',
//                   ),
//                   name: "rvsCode" + (getSurgeriesNumber() + 1).toString(),
//                   items: RVSList),
//               // FormBuilderTextField(
//               //   name: "surgeryDone",
//               //   enabled: false)

//               FormBuilderRadioGroup(
//                 name: "cavityInvolved" + (getSurgeriesNumber() + 1).toString(),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   labelText: "Cavity Involved for Surgery?",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//                 options: cavitiesForSurgery
//                     .map((cavityItem) => FormBuilderFieldOption(
//                           value: cavityItem,
//                           child: Text('$cavityItem'),
//                         ))
//                     .toList(),
//               ),

//               FormBuilderCheckboxGroup(
//                 name: "servicesPresent" + (getSurgeriesNumber() + 1).toString(),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   labelText: "Services Present?",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//                 options: servicesOnboard
//                     .map((serviceItem) => FormBuilderFieldOption(
//                           value: serviceItem,
//                           child: Text('$serviceItem'),
//                         ))
//                     .toList(),
//               ),

//               Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                 child: Text(
//                   "Surgery Details: ",
//                   style: TextStyle(color: Colors.blueGrey[200]),
//                 ),
//               ),

//               FormBuilderTextField(
//                 name: "phaseBegun" + (getSurgeriesNumber() + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Phase Begun",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderTextField(
//                 name: "surgeryType" + (getSurgeriesNumber() + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Surgery Type",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderTextField(
//                 name: "surgeon" + (getSurgeriesNumber() + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Surgeon",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderDateTimePicker(
//                 name: "startDateTime" + (getSurgeriesNumber() + 1).toString(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                     DateTime.now().day),
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 decoration: const InputDecoration(
//                   labelText: "Surgery Start Date & Time",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderDateTimePicker(
//                 name: "endDateTime" + (getSurgeriesNumber() + 1).toString(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                     DateTime.now().day),
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 decoration: const InputDecoration(
//                   labelText: "Surgery End Date & Time",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderTextField(
//                 name: "hemorrhageControlType" +
//                     (getSurgeriesNumber() + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Hemorrhage Control Type (if any)",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderDateTimePicker(
//                 name: "hemorrhageControlDateTime" +
//                     (getSurgeriesNumber() + 1).toString(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                     DateTime.now().day),
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 decoration: const InputDecoration(
//                   labelText: "Hemorrhage Controlled Date & Time",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderRadioGroup(
//                   decoration: const InputDecoration(
//                     labelText: 'Next Phase after Surgery',
//                   ),
//                   name: "nextPhase" + (getSurgeriesNumber() + 1).toString(),
//                   options: const [
//                     FormBuilderFieldOption(
//                         value: 'In-Hospital Staff',
//                         child: Text('Admit (In-Hospital)')),
//                     FormBuilderFieldOption(
//                         value: 'Discharge Staff', child: Text('Discharge')),
//                   ]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget surgeryTemplateForEdit(int listIndex) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         color: Colors.white,
//         child: ListTile(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                 child: Text(
//                   "Surgery # " + (listIndex + 1).toString(),
//                   style: TextStyle(
//                       fontWeight: FontWeight.bold, color: Colors.blueGrey[900]),
//                 ),
//               ),

//               FormBuilderRadioGroup(
//                   // initialValue: widget.patient[0]["surgery"]["surgeriesList"][listIndex]["placeOfSurgery" + (listIndex + 1).toString()],
//                   initialValue: widget.patient[0]["patientHistory"]
//                           [patientDetailsIndex]["surgery"]["surgeriesList"]
//                       [listIndex]["placeOfSurgery"],
//                   decoration: const InputDecoration(
//                     labelText: 'Place of Surgery',
//                   ),
//                   name: "placeOfSurgery" + (listIndex + 1).toString(),
//                   options: const [
//                     FormBuilderFieldOption(
//                         value: 'ER', child: Text('Emergency Room (ER)')),
//                     FormBuilderFieldOption(
//                         value: 'OR', child: Text('Operating Room (OR)')),
//                   ]),

//               // FormBuilderTextField(
//               //   initialValue: widget.patient[0]["surgery"]["surgeriesList"][listIndex]["rvsCode" + (listIndex + 1).toString()],
//               //   decoration: const InputDecoration(labelText: 'RVS Code and Procedure',),
//               //   name: "rvsCode" + (listIndex + 1).toString(),
//               //   ),

//               FormBuilderSearchableDropdown(
//                 items: RVSList,
//                 initialValue: (widget.patient[0]["patientHistory"]
//                             [patientDetailsIndex]["surgery"]["surgeriesList"]
//                         [listIndex]["rvsCode"])
//                     .toString(),
//                 decoration: const InputDecoration(
//                   labelText: 'RVS Code and Procedure',
//                 ),
//                 name: "rvsCode" + (listIndex + 1).toString(),
//               ),
//               // FormBuilderTextField(
//               //   name: "surgeryDone",
//               //   enabled: false)

//               FormBuilderRadioGroup(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["surgery"]["surgeriesList"]
//                     [listIndex]["cavityInvolved"],
//                 name: "cavityInvolved" + (listIndex + 1).toString(),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   labelText: "Cavity Involved for Surgery?",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//                 options: cavitiesForSurgery
//                     .map((cavityItem) => FormBuilderFieldOption(
//                           value: cavityItem,
//                           child: Text('$cavityItem'),
//                         ))
//                     .toList(),
//               ),

//               FormBuilderCheckboxGroup(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["surgery"]["surgeriesList"]
//                     [listIndex]["servicesPresent"],
//                 name: "servicesPresent" + (listIndex + 1).toString(),
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   labelText: "Services Present?",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//                 options: servicesOnboard
//                     .map((serviceItem) => FormBuilderFieldOption(
//                           value: serviceItem,
//                           child: Text('$serviceItem'),
//                         ))
//                     .toList(),
//               ),

//               Padding(
//                 padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                 child: Text(
//                   "Surgery Details: ",
//                   style: TextStyle(color: Colors.blueGrey[200]),
//                 ),
//               ),

//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["surgery"]["surgeriesList"]
//                     [listIndex]["phaseBegun"],
//                 name: "phaseBegun" + (listIndex + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Phase Begun",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["surgery"]["surgeriesList"]
//                     [listIndex]["surgeryType"],
//                 name: "surgeryType" + (listIndex + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Surgery Type",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["surgery"]["surgeriesList"]
//                     [listIndex]["surgeon"],
//                 name: "surgeon" + (listIndex + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Surgeon",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderDateTimePicker(
//                 initialValue: DateTime.tryParse(widget.patient[0]
//                         ["patientHistory"][patientDetailsIndex]["surgery"]
//                     ["surgeriesList"][listIndex]["startTimestamp"]),
//                 name: "startDateTime" + (listIndex + 1).toString(),
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                     DateTime.now().day),
//                 decoration: const InputDecoration(
//                   labelText: "Surgery Start Date & Time",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderDateTimePicker(
//                 initialValue: DateTime.tryParse(widget.patient[0]
//                         ["patientHistory"][patientDetailsIndex]["surgery"]
//                     ["surgeriesList"][listIndex]["endTimestamp"]),
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 name: "endDateTime" + (listIndex + 1).toString(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                     DateTime.now().day),
//                 decoration: const InputDecoration(
//                   labelText: "Surgery End Date & Time",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["surgery"]["surgeriesList"]
//                     [listIndex]["hemorrhageControl"]["type"],
//                 name: "hemorrhageControlType" + (listIndex + 1).toString(),
//                 decoration: const InputDecoration(
//                   labelText: "Hemorrhage Control Type (if any)",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               FormBuilderDateTimePicker(
//                 initialValue: DateTime.tryParse(widget.patient[0]
//                             ["patientHistory"][patientDetailsIndex]["surgery"]
//                         ["surgeriesList"][listIndex]["hemorrhageControl"]
//                     ["hemorrhageTimestamp"]),
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 name: "hemorrhageControlDateTime" + (listIndex + 1).toString(),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                     DateTime.now().day),
//                 decoration: const InputDecoration(
//                   labelText: "Hemorrhage Controlled Date & Time",
//                   labelStyle: TextStyle(fontSize: 18),
//                 ),
//               ),

//               // FormBuilderTextField(
//               //   initialValue: widget.patient[0]["surgery"]["surgeriesList"][listIndex]["nextPhase" + (listIndex + 1).toString()],
//               //   name: "nextPhase" + (listIndex + 1).toString(),
//               //   decoration: const InputDecoration(
//               //     labelText: "Next Phase after Surgery",
//               //     labelStyle: TextStyle(
//               //       fontSize: 18
//               //     ),
//               //   ),),

//               FormBuilderRadioGroup(
//                   initialValue: widget.patient[0]["patientHistory"]
//                           [patientDetailsIndex]["surgery"]["surgeriesList"]
//                       [listIndex]["dispositionSurgery"],
//                   decoration: const InputDecoration(
//                     labelText: 'Next Phase after Surgery',
//                   ),
//                   name: "nextPhase" + (listIndex + 1).toString(),
//                   options: const [
//                     FormBuilderFieldOption(
//                         value: 'In-Hospital',
//                         child: Text('Admit (In-Hospital)')),
//                     FormBuilderFieldOption(
//                         value: 'Discharge', child: Text('Discharge')),
//                   ]),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void addSurgeryWidget() {
//     setState(() {
//       surgeryCardList.add(surgeryTemplate());
//     });
//   }

//   void renderSurgeryWidgetsForEdit() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["surgery"]
//             ["surgeriesList"] !=
//         null) {
//       int lengthList = widget
//           .patient[0]["patientHistory"][patientDetailsIndex]["surgery"]
//               ["surgeriesList"]
//           .length;
//       for (var index = 0; index < lengthList; index++) {
//         setState(() {
//           surgeryCardList.add(surgeryTemplateForEdit(index));
//         });
//       }
//     }
//   }

//   // In-Hospital Data Widgets

//   int getInreferralsNumber() {
//     return inreferralsList.length;
//   }

//   Widget hospitalEventTemplate(BuildContext context) {
//     var widthScreen = MediaQuery.of(context).size.width * 0.9;

//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       color: Colors.white,
//       child: SizedBox(
//         width: widthScreen,
//         child: ListTile(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               SizedBox(
//                 width: widthScreen,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                   child: Text(
//                     "Patient Complications (ICD Code and Description)",
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueGrey[900]),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                   // you may want to use an aspect ratio here for tablet support
//                   height: 100.0,
//                   child: MultiSelectBottomSheetField(
//                     initialValue: complications,
//                     // initialValue: (){
//                     //   if (widget.patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]["complications"] == []){
//                     //     return [];
//                     //   }

//                     //   return widget.patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]["complications"].map((e) => e["icdCode"]).toList();
//                     // }(),
//                     chipDisplay: MultiSelectChipDisplay(
//                       height: 50,
//                       scroll: true,
//                     ),
//                     listType: MultiSelectListType.LIST,
//                     title: const Text("Add"),
//                     searchHint: "Add Complication",
//                     searchable: true,
//                     searchIcon: const Icon(Icons.search),
//                     items: ICDCodes.map((e) => MultiSelectItem(
//                         e["code"], e["code"] + ": " + e["desc"])).toList(),
//                     onConfirm: (_selectedItems) {
//                       setState(() {
//                         complications = _selectedItems;
//                         print(_selectedItems);
//                       });
//                     },
//                   )),
//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["inHospital"]["capriniScore"],
//                 name: "capriniScore",
//                 decoration: const InputDecoration(
//                   labelText: "CAPRINI Score",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["inHospital"]["vteProphylaxis"]
//                     ["inclusion"],
//                 name: "vteInclusion",
//                 decoration: const InputDecoration(
//                   labelText: "VTE Prophylaxis Inclusion",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["inHospital"]["vteProphylaxis"]
//                     ["type"],
//                 name: "vteType",
//                 decoration: const InputDecoration(
//                   labelText: "VTE Prophylaxis Type",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FormBuilderDateTimePicker(
//                 initialValue: () {
//                   if (widget.patient[0]["patientHistory"][patientDetailsIndex]
//                           ["inHospital"]["vteProphylaxis"]["date"] ==
//                       null) {
//                     return null;
//                   }

//                   return DateTime.tryParse(widget.patient[0]["patientHistory"]
//                           [patientDetailsIndex]["inHospital"]["vteProphylaxis"]
//                       ["date"]);
//                 }(),
//                 name: "vteDateTime",
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(
//                     DateTime.now().year,
//                     DateTime.now().month,
//                     DateTime.now().day,
//                     DateTime.now().hour,
//                     DateTime.now().minute),
//                 decoration: const InputDecoration(
//                   labelText: "VTE Prophylaxis Date & Time",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FormBuilderDateTimePicker(
//                 initialValue: () {
//                   if (widget.patient[0]["patientHistory"][patientDetailsIndex]
//                           ["inHospital"]["icu"]["arrival"] ==
//                       null) {
//                     return null;
//                   }
//                   return DateTime.tryParse(widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["inHospital"]["icu"]["arrival"]);
//                 }(),
//                 inputType: InputType.date,
//                 format: DateFormat('yyyy-MM-dd'),
//                 name: "icuArrival",
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(
//                     DateTime.now().year,
//                     DateTime.now().month,
//                     DateTime.now().day,
//                     DateTime.now().hour,
//                     DateTime.now().minute),
//                 decoration: const InputDecoration(
//                   labelText: "ICU Arrival Date",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FormBuilderDateTimePicker(
//                 initialValue: () {
//                   if (widget.patient[0]["patientHistory"][patientDetailsIndex]
//                           ["inHospital"]["icu"]["exit"] ==
//                       null) {
//                     return null;
//                   }

//                   return DateTime.tryParse(widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["inHospital"]["icu"]["exit"]);
//                 }(),
//                 inputType: InputType.date,
//                 format: DateFormat('yyyy-MM-dd'),
//                 name: "icuExit",
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(
//                     DateTime.now().year,
//                     DateTime.now().month,
//                     DateTime.now().day,
//                     DateTime.now().hour,
//                     DateTime.now().minute),
//                 decoration: const InputDecoration(
//                   labelText: "ICU Exit Date",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FormBuilderTextField(
//                 initialValue: widget.patient[0]["patientHistory"]
//                     [patientDetailsIndex]["inHospital"]["icu"]["lengthOfStay"],
//                 name: "icuLengthStay",
//                 decoration: const InputDecoration(
//                   labelText: "ICU Length of Stay",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(
//                 height: 30,
//               ),
//               FormBuilderRadioGroup(
//                 name: "withdrawLST",
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["inHospital"]
//                     ["lifeSupportWithdrawal"]["lswBoolean"],
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   labelText: "Withdrawal of Life-Supporting Treatment?",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 options: const [
//                   FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                   FormBuilderFieldOption(value: 'no', child: Text('No')),
//                   FormBuilderFieldOption(
//                       value: 'na', child: Text('Not Applicable')),
//                 ],
//               ),
//               FormBuilderDateTimePicker(
//                 initialValue: () {
//                   if (widget.patient[0]["patientHistory"][patientDetailsIndex]
//                               ["inHospital"]["lifeSupportWithdrawal"]
//                           ["lswTimestamp"] ==
//                       null) {
//                     return null;
//                   }

//                   return DateTime.tryParse(widget.patient[0]["patientHistory"]
//                           [patientDetailsIndex]["inHospital"]
//                       ["lifeSupportWithdrawal"]["lswTimestamp"]);
//                 }(),
//                 name: "withdrawLSTDate",
//                 firstDate: DateTime(2000),
//                 lastDate: DateTime(
//                     DateTime.now().year,
//                     DateTime.now().month,
//                     DateTime.now().day,
//                     DateTime.now().hour,
//                     DateTime.now().minute),
//                 format: DateFormat('yyyy-MM-dd HH:mm:ss'),
//                 decoration: const InputDecoration(
//                   labelText: "Withdrawal Date & Time",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               FormBuilderRadioGroup(
//                 name: "nextPhaseInHospital",
//                 initialValue: widget.patient[0]["patientHistory"]
//                         [patientDetailsIndex]["inHospital"]
//                     ["dispositionInHospital"],
//                 decoration: const InputDecoration(
//                   border: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   errorBorder: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   labelText: "Next Phase?",
//                   labelStyle:
//                       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 options: const [
//                   FormBuilderFieldOption(
//                       value: 'In-Hospital Staff',
//                       child: Text('Remain In-Hospital')),
//                   FormBuilderFieldOption(
//                       value: 'Surgery Staff', child: Text('Surgery')),
//                   FormBuilderFieldOption(
//                       value: 'Discharge Staff', child: Text('Discharge')),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget inreferralsTemplateForEdit(int index) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       color: Colors.white,
//       child: ListTile(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             FormBuilderTextField(
//               initialValue: widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["inHospital"]["consultations"]
//                   [index]["service"],
//               name: "consultationService" + (index + 1).toString(),
//               decoration: const InputDecoration(
//                 labelText: "Consultation Service",
//                 labelStyle:
//                     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             FormBuilderTextField(
//               initialValue: widget.patient[0]["patientHistory"]
//                       [patientDetailsIndex]["inHospital"]["consultations"]
//                   [index]["physician"],
//               name: "consultationPhysician" + (index + 1).toString(),
//               decoration: const InputDecoration(
//                 labelText: "Consultation Physician",
//                 labelStyle:
//                     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             FormBuilderDateTimePicker(
//               initialValue: DateTime.tryParse(widget.patient[0]
//                       ["patientHistory"][patientDetailsIndex]["inHospital"]
//                   ["consultations"][index]["consultationTimestamp"]),
//               inputType: InputType.date,
//               format: DateFormat('yyyy-MM-dd'),
//               name: "consultationDate" + (index + 1).toString(),
//               firstDate: DateTime(2000),
//               lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                   DateTime.now().day),
//               decoration: const InputDecoration(
//                 labelText: "Consultation Date",
//                 labelStyle:
//                     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget inreferralsTemplate(BuildContext context) {
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       color: Colors.white,
//       child: ListTile(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             FormBuilderTextField(
//               name: "consultationService" +
//                   (getInreferralsNumber() + 1).toString(),
//               decoration: const InputDecoration(
//                 labelText: "Consultation Service",
//                 labelStyle:
//                     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             FormBuilderTextField(
//               name: "consultationPhysician" +
//                   (getInreferralsNumber() + 1).toString(),
//               decoration: const InputDecoration(
//                 labelText: "Consultation Physician",
//                 labelStyle:
//                     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//             FormBuilderDateTimePicker(
//               inputType: InputType.date,
//               format: DateFormat('yyyy-MM-dd'),
//               name:
//                   "consultationDate" + (getInreferralsNumber() + 1).toString(),
//               firstDate: DateTime(2000),
//               lastDate: DateTime(DateTime.now().year, DateTime.now().month,
//                   DateTime.now().day),
//               decoration: const InputDecoration(
//                 labelText: "Consultation Date",
//                 labelStyle:
//                     TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget comorbidityTemplate(BuildContext context) {
//     var widthScreen = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: widthScreen,
//         child: Card(
//           elevation: 5,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           color: Colors.white,
//           child: SizedBox(
//             width: widthScreen,
//             child: ListTile(
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: widthScreen,
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                       child: Text(
//                         "Comorbid Conditions",
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.blueGrey[900]),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                       // you may want to use an aspect ratio here for tablet support
//                       height: 100.0,
//                       child: MultiSelectBottomSheetField(
//                         initialValue: comorbidities,
//                         // initialValue: (){
//                         //   if(widget.patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]["comorbidities"] == []){
//                         //       return [];
//                         //   }

//                         //   return widget.patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]["comorbidities"].map((e) => e["icdCode"]).toList();
//                         // }(),

//                         chipDisplay: MultiSelectChipDisplay(
//                           height: 50,
//                           scroll: true,
//                         ),
//                         listType: MultiSelectListType.LIST,
//                         title: const Text("Add"),
//                         searchHint: "Add Comorbidity",
//                         searchable: true,
//                         searchIcon: const Icon(Icons.search),
//                         items: ICDCodes.map((e) => MultiSelectItem(
//                             e["code"], e["code"] + ": " + e["desc"])).toList(),
//                         onConfirm: (_selectedItems) {
//                           setState(() {
//                             comorbidities = _selectedItems;
//                             print(_selectedItems);
//                           });
//                         },
//                       )),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void addInreferralsWidget(BuildContext context) {
//     setState(() {
//       inreferralsList.add(inreferralsTemplate(context));
//     });
//   }

//   void renderInHospitalWidgetsForEdit() {
//     if (widget.patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]
//             ["consultations"] !=
//         null) {
//       int lengthList = widget
//           .patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]
//               ["consultations"]
//           .length;
//       for (var index = 0; index < lengthList; index++) {
//         setState(() {
//           inreferralsList.add(inreferralsTemplateForEdit(index));
//         });
//       }
//     }
//   }

//   // End of In-Hospital Data Widgets

//   // Discharge Data Widgets

//   Widget treatmentCompleted(BuildContext context) {
//     var widthScreen = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: widthScreen,
//         child: Card(
//           elevation: 5,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           color: Colors.white,
//           child: ListTile(
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                   child: FormBuilderRadioGroup(
//                     name: "treatmentCompletedDischarge",
//                     initialValue: widget.patient[0]["patientHistory"]
//                             [patientDetailsIndex]["discharge"]
//                         ["isTreatmentComplete"],
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       focusedBorder: InputBorder.none,
//                       enabledBorder: InputBorder.none,
//                       errorBorder: InputBorder.none,
//                       disabledBorder: InputBorder.none,
//                       labelText: "Treatment Completed?",
//                       labelStyle: TextStyle(fontSize: 18),
//                     ),
//                     options: const [
//                       FormBuilderFieldOption(value: 'yes', child: Text('Yes')),
//                       FormBuilderFieldOption(value: 'no', child: Text('No')),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget icdCodeAndDiagnosis(BuildContext context) {
//     var widthScreen = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: widthScreen,
//         child: Card(
//           elevation: 5,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           color: Colors.white,
//           child: ListTile(
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                   child: FormBuilderSearchableDropdown(
//                       initialValue: () {
//                         if (widget.patient[0]["patientHistory"]
//                                 [patientDetailsIndex]["discharge"]["icdCode"] ==
//                             null) {
//                           return " ";
//                         } else {
//                           return widget.patient[0]["patientHistory"]
//                                   [patientDetailsIndex]["discharge"]["icdCode"]
//                               .toString();
//                         }
//                       }(),
//                       name: "icdCodeDischarge",
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         focusedBorder: InputBorder.none,
//                         enabledBorder: InputBorder.none,
//                         errorBorder: InputBorder.none,
//                         disabledBorder: InputBorder.none,
//                         labelText: "Final Diagnosis (ICD Code and Description)",
//                         labelStyle: TextStyle(fontSize: 18),
//                       ),
//                       items: ICDCodesArray),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget dischargeDisposition(BuildContext context) {
//     var widthScreen = MediaQuery.of(context).size.width;

//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: SizedBox(
//         width: widthScreen,
//         child: Card(
//           elevation: 5,
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           color: Colors.white,
//           child: ListTile(
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                     padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
//                     child: FormBuilderRadioGroup(
//                       name: "dispositionDischarge",
//                       initialValue: widget.patient[0]["patientHistory"]
//                               [patientDetailsIndex]["discharge"]
//                           ["dispositionDischarge"],
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                         focusedBorder: InputBorder.none,
//                         enabledBorder: InputBorder.none,
//                         errorBorder: InputBorder.none,
//                         disabledBorder: InputBorder.none,
//                         labelText: "Disposition on Discharge?",
//                         labelStyle: TextStyle(fontSize: 18),
//                       ),
//                       options: dischargeDispositionArray
//                           .map((dispoItem) => FormBuilderFieldOption(
//                                 value: dispoItem,
//                                 child: Text('$dispoItem'),
//                               ))
//                           .toList(),
//                     )),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // End of Discharge Data Widgets

//   @override
//   void initState() {
//     print(widget.patient);
//     readJsonRegions();
//     readJsonProvinces();
//     readJsonCities();
//     readJsonCPT4Codes();
//     readJsonICDCodes();
//     print("Initialized edit.dart");

//     setState(() {
//       patientDetailsIndex = recentPatientDetailsIndex();
//     });

//     print(patientDetailsIndex);

//     super.initState();
//     _controller = TabController(length: 6, vsync: this);
//     setDependentDropDownAddress();
//     renderSurgeryWidgetsForEdit();
//     renderInHospitalWidgetsForEdit();

//     setState(() {
//       initialSurgeriesNumber = getSurgeriesNumber();
//       comorbidities = widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["inHospital"]["comorbidities"]
//           .map((e) => e["icdCode"])
//           .toList();
//       complications = widget.patient[0]["patientHistory"][patientDetailsIndex]
//               ["inHospital"]["complications"]
//           .map((e) => e["icdCode"])
//           .toList();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var widthScreen = MediaQuery.of(context).size.width;

//     return DefaultTabController(
//       initialIndex: 0,
//       length: 6,
//       child: Scaffold(
//           appBar: AppBar(
//               flexibleSpace: Container(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                       colors: <Color>[
//                         Color.fromRGBO(142, 36, 170, 1),
//                         Color.fromARGB(255, 74, 20, 140)
//                       ]),
//                 ),
//               ),
//               centerTitle: true,
//               title: const Text("Edit Patient Details"),
//               bottom: TabBar(
//                 isScrollable: true,
//                 unselectedLabelColor: Colors.white30, // Other tabs color
//                 labelPadding: const EdgeInsets.symmetric(
//                     horizontal: 30), // Space between tabs
//                 indicator: const UnderlineTabIndicator(
//                   borderSide: BorderSide(
//                       color: Colors.white, width: 2), // Indicator height
//                   insets:
//                       EdgeInsets.symmetric(horizontal: 48), // Indicator width
//                 ),
//                 controller: _controller,
//                 tabs: const <Widget>[
//                   Tab(text: "General"),
//                   Tab(text: "Pre-Hospital"),
//                   Tab(text: "ER"),
//                   Tab(text: "Surgery"),
//                   Tab(text: "In-Hospital"),
//                   Tab(text: "Discharge")
//                 ],
//               ),
//               leading: BackButton(
//                 onPressed: () => Get.back(),
//               )),
//           body: FormBuilder(
//               key: _formKey,
//               child: TabBarView(
//                 controller: _controller,
//                 children: [
//                   // General data
//                   Scaffold(
//                     // persistentFooterButtons: [buttonNav(context)],
//                     body: Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: SingleChildScrollView(
//                         child: Column(children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 8.0),
//                             child: Card(
//                               elevation: 5,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               color: Colors.white,
//                               child: Column(
//                                   children: [generateID(), dateCreatedField()]),
//                             ),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 8.0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   patientType(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 8.0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   patientName(),
//                                 ])),
//                           ),
//                           // start of fillable fields for general data
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 8.0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   bdayAge(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 8.0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   genderPick(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   presentPermanentAddress(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   philhealthID(),
//                                 ])),
//                           ),
//                         ]),
//                       ),
//                     ),
//                   ),

//                   // Pre-Hospital Data
//                   Scaffold(
//                     // persistentFooterButtons: [buttonNav(context)],
//                     body: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SingleChildScrollView(
//                           child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   chiefComplaint(),
//                                   massInjuryTF(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(0, 0, 0, 16),
//                                   child: Column(children: [
//                                     FormHelper.dropDownWidgetWithLabel(
//                                       context,
//                                       "Region",
//                                       "Select Region",
//                                       //widget.patient[0]["prehospital"]["regionsID"],
//                                       regionId,
//                                       regions,
//                                       (onChangedVal) {
//                                         regionId = onChangedVal;
//                                         debugPrint(
//                                             "Selected Region: $onChangedVal");
//                                         print(onChangedVal.toString());

//                                         setState(() {
//                                           provinces = provincesMaster
//                                               .where(
//                                                 (provincesItem) =>
//                                                     provincesItem["regionCode"]
//                                                         .toString() ==
//                                                     onChangedVal.toString(),
//                                               )
//                                               .toList();

//                                           provincesId = null;
//                                           citiesId = null;
//                                         });
//                                       },
//                                       (onValidateVal) {
//                                         if (onValidateVal == null) {
//                                           return "Please select Region";
//                                         }

//                                         return null;
//                                       },
//                                       optionLabel: "regDesc",
//                                       optionValue: "regCode",
//                                       labelBold: false,
//                                       labelFontSize: 14,
//                                       borderFocusColor: Colors.blue,
//                                       borderColor: Colors.grey,
//                                       borderRadius: 10,
//                                     ),
//                                     FormHelper.dropDownWidgetWithLabel(
//                                       context,
//                                       "Province",
//                                       "Select Province",
//                                       // widget.patient[0]["prehospital"]["provincesID"],
//                                       provincesId,
//                                       provinces,
//                                       (onChangedVal) {
//                                         provincesId = onChangedVal;
//                                         debugPrint(
//                                             "Selected Province: $onChangedVal");

//                                         setState(() {
//                                           cities = citiesMaster
//                                               .where(
//                                                 (citiesItem) =>
//                                                     citiesItem["provCode"]
//                                                         .toString() ==
//                                                     onChangedVal.toString(),
//                                               )
//                                               .toList();

//                                           citiesId = null;
//                                         });
//                                       },
//                                       (onValidate) {
//                                         return null;
//                                       },
//                                       optionLabel: "provDesc",
//                                       optionValue: "provCode",
//                                       labelBold: false,
//                                       labelFontSize: 14,
//                                       borderFocusColor: Colors.blue,
//                                       borderColor: Colors.grey,
//                                       borderRadius: 10,
//                                     ),
//                                     FormHelper.dropDownWidgetWithLabel(
//                                       context,
//                                       "City/Municipality",
//                                       "Select City/Municipality",
//                                       // widget.patient[0]["prehospital"]["citiesID"],
//                                       citiesId,
//                                       cities,
//                                       (onChangedVal) {
//                                         citiesId = onChangedVal;
//                                         debugPrint(
//                                             "Selected Province: $onChangedVal");
//                                       },
//                                       (onValidate) {
//                                         return null;
//                                       },
//                                       optionLabel: "citymunDesc",
//                                       optionValue: "citymunCode",
//                                       labelBold: false,
//                                       labelFontSize: 14,
//                                       borderFocusColor: Colors.blue,
//                                       borderColor: Colors.grey,
//                                       borderRadius: 10,
//                                     ),
//                                   ]),
//                                 )),
//                           ),

//                           // placeOfAccident()
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   dateTimeInjury(),
//                                   injuryIntent(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   firstAidGiven(),
//                                   Visibility(
//                                       visible: visibleFirstAidGiven,
//                                       child: condFirstAiderDetails()),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   natureInjury(),
//                                   externalCauseInjury(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   vehicularAccidentTF(),
//                                   Visibility(
//                                       visible: visibleVehicularAccident,
//                                       child: condVehicularAccident()),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   activityDuringInjury(),
//                                   safetyIssue(),
//                                 ])),
//                           ),

//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   medicolegalTF(),
//                                   Visibility(
//                                       visible: visibleMedicolegal,
//                                       child: condMedicolegal()),
//                                 ])),
//                           ),
//                         ],
//                       )),
//                     ),
//                   ),

//                   // ER Data
//                   Scaffold(
//                     // persistentFooterButtons: [buttonNav(context)],
//                     body: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SingleChildScrollView(
//                           child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   patientTransferred(),
//                                   Visibility(
//                                       visible: visibleTransferDetails,
//                                       child: condTransferDetails()),
//                                 ])),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   statusOnArrival(),
//                                   Visibility(
//                                       visible: visiblePatientArrivalStatus,
//                                       child: condArrivalStatus()),
//                                 ])),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   modeOfTransport(),
//                                   initialImpressions(),
//                                 ])),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   surgicalTF(),
//                                   Visibility(
//                                       visible: visibleOutrightSurgery,
//                                       child: condSurgicalDetails()),
//                                 ])),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 4.0, horizontal: 0),
//                             child: Card(
//                                 elevation: 5,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 color: Colors.white,
//                                 child: Column(children: [
//                                   patientDisposition(),
//                                 ])),
//                           ),
//                         ],
//                       )),
//                     ),
//                   ),

//                   // Surgery Data
//                   Scaffold(
//                     persistentFooterButtons: () {
//                       if (globals.department == "Surgery Staff") {
//                         return [buttonRow(context)];
//                       } else {
//                         return <Widget>[];
//                       }
//                     }(),
//                     body: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: SingleChildScrollView(
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Flexible(child: surgeryBoolean()),

//                             // Expanded(
//                             //   flex: 1,
//                             //   child: ElevatedButton(
//                             //     child: const Text("Add Surgery Data"),
//                             //     onPressed: () {
//                             //       _formKey.currentState!.save();
//                             //       if (_formKey.currentState!.value["forSurgery"] == "Yes"){
//                             //         return addSurgeryWidget();
//                             //       } else{
//                             //         return null;
//                             //       }
//                             //     })
//                             // ),

//                             Flexible(
//                               child: ListView.builder(
//                                   shrinkWrap: true,
//                                   physics: NeverScrollableScrollPhysics(),
//                                   itemCount: surgeryCardList.length,
//                                   itemBuilder: (context, index) {
//                                     return surgeryCardList[index];
//                                   }),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     floatingActionButton: FloatingActionButton(
//                       onPressed: () {
//                         _formKey.currentState!.save();
//                         if (_formKey.currentState!.value["forSurgery"] ==
//                             "yes") {
//                           return addSurgeryWidget();
//                         } else {
//                           return null;
//                         }
//                       },
//                       tooltip: 'Add',
//                       child: Icon(Icons.add),
//                     ),
//                   ),

//                   // In-Hospital Data

//                   Scaffold(
//                       persistentFooterButtons: () {
//                         if (globals.department == "In-Hospital Staff") {
//                           return [buttonRow(context)];
//                         } else {
//                           return <Widget>[];
//                         }
//                       }(),
//                       floatingActionButton: FloatingActionButton(
//                           tooltip: 'Add',
//                           child: const Icon(Icons.add),
//                           onPressed: () {
//                             return addInreferralsWidget(context);
//                           }),
//                       body: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Center(
//                             child: SingleChildScrollView(
//                           child: Column(children: [
//                             const Padding(
//                               padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
//                               child: Text(
//                                 'Patient Comorbidities',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             comorbidityTemplate(context),
//                             const Padding(
//                               padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
//                               child: Text(
//                                 'Patient Hospital Events',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             //     SizedBox(
//                             // // you may want to use an aspect ratio here for tablet support
//                             //       height: heightScreen * 0.95,
//                             //       width: widthScreen,
//                             //       child: PageView.builder(
//                             //         // store this controller in a State to save the carousel scroll position
//                             //         controller: PageController(viewportFraction: 0.9),
//                             //         itemCount: hospitalEventList.length,
//                             //           itemBuilder: (context,index){
//                             //         return hospitalEventList[index];
//                             //       }),
//                             //     ),
//                             hospitalEventTemplate(context),
//                             const Padding(
//                               padding: EdgeInsets.fromLTRB(8, 16, 8, 0),
//                               child: Text(
//                                 'Patient In-Referrals',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             SizedBox(
//                               // you may want to use an aspect ratio here for tablet support
//                               height: 200.0,
//                               width: widthScreen,
//                               child: PageView.builder(
//                                   // store this controller in a State to save the carousel scroll position
//                                   controller:
//                                       PageController(viewportFraction: 0.9),
//                                   itemCount: inreferralsList.length,
//                                   itemBuilder: (context, index) {
//                                     return inreferralsList[index];
//                                   }),
//                             ),
//                           ]),
//                         )),
//                       )),

//                   // Discharge Data
//                   Scaffold(
//                       persistentFooterButtons: [buttonRow(context)],
//                       body: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Center(
//                               child: SingleChildScrollView(
//                             child: Column(
//                               children: [
//                                 treatmentCompleted(context),
//                                 icdCodeAndDiagnosis(context),
//                                 dischargeDisposition(context)
//                               ],
//                             ),
//                           )))),
//                 ],
//               ),
//               autovalidateMode: AutovalidateMode.onUserInteraction)),
//     );
//   }
// }
