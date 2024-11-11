// import 'dart:async';
// import 'dart:convert';
// import 'package:dashboard/core/utils/helper_utils.dart';
// import 'package:flutter/material.dart';
// import '../../core/api_requests/_api.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:intl/date_symbol_data_local.dart';
// import '../globals.dart';
// import '../widgets/widgets.dart';
// import 'package:google_fonts/google_fonts.dart';

// // ignore: camel_case_types
// class myPhaseTab extends StatelessWidget {
//   final List<Map<String, dynamic>> myPhase;
//   final bool isSolo;
//   const myPhaseTab({super.key, required this.myPhase, required this.isSolo});

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
//       home: MyPhaseTab(myPhase: myPhase, isSolo: isSolo),
//     );
//   }
// }

// class MyPhaseTab extends StatefulWidget {
//   final List<Map<String, dynamic>> myPhase;
//   final bool isSolo;
//   const MyPhaseTab({super.key, required this.myPhase, required this.isSolo});

//   @override
//   MyPhaseTabState createState() => MyPhaseTabState();
// }

// class MyPhaseTabState extends State<MyPhaseTab> {
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
//       for (var patient in widget.myPhase) {
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
//           "record": widget.myPhase[i]['parsed'],
//           "unparsedRecord": widget.myPhase[i]['unparsed'],
//           "fullName": fullName,
//           "patientID": widget.myPhase[i]['patientID'],
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
//     return SafeArea(
//       child: Material(
//         child: Center(
//           child: Column(
//             children: [
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 10),
//                             SearchTextField(
//                               controller: searchController,
//                               onChanged: (value) {
//                                 filterPatients(value);
//                               },
//                             ),
//                             const SizedBox(height: 10),
//                             if (!isLoading)
//                               Text(
//                                 '${filteredPatients.length} Searches',
//                                 textAlign: TextAlign.start,
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             const SizedBox(height: 20),
//                           ]),
//                     ),
//                   ),
//                 ],
//               ),
//               isLoading
//                   ? const Expanded(
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     )
//                   : Expanded(
//                       child: filteredPatients.isEmpty
//                           ? const Center(
//                               child: Text(
//                                 'No patients found',
//                                 style: TextStyle(fontSize: 18.0),
//                               ),
//                             )
//                           : ListView.builder(
//                               key: UniqueKey(),
//                               itemCount: filteredPatients.length,
//                               itemBuilder: (context, index) {
//                                 return PatientBox(
//                                   key: UniqueKey(),
//                                   patient: filteredPatients[index],
//                                   viewMoreStatus: false,
//                                 );
//                               },
//                             ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }
// }
