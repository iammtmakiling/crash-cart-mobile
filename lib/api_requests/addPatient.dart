import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Adds a new patient to the trauma registry.
///
/// Sends a POST request to the trauma registry API to add a new patient
/// using the provided patient data and bearer token for authorization.
///
/// Returns a Future containing a Map with a message indicating the success
/// or failure of the operation, along with information about the execution.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<Map<String, dynamic>> addNewPatient(
    Map<String, dynamic> data, String bearerToken) async {
  try {
    final response = await http.post(
      Uri.parse("https://ph-trauma-registry.onrender.com/api/patients/"),
      body: {
        "content": jsonEncode(<String, dynamic>{
          "patientID": data["patientID"],
          "general": data["general"],
          "lastHospital": null,
          "lastStatus": null,
          "patientHistory": []
        })
      },
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      },
    );

    // Decode response JSON
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    // Check if the patient is added successfully
    if (responseJson['message'] == "Patient is added successfully.") {
      return {'message': responseJson['message'], "executed": "Add"};
    }

    // Return error message if adding patient fails
    return {'message': responseJson['message'], "executed": "error"};
  } catch (e) {
    // Throw exception if an error occurs during the HTTP request
    throw Exception('Error adding patient: $e');
  }
}
