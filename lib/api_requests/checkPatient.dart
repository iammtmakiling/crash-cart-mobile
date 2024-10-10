import 'dart:convert';
import 'dart:io';

import 'package:dashboard/models/patientModel.dart';
import 'package:http/http.dart' as http;

/// Checks if a patient with given details exists in the trauma registry.
///
/// Sends a POST request to the trauma registry API to check if a patient
/// with the provided details exists, using the provided bearer token for authorization.
///
/// [data]: Map containing patient details including first name, last name, middle name,
/// suffix, and birthday.
///
/// [bearerToken]: Bearer token for authorization.
///
/// Returns a Future containing a Map with a boolean indicating whether the patient exists
/// and, if so, the patient details.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<Map<String, dynamic>> checkPatientExist(
    Map<String, dynamic> data, String bearerToken) async {
  try {
    final response = await http.post(
      Uri.parse(
          "https://ph-trauma-registry.onrender.com/api/patients/patient/exists"),
      body: {
        "content": jsonEncode(<String, dynamic>{
          "firstName": data["firstName"],
          "lastName": data["lastName"],
          "middleName": data["middleName"],
          "suffix": data["suffix"],
          "birthday": data["birthday"]
        })
      },
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      },
    );

    Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    // If patient exists, return patient details
    if (decodedResponse['message'] != false) {
      return {
        "ifExist": decodedResponse['message'],
        "patient": parsePatient(decodedResponse['details'])
      };
    } else {
      // If patient does not exist, return false
      return {"ifExist": false};
    }
  } catch (e) {
    // Throw exception if an error occurs during the HTTP request
    throw Exception('Error checking patient existence: $e');
  }
}

// import 'dart:convert';
// import 'dart:io';

// import 'package:dashboard/models/patientModel.dart';
// import "package:http/http.dart" as http;

// Future<Map<String, dynamic>> checkPatientExist(
//     Map<String, dynamic> data, String bearerToken) async {
//   final response = await http.post(
//       Uri.parse(
//           "https://ph-trauma-registry.onrender.com/api/patients/patient/exists"),
//       body: {
//         "content": jsonEncode(<String, dynamic>{
//           "firstName": data["firstName"],
//           "lastName": data["lastName"],
//           "middleName": data["middleName"],
//           "suffix": data["suffix"],
//           "birthday": data["birthday"]
//         })
//       },
//       headers: {
//         HttpHeaders.authorizationHeader: "Bearer $bearerToken",
//       });

//   Map<String, dynamic> decodedResponse = jsonDecode(response.body);
//   if (decodedResponse['message'] != false) {
//     return {
//       "ifExist": decodedResponse['message'],
//       "patient": parsePatient(decodedResponse['details'])
//     };
//   } else {
//     return {"ifExist": false};
//   }
// }
