import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/screens/_screens.dart';
import 'package:dashboard/screens/widgets/bottomnavbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/models/_models.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Map<String, dynamic>> _myPhase = [];
  final List<Map<String, dynamic>> _otherPhases = [];
  final List<Map<String, dynamic>> _oldPhases = [];
  final Map<String, int> _hospitalStatus = {
    'total': 0,
    'er': 0,
    'sur_pen': 0,
    'in': 0,
    'sur': 0,
    'dis_pen': 0,
  };

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  String? _hospitalID;
  String? _role;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserData();
    });
  }

  void _initializeUserData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      _hospitalID = userProvider.hospitalID;
      _role = userProvider.role;
    });
    print(
        '------------ Initializing HomePage for hospital: $_hospitalID with role: $_role ------------');
    _setupFirestoreStream();
  }

  void _setupFirestoreStream() {
    if (_hospitalID == null) return;

    _subscription = FirebaseFirestore.instance
        .collection('records')
        .where('hospitalID', isEqualTo: _hospitalID)
        .snapshots()
        .listen(
          _handleSnapshot,
          onError: (error) => print('Firestore stream error: $error'),
        );
  }

  void _handleSnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) {
    if (!mounted) return;

    setState(() {
      _resetData();
      for (var doc in snapshot.docs) {
        _processRecord(doc.data());
      }
    });
  }

  void _resetData() {
    _hospitalStatus.updateAll((key, value) => 0);
    _myPhase.clear();
    _oldPhases.clear();
    _otherPhases.clear();
  }

  void _processRecord(Map<String, dynamic> record) {
    final currentRecord = getRecord(record);
    _updateHospitalStatus(currentRecord['patientStatus']);
    _categorizeRecord(currentRecord, record);
  }

  void _updateHospitalStatus(String status) {
    _hospitalStatus['total'] = _hospitalStatus['total']! + 1;

    switch (status) {
      case 'Emergency Room':
        _hospitalStatus['er'] = _hospitalStatus['er']! + 1;
        break;
      case 'Pending Surgery':
        _hospitalStatus['sur_pen'] = _hospitalStatus['sur_pen']! + 1;
        break;
      case 'In-Surgery':
        _hospitalStatus['in'] = _hospitalStatus['in']! + 1;
        _hospitalStatus['sur'] = _hospitalStatus['sur']! + 1;
        break;
      case 'In-Hospital':
        _hospitalStatus['in'] = _hospitalStatus['in']! + 1;
        break;
      case 'Pending Discharge':
        _hospitalStatus['dis_pen'] = _hospitalStatus['dis_pen']! + 1;
        break;
      default:
        _hospitalStatus['total'] = _hospitalStatus['total']! - 1;
    }
  }

  void _categorizeRecord(
      Map<String, dynamic> currentRecord, Map<String, dynamic> rawRecord) {
    if (_role == null) return;

    final status = currentRecord['patientStatus'];
    final record = {'parsed': currentRecord, 'unparsed': rawRecord};

    if (_isInMyPhase(status)) {
      _myPhase.add(record);
      return;
    }

    if (status == 'Discharged' || status == 'Deceased') {
      _oldPhases.add(record);
    } else {
      _otherPhases.add(record);
    }
  }

  bool _isInMyPhase(String status) {
    return (_role == 'ER Staff' && status == 'Emergency Room') ||
        (_role == 'Surgery Staff' &&
            (status == 'Pending Surgery' || status == 'In-Surgery')) ||
        (_role == 'In-Hospital Staff' && status == 'In-Hospital') ||
        (_role == 'Discharge Staff' && status == 'Pending Discharge');
  }

  Widget _buildContent() {
    if (_role == null || _hospitalID == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return IndexedStack(
      index: _currentIndex,
      children: [
        HomeScreen(status: _hospitalStatus),
        (_role == 'Pre-Hospital Staff')
            ? OtherRecords(otherRecords: _otherPhases, isSolo: true)
            : RecordsScreen(
                myRecords: _myPhase,
                otherRecords: _otherPhases,
              ),
        HistoryScreen(historyPhase: _oldPhases),
        const ProfileScreen(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _buildContent(),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
