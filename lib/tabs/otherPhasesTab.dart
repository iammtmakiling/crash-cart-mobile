// import 'dart:async';
// import 'dart:convert';
// import 'package:dashboard/core/utils/helper_utils.dart';
// import 'package:flutter/material.dart';
// import '../../core/api_requests/_api.dart';
// import 'package:form_builder_validators/localization/l10n.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import '../globals.dart';
// import '../widgets/widgets.dart';

// // ignore: camel_case_types
// class otherPhasesTab extends StatelessWidget {
//   final List<Map<String, dynamic>> otherPhase;
//   final bool isSolo;
//   const otherPhasesTab(
//       {super.key, required this.otherPhase, required this.isSolo});

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
//       // title: 'Add Patient',
//       theme: ThemeData(
//           primarySwatch: Colors.cyan,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//           textTheme: GoogleFonts.poppinsTextTheme().apply(
//             bodyColor: Colors.black,
//             fontSizeFactor: 1.0,
//             decoration: TextDecoration.none,
//           )),
//       home: OtherPhasesTab(otherPhases: otherPhase, isSolo: isSolo),
//     );
//   }
// }

// class OtherPhasesTab extends StatefulWidget {
//   final bool isSolo;
//   final List<Map<String, dynamic>> otherPhases;
//   const OtherPhasesTab(
//       {super.key, required this.otherPhases, required this.isSolo});

//   @override
//   OtherPhasesTabState createState() => OtherPhasesTabState();
// }

// class OtherPhasesTabState extends State<OtherPhasesTab> {
//   final TextEditingController searchController = TextEditingController();
//   List<Map<String, dynamic>> processedPatients = [];
//   List<dynamic> filteredPatients = [];
//   int currentPage = 1;
//   int itemsPerPage = 5;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchPatients();
//   }

//   Future<void> fetchPatients() async {
//     try {
//       List<Future<Map<String, dynamic>>> fetchTasks = [];

//       // Prepare fetch tasks for each patient
//       for (var patient in widget.otherPhases) {
//         Map<String, dynamic> parsedPatient = patient['parsed'];
//         var patientID = encryp(parsedPatient['patientID']);
//         String encodedpatientID = base64.encode(utf8.encode(patientID));
//         fetchTasks.add(getPatientDetails(encodedpatientID, bearerToken));
//       }

//       // Execute fetch tasks in parallel
//       List<Map<String, dynamic>> fetchedPatients =
//           await Future.wait(fetchTasks);

//       // Process fetched data
//       for (int i = 0; i < fetchedPatients.length; i++) {
//         Map<String, dynamic> temp = fetchedPatients[i];
//         String fullName = "${temp["general"]['firstName']}. ";
//         if (temp["general"]['middleName'] != null &&
//             temp["general"]['middleName'].isNotEmpty) {
//           fullName += "${temp["general"]['middleName'][0]}. ";
//         }
//         fullName += "${temp["general"]['lastName']}";
//         if (temp["general"]["suffix"] != null &&
//             temp["general"]["suffix"].isNotEmpty) {
//           fullName += " ${temp["general"]["suffix"]}";
//         }
//         Map<String, dynamic> processedPatient = {
//           "record": widget.otherPhases[i]['parsed'],
//           "unparsedRecord": widget.otherPhases[i]['unparsed'],
//           "fullName": fullName,
//           "patientID": widget.otherPhases[i]['patientID'],
//           "general": temp['general'],
//         };
//         processedPatients.add(processedPatient);
//       }

//       setState(() {
//         filteredPatients = processedPatients;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   void filterPatients(String query) {
//     List<dynamic> filteredList = processedPatients
//         .where((patient) {
//           String fullName = (patient["fullName"] ?? "").toLowerCase();
//           String patientID =
//               (patient["record"]["patientID"] ?? "").toLowerCase();
//           String lowercaseQuery = query.toLowerCase();

//           return fullName.contains(lowercaseQuery) ||
//               patientID.contains(lowercaseQuery);
//         })
//         .toSet()
//         .toList();

//     setState(() {
//       filteredPatients = filteredList;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       child: Center(
//         child: Column(
//           children: [
//             if (widget.isSolo) const MiniAppBar(),
//             const SizedBox(height: 10),
//             if (role == "Pre-Hospital Staff")
//               const Row(
//                 children: [
//                   SizedBox(width: 24),
//                   Text(
//                     "Others",
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                         fontSize: 18,
//                         color: Colors.black54,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Center(
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const SizedBox(height: 10),
//                           SearchTextField(
//                             controller: searchController,
//                             onChanged: (value) {
//                               filterPatients(value);
//                             },
//                           ),
//                           const SizedBox(height: 10),
//                           if (!isLoading)
//                             Text(
//                               '${filteredPatients.length} Searches',
//                               textAlign: TextAlign.start,
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           const SizedBox(height: 20),
//                         ]),
//                   ),
//                 ),
//               ],
//             ),
//             isLoading
//                 ? const Expanded(
//                     child: Center(
//                       child: CircularProgressIndicator(),
//                     ),
//                   )
//                 : Expanded(
//                     child: filteredPatients.isEmpty
//                         ? const Center(
//                             child: Text(
//                               'No patients found',
//                               style: TextStyle(fontSize: 18.0),
//                             ),
//                           )
//                         : ListView.builder(
//                             key: UniqueKey(),
//                             itemCount: filteredPatients.length,
//                             padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
//                             itemBuilder: (context, index) {
//                               return PatientBox(
//                                 key: UniqueKey(),
//                                 patient: filteredPatients[index],
//                                 viewMoreStatus: false,
//                               );
//                             },
//                           ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
