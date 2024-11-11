// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:dashboard/core/provider/user_provider.dart';
// import 'package:dashboard/screens/_screens.dart';
// import 'package:dashboard/screens/widgets/bottomnavbar.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../core/models/_models.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   HomePageState createState() => HomePageState();
// }

// class HomePageState extends State<HomePage> {
//   int _currentIndex = 0;
//   final List<Map<String, dynamic>> _myRecords = [];
//   final List<Map<String, dynamic>> _otherRecords = [];
//   final List<Map<String, dynamic>> _oldRecords = [];
//   List<DocumentSnapshot> _documents = [];
//   final Map<String, int> _hospitalStatus = {
//     "total": 0,
//     "er": 0,
//     "sur_pen": 0,
//     "in": 0,
//     "sur": 0,
//     "dis_pen": 0,
//     "dis": 0,
//   };

//   late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
//       _subscription;
//   late final UserProvider _userProvider;

//   @override
//   void initState() {
//     super.initState();
//     _userProvider = Provider.of<UserProvider>(context, listen: false);
//     _initializeFirestoreStream();
//   }

//   void _initializeFirestoreStream() {
//     print(
//         'Initializing Firestore stream for hospital: ${_userProvider.hospitalID}');

//     _subscription = FirebaseFirestore.instance
//         .collection('records')
//         .where('hospitalID', isEqualTo: _userProvider.hospitalID)
//         .snapshots()
//         .listen(_handleSnapshot,
//             onError: (error) => print('Firestore stream error: $error'));
//   }

//   void _handleSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
//     if (!mounted) return;

//     setState(() {
//       _documents = snapshot.docs;
//       _updateHospitalData();
//     });
//     print('Processed ${_documents.length} records');
//   }

//   void _updateHospitalData() {
//     _resetHospitalStatus();
//     _clearAllPhases();

//     for (var document in _documents) {
//       final record = document.data() as Map<String, dynamic>?;
//       if (record == null) continue;

//       final currentRecord = parseRecord(record);
//       _updateHospitalStatus(currentRecord);
//       _categorizePatient(currentRecord, record);
//     }

//     print('Hospital Status: $_hospitalStatus');
//   }

//   void _resetHospitalStatus() {
//     _hospitalStatus.updateAll((key, value) => 0);
//   }

//   void _clearAllPhases() {
//     _myRecords.clear();
//     _oldRecords.clear();
//     _otherRecords.clear();
//   }

//   void _updateHospitalStatus(Map<String, dynamic> record) {
//     final status = record['patientStatus'] as String?;
//     if (status == null) return;

//     if (status != 'Discharged' && status != 'Deceased') {
//       _hospitalStatus['total'] = _hospitalStatus['total']! + 1;
//     }

//     final statusMapping = {
//       'Emergency Room': () {
//         _hospitalStatus['er'] = _hospitalStatus['er']! + 1;
//       },
//       'Pending Surgery': () {
//         _hospitalStatus['sur_pen'] = _hospitalStatus['sur_pen']! + 1;
//       },
//       'In-Surgery': () {
//         _hospitalStatus['in'] = _hospitalStatus['in']! + 1;
//         _hospitalStatus['sur'] = _hospitalStatus['sur']! + 1;
//       },
//       'In-Hospital': () {
//         _hospitalStatus['in'] = _hospitalStatus['in']! + 1;
//       },
//       'Pending Discharge': () {
//         _hospitalStatus['dis_pen'] = _hospitalStatus['dis_pen']! + 1;
//       }
//     };

//     statusMapping[status]?.call();

//     print(
//         'Updated hospital status - Active patients: ${_hospitalStatus["total"]}');
//   }

//   void _categorizePatient(
//       Map<String, dynamic> currentRecord, Map<String, dynamic> record) {
//     final recordData = {"parsed": currentRecord, "unparsed": record};

//     if (_isMyPhaseRecord(currentRecord['patientStatus'])) {
//       _myRecords.add(recordData);
//       return;
//     }

//     if (['Discharged', 'Deceased'].contains(currentRecord['patientStatus'])) {
//       _oldRecords.add(recordData);
//     } else {
//       _otherRecords.add(recordData);
//     }
//     print("oldRecords: ${_oldRecords.length}");
//     print("otherRecords: ${_otherRecords.length}");
//   }

//   bool _isMyPhaseRecord(String status) {
//     final roleStatusMap = {
//       "ER Staff": ["Emergency Room"],
//       "Surgery Staff": ["Pending Surgery", "In-Surgery"],
//       "In-Hospital Staff": ["In-Hospital"],
//       "Discharge Staff": ["Pending Discharge"],
//     };

//     return roleStatusMap[_userProvider.role]?.contains(status) ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: _buildAppBar(),
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         body: _buildBody(),
//         bottomNavigationBar: BottomNavBar(
//           currentIndex: _currentIndex,
//           onTap: (index) => setState(() => _currentIndex = index),
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar() {
//     return AppBar(
//       title: const Text('Home Page'),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.refresh, color: Colors.cyan),
//           onPressed: _initializeFirestoreStream,
//         ),
//       ],
//     );
//   }

//   Widget _buildBody() {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: FirebaseFirestore.instance
//           .collection('records')
//           .where('hospitalID', isEqualTo: _userProvider.hospitalID)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }

//         return _buildPageContent();
//       },
//     );
//   }

//   Widget _buildPageContent() {
//     return IndexedStack(
//       index: _currentIndex,
//       children: [
//         HomeScreen(status: _hospitalStatus),
//         _userProvider.role == "Pre-Hospital Staff"
//             ? OtherRecords(otherRecords: _otherRecords, isSolo: true)
//             : RecordsScreen(
//                 myRecords: _myRecords,
//                 otherRecords: _otherRecords,
//               ),
//         HistoryScreen(historyPhase: _oldRecords),
//         const ProfileScreen(),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
