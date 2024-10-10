import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/models/recordModel.dart';
import 'package:flutter/material.dart';
import '../tabs/tabs.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> myPhase = [];
  List<Map<String, dynamic>> otherPhases = [];
  List<Map<String, dynamic>> oldPhases = [];
  List<DocumentSnapshot> _documents = [];
  Map<String, dynamic> hospitalStatus = {
    "total": 0,
    "er": 0,
    "sur_pen": 0,
    "in": 0,
    "sur": 0,
    "dis_pen": 0
  };
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = FirebaseFirestore.instance
        .collection('records')
        .where('hospitalID', isEqualTo: hospitalID)
        .snapshots()
        .listen(
      (snapshot) {
        if (mounted) {
          setState(() {
            _documents = snapshot.docs;
            updateLists();
          });
        }
      },
      onError: (error) {
        // Handle stream error
        print('Stream error: $error');
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void updateLists() {
    hospitalStatus = {
      'total': 0,
      'er': 0,
      'sur_pen': 0,
      'in': 0,
      'sur': 0,
      'dis_pen': 0,
    };
    myPhase.clear();
    oldPhases.clear();
    otherPhases.clear();

    for (var document in _documents) {
      Map<String, dynamic>? record = document.data() as Map<String, dynamic>?;
      if (record == null) continue;

      Map<String, dynamic> currentRecord = parseRecord(record);

      hospitalStatus['total']++;
      switch (currentRecord['patientStatus']) {
        case 'Emergency Room':
          hospitalStatus['er']++;
          break;
        case 'Pending Surgery':
          hospitalStatus['sur_pen']++;
          break;
        case 'In-Surgery':
          hospitalStatus['in']++;
          hospitalStatus['sur']++;
          break;
        case 'In-Hospital':
          hospitalStatus['in']++;
          break;
        case 'Pending Discharge':
          hospitalStatus['dis_pen']++;
          break;
        default:
          hospitalStatus['total']--;
          break;
      }

      categorizePatients(currentRecord, record);
    }
  }

  void categorizePatients(
      Map<String, dynamic> currentRecord, Map<String, dynamic> record) {
    if ((role == "ER Staff" &&
            currentRecord['patientStatus'] == "Emergency Room") ||
        (role == "Surgery Staff" &&
            (currentRecord['patientStatus'] == "Pending Surgery" ||
                currentRecord['patientStatus'] == "In-Surgery")) ||
        (role == "In-Hospital Staff" &&
            currentRecord['patientStatus'] == "In-Hospital") ||
        (role == "Discharge Staff" &&
            currentRecord['patientStatus'] == "Pending Discharge")) {
      myPhase.add({"parsed": currentRecord, "unparsed": record});
    } else {
      if (currentRecord['patientStatus'] == "Discharged" ||
          currentRecord['patientStatus'] == "Deceased") {
        oldPhases.add({"parsed": currentRecord, "unparsed": record});
      } else {
        otherPhases.add({"parsed": currentRecord, "unparsed": record});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('records')
              .where('hospitalID', isEqualTo: hospitalID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
              // } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              //   return const Center(child: Text('No records found.'));
            } else {
              return _buildPage();
            }
          },
        ),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.cyan, Colors.indigo],
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (mounted) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: [
            _buildBottomNavigationBarItem(Icons.home, Icons.home_outlined, 0),
            _buildBottomNavigationBarItem(
                Icons.insert_drive_file, Icons.insert_drive_file_outlined, 1),
            _buildBottomNavigationBarItem(
                Icons.history, Icons.history_outlined, 2),
            _buildBottomNavigationBarItem(
                Icons.person, Icons.person_outline, 3),
          ],
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData activeIcon, IconData inactiveIcon, int index) {
    return BottomNavigationBarItem(
      icon: _currentIndex == index ? Icon(activeIcon) : Icon(inactiveIcon),
      label: '',
    );
  }

  Widget _buildPage() {
    return IndexedStack(
      index: _currentIndex,
      children: [
        HomeTab(status: hospitalStatus),
        (role == "Pre-Hospital Staff")
            ? otherPhasesTab(otherPhase: otherPhases, isSolo: true)
            : StreamTab(
                myPhase: myPhase,
                otherPhases: otherPhases,
              ),
        oldPhaseTab(oldPhase: oldPhases),
        const ProfileTab(),
      ],
    );
  }
}
