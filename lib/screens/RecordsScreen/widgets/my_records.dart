import 'dart:async';
import 'dart:convert';
import 'package:dashboard/core/api_requests/getPatient.dart';
import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'patient_box.dart';

class MyRecords extends StatefulWidget {
  final List<Map<String, dynamic>> myRecords;
  final bool isSolo;
  const MyRecords({super.key, required this.myRecords, required this.isSolo});

  @override
  MyRecordsState createState() => MyRecordsState();
}

class MyRecordsState extends State<MyRecords> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> processedPatients = [];
  List<dynamic> filteredPatients = [];
  int currentPage = 1;
  int itemsPerPage = 5;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPatients();
  }

  Future<void> fetchPatients() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      List<Future<Map<String, dynamic>>> fetchTasks = [];

      // Prepare fetch tasks for each patient
      for (var patient in widget.myRecords) {
        Map<String, dynamic> parsedPatient = patient['parsed'];
        var patientID = encryp(parsedPatient['patientID']);
        String encodedpatientID = base64.encode(utf8.encode(patientID));
        fetchTasks
            .add(getPatientDetails(encodedpatientID, userProvider.bearerToken));
      }

      // Execute fetch tasks in parallel
      List<Map<String, dynamic>> fetchedPatients =
          await Future.wait(fetchTasks);

      // Process fetched data
      for (int i = 0; i < fetchedPatients.length; i++) {
        Map<String, dynamic> temp = fetchedPatients[i];
        String fullName = "${temp["general"]['firstName']}. ";
        if (temp["general"]['middleName'] != null &&
            temp["general"]['middleName'].isNotEmpty) {
          fullName += "${temp["general"]['middleName'][0]}. ";
        }
        fullName += "${temp["general"]['lastName']}";
        if (temp["general"]["suffix"] != null &&
            temp["general"]["suffix"].isNotEmpty) {
          fullName += " ${temp["general"]["suffix"]}";
        }
        Map<String, dynamic> processedPatient = {
          "record": widget.myRecords[i]['parsed'],
          "unparsedRecord": widget.myRecords[i]['unparsed'],
          "fullName": fullName,
          "patientID": widget.myRecords[i]['patientID'],
          "general": temp['general'],
        };
        processedPatients.add(processedPatient);
      }

      // Check if the widget is still mounted before calling setState()
      if (mounted) {
        setState(() {
          filteredPatients = processedPatients;
          isLoading = false;
        });
      }
    } catch (e) {
      // Check if the widget is still mounted before calling setState()
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void filterPatients(String query) {
    List<dynamic> filteredList = processedPatients
        .where((patient) {
          String fullName = (patient["fullName"] ?? "").toLowerCase();
          String patientID =
              (patient["record"]["patientID"] ?? "").toLowerCase();
          String lowercaseQuery = query.toLowerCase();

          return fullName.contains(lowercaseQuery) ||
              patientID.contains(lowercaseQuery);
        })
        .toSet()
        .toList();

    setState(() {
      filteredPatients = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            SearchTextField(
                              controller: searchController,
                              onChanged: (value) {
                                filterPatients(value);
                              },
                            ),
                            const SizedBox(height: 10),
                            if (!isLoading)
                              Text(
                                '${filteredPatients.length} Searches',
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            const SizedBox(height: 20),
                          ]),
                    ),
                  ),
                ],
              ),
              isLoading
                  ? const Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Expanded(
                      child: filteredPatients.isEmpty
                          ? Center(
                              child: Text(
                                'No patients found',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )
                          : ListView.builder(
                              key: UniqueKey(),
                              itemCount: filteredPatients.length,
                              itemBuilder: (context, index) {
                                return PatientBox(
                                  key: UniqueKey(),
                                  patient: filteredPatients[index],
                                  viewMoreStatus: false,
                                  isTile: true,
                                );
                              },
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
