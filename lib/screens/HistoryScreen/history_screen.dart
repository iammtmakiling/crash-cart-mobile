import 'dart:async';
import 'dart:convert';

import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/screens/RecordsScreen/widgets/patient_box.dart';
import 'package:dashboard/widgets/main_appbar.dart';
import 'package:dashboard/widgets/widgets.dart';
import 'package:flutter/material.dart';
import '../../core/api_requests/_api.dart';

class HistoryScreen extends StatefulWidget {
  final List<Map<String, dynamic>> historyPhase;
  const HistoryScreen({super.key, required this.historyPhase});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
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
      List<Future<Map<String, dynamic>>> fetchTasks = [];

      // Prepare fetch tasks for each patient
      for (var patient in widget.historyPhase) {
        Map<String, dynamic> parsedPatient = patient['parsed'];
        var patientID = encryp(parsedPatient['patientID']);
        String encodedpatientID = base64.encode(utf8.encode(patientID));
        fetchTasks.add(getPatientDetails(encodedpatientID, bearerToken));
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
          "record": widget.historyPhase[i]['parsed'],
          "unparsedRecord": widget.historyPhase[i]['unparsed'],
          "fullName": fullName,
          "patientID": widget.historyPhase[i]['patientID'],
          "general": temp['general'],
        };
        processedPatients.add(processedPatient);
      }

      if (mounted) {
        setState(() {
          filteredPatients = processedPatients;
          isLoading = false;
        });
      }
    } catch (e) {
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
    return Material(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: mainAppBar(context, "HISTORY"),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(32, 20, 32, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Expanded(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : filteredPatients.isEmpty
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
