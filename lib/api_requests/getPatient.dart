import 'dart:convert';
import 'dart:io';
import 'package:dashboard/globals.dart';
import 'package:dashboard/models/recordModel.dart';
import '../models/patientModel.dart';
import "package:http/http.dart" as http;

/// Retrieves details of a patient from the trauma registry.
///
/// Sends a GET request to the trauma registry API to retrieve details of a patient
/// with the provided record ID, using the provided bearer token for authorization.
///
/// Returns a Future containing a Map with the patient details if the request is successful,
/// or the response JSON otherwise.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<Map<String, dynamic>> getPatientDetails(
    String recordID, String bearerToken) async {
  try {
    final response = await http.get(
      Uri.parse(
          "https://ph-trauma-registry.onrender.com/api/patients/$recordID"),
      headers: {HttpHeaders.authorizationHeader: "Bearer $bearerToken"},
    );

    Map<String, dynamic> responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Parse patient details if response is successful
      return parsePatient(responseJson['patient']);
    }

    // Return response JSON if request is not successful
    return responseJson;
  } catch (e) {
    // Throw exception if an error occurs during the HTTP request
    throw Exception('Error getting patient details: $e');
  }
}

/// Retrieves details of current patients in a hospital from the trauma registry.
///
/// Sends a GET request to the trauma registry API to retrieve details of current patients
/// in the hospital identified by the provided hospital ID, using the provided bearer token
/// for authorization.
///
/// Returns a Future containing a List of Maps representing current patient details
/// if the request is successful.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<List<Map<String, dynamic>>> getCurrentPatients(
    String hospitalID, String bearerToken) async {
  try {
    final response = await http.get(
      Uri.parse(
          "https://ph-trauma-registry.onrender.com/api/hfs/$hospitalID/records"),
      headers: {HttpHeaders.authorizationHeader: "Bearer $bearerToken"},
    );

    if (response.statusCode == 200) {
      // Parse records if response is successful
      List<Map<String, dynamic>> parsedRecords = [];
      List<dynamic> records = jsonDecode(response.body);

      for (var record in records) {
        parsedRecords.add(parseRecord(record));
      }

      return parsedRecords;
    } else {
      // Throw exception if request is not successful
      throw Exception('Failed to load data');
    }
  } catch (e) {
    // Throw exception if an error occurs during the HTTP request
    throw Exception('Error: $e');
  }
}

/// Retrieves patient information from the trauma registry for a specific hospital.
///
/// Sends a GET request to the trauma registry API to retrieve patient information
/// for the specified hospital ID, using the provided bearer token for authorization.
///
/// Returns a Future containing a Map with categorized patient data and hospital status
/// if the request is successful.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<Map<String, Object>> getHospitalPatients(
    String hospitalID, String bearerToken) async {
  try {
    final response = await http.get(
      Uri.parse(
          "https://ph-trauma-registry.onrender.com/api/hfs/$hospitalID/records"),
      headers: {HttpHeaders.authorizationHeader: "Bearer $bearerToken"},
    );

    if (response.statusCode == 200) {
      List<dynamic> records = jsonDecode(response.body);

      List<Map<String, dynamic>> myPhase = [];
      List<Map<String, dynamic>> otherPhases = [];
      List<Map<String, dynamic>> oldPhases = [];
      Map<String, dynamic> hospitalStatus = {
        "total": 0,
        "er": 0,
        "sur_pen": 0,
        "in": 0,
        "sur": 0,
        "dis_pen": 0
      };

      await Future.forEach(records, (record) {
        Map<String, dynamic> currentRecord = parseRecord(record);

        // Increment status counts
        hospitalStatus['total']++;
        if (currentRecord['patientStatus'] == "Emergency Room") {
          hospitalStatus['er']++;
        } else if (currentRecord['patientStatus'] == "Pending Surgery") {
          hospitalStatus['sur_pen']++;
        } else if (currentRecord['patientStatus'] == "In-Surgery" ||
            currentRecord['patientStatus'] == "In-Hospital") {
          hospitalStatus['in']++;
          if (currentRecord['patientStatus'] == "In-Surgery") {
            hospitalStatus['sur']++;
          }
        } else if (currentRecord['patientStatus'] == "Pending Discharge") {
          hospitalStatus['dis_pen']++;
        } else {
          hospitalStatus['total']--;
        }

        // Categorize patients based on role
        if ((role == "ER Staff" &&
                currentRecord['patientStatus'] == "Emergency Room") ||
            (role == "Surgery Staff" &&
                (currentRecord['patientStatus'] == "Pending Surgery" ||
                    currentRecord['patientStatus'] == "In-Surgery")) ||
            (role == "In-Hospital Staff" &&
                currentRecord['patientStatus'] == "In-Hospital") ||
            (role == "Discharge Staff" &&
                currentRecord['patientStatus'] == "Pending Discharge")) {
          myPhase.add({
            "parsed": currentRecord,
            "unparsed": record,
          });
        } else {
          if (currentRecord['patientStatus'] == "Discharged" ||
              currentRecord['patientStatus'] == "Deceased") {
            oldPhases.add({
              "parsed": currentRecord,
              "unparsed": record,
            });
          } else {
            otherPhases.add({
              "parsed": currentRecord,
              "unparsed": record,
            });
          }
        }
      });

      return {
        'myPhase': myPhase,
        'otherPhases': otherPhases,
        'oldPhases': oldPhases,
        'hospitalStatus': hospitalStatus,
      };
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

// Future<Map<String, dynamic>> getPatientDetails(
//     String recordID, String bearerToken) async {
//   final response = await http.get(
//       Uri.parse(
//           "https://ph-trauma-registry.onrender.com/api/patients/$recordID"),
//       headers: {HttpHeaders.authorizationHeader: "Bearer $bearerToken"});

//   Map<String, dynamic> responseJson = jsonDecode(response.body);
//   if (response.statusCode == 200) {
//     Map<String, dynamic> parsedPatient = parsePatient(responseJson['patient']);
//     return parsedPatient;
//   }
//   return responseJson;
// }

// Future<List<dynamic>> getCurrentPatients(
//     String hospitalID, String bearerToken) async {
//   // print("Hospital ID: $hospitalID");
//   try {
//     final response = await http.get(
//         Uri.parse(
//             "https://ph-trauma-registry.onrender.com/api/hfs/$hospitalID/records"),
//         headers: {HttpHeaders.authorizationHeader: "Bearer $bearerToken"});

//     if (response.statusCode == 200) {
//       List<Map<String, dynamic>> parsedRecords = [];
//       List<dynamic> records = jsonDecode(response.body);

//       for (var record in records) {
//         parsedRecords.add(parseRecord(record));
//       }

//       return parsedRecords;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     throw Exception('Error: $e');
//   }
// }

//Get all patients in the hospital
// - Includes getting hospital status
// - Separate patients to my phase, other phases, discharged and deceased phases

// Future<Map<String, Object>> getHospitalPatients(
//     String hospitalID, String bearerToken) async {
//   try {
//     final response = await http.get(
//         Uri.parse(
//             "https://ph-trauma-registry.onrender.com/api/hfs/$hospitalID/records"),
//         headers: {HttpHeaders.authorizationHeader: "Bearer $bearerToken"});

//     if (response.statusCode == 200) {
//       List<Map<String, dynamic>> myPhase = [];
//       List<Map<String, dynamic>> otherPhases = [];
//       List<Map<String, dynamic>> oldPhases = [];
//       Map<String, dynamic> hospitalStatus = {
//         "total": 0, //Total Patients
//         "pre": 0, //PreHospital
//         "er": 0, //Emergency Room
//         "sur_pen": 0, //Pending for Surgery
//         "in": 0, //In Hospital
//         "sur": 0, //In Surgery
//         "dis_pen": 0 //Pending for Discharge
//       };
//       List<dynamic> records = jsonDecode(response.body);

//       for (var record in records) {
//         Map<String, dynamic> currentRecord = parseRecord(record);
//         Map<String, dynamic> unParsedRecord = record;

//         hospitalStatus['total'] = hospitalStatus['total'] + 1;
//         if (currentRecord['patientStatus'] == "Emergency Room") {
//           hospitalStatus['er'] = hospitalStatus['er'] + 1;
//         } else if (currentRecord['patientStatus'] == "Pending Surgery") {
//           hospitalStatus['sur_pen'] = hospitalStatus['sur_pen'] + 1;
//         } else if (currentRecord['patientStatus'] == "In-Surgery") {
//           hospitalStatus['sur'] = hospitalStatus['sur'] + 1;
//         } else if (currentRecord['patientStatus'] == "In-Hospital") {
//           hospitalStatus['in'] = hospitalStatus['in'] + 1;
//         } else if (currentRecord['patientStatus'] == "In-Surgery") {
//           hospitalStatus['sur'] = hospitalStatus['sur'] + 1;
//         } else if (currentRecord['patientStatus'] == "Pending Discharge") {
//           hospitalStatus['dis_pen'] = hospitalStatus['dis_pen'] + 1;
//         } else {
//           hospitalStatus['total'] = hospitalStatus['total'] - 1;
//         }

//         if (role == "ER Staff") {
//           if (currentRecord['patientStatus'] == "Emergency Room") {
//             myPhase.add({
//               "parsed": currentRecord,
//               "unparsed": unParsedRecord,
//             });
//           } else {
//             if (currentRecord['patientStatus'] == "Discharged" ||
//                 currentRecord['patientStatus'] == "Deceased") {
//               oldPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             } else {
//               otherPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             }
//           }
//         } else if (role == "Surgery Staff") {
//           if (currentRecord['patientStatus'] == "Pending Surgery" ||
//               currentRecord['patientStatus'] == "In-Surgery") {
//             myPhase.add({
//               "parsed": currentRecord,
//               "unparsed": unParsedRecord,
//             });
//           } else {
//             if (currentRecord['patientStatus'] == "Discharged" ||
//                 currentRecord['patientStatus'] == "Deceased") {
//               oldPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             } else {
//               otherPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             }
//           }
//         } else if (role == "In-Hospital Staff") {
//           if (currentRecord['patientStatus'] == "In-Hospital") {
//             myPhase.add({
//               "parsed": currentRecord,
//               "unparsed": unParsedRecord,
//             });
//           } else {
//             if (currentRecord['patientStatus'] == "Discharged" ||
//                 currentRecord['patientStatus'] == "Deceased") {
//               oldPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             } else {
//               otherPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             }
//           }
//         } else if (role == "Discharge Staff") {
//           if (currentRecord['patientStatus'] == "Pending Discharge") {
//             myPhase.add({
//               "parsed": currentRecord,
//               "unparsed": unParsedRecord,
//             });
//           } else {
//             if (currentRecord['patientStatus'] == "Discharged" ||
//                 currentRecord['patientStatus'] == "Deceased") {
//               oldPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             } else {
//               otherPhases.add({
//                 "parsed": currentRecord,
//                 "unparsed": unParsedRecord,
//               });
//             }
//           }
//         } else {
//           if (currentRecord['patientStatus'] == "Discharged" ||
//               currentRecord['patientStatus'] == "Deceased") {
//             oldPhases.add({
//               "parsed": currentRecord,
//               "unparsed": unParsedRecord,
//             });
//           } else {
//             otherPhases.add({
//               "parsed": currentRecord,
//               "unparsed": unParsedRecord,
//             });
//           }
//         }
//       }

//       return {
//         'myPhase': myPhase,
//         'otherPhases': otherPhases,
//         'oldPhases': oldPhases,
//         'hospitalStatus': hospitalStatus,
//       };
//     } else {
//       throw Exception('Failed to load data');
//     }
//   } catch (e) {
//     throw Exception('Error: $e');
//   }
// }

Future<List<dynamic>> getPatients(String bearerToken) async {
  try {
    final response = await http.get(
        Uri.parse("https://ph-trauma-registry.onrender.com/api/patients/"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $bearerToken"});

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> parsedRecords = [];
      List<dynamic> records = jsonDecode(response.body);
      for (var record in records) {
        Map<String, dynamic> patientRecord = parsePatient(record);
        parsedRecords.add(patientRecord);
      }

      return parsedRecords;
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}
