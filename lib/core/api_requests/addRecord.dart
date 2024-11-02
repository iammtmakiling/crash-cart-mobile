import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Adds a new record to the trauma registry.
///
/// Sends a POST request to the trauma registry API to add a new record
/// using the provided record data and bearer token for authorization.
///
/// Returns a Future containing a Map with a message indicating the success
/// or failure of the operation, along with information about the execution.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<Map<String, dynamic>> addNewRecord(
    Map<String, dynamic> data, String bearerToken) async {
  try {
    final response = await http.post(
      Uri.parse("https://ph-trauma-registry.onrender.com/api/records/"),
      body: {
        "content": jsonEncode(<String, dynamic>{
          "hospitalID": data["hospitalID"],
          "patientID": data["patientID"],
          "patientStatus": data['patientStatus'],
          "patientType": data['patientType'],
          "recordID": data["recordID"],
          "preHospital": data['preHospital'],
          "er": data['er'],
          "surgery": data['surgery'],
          "inHospital": data['inHospital'],
          "discharge": data['discharge'],
        }),
      },
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $bearerToken",
      },
    );
    // Decode response JSON
    Map<String, dynamic> responseJson = jsonDecode(response.body);

    // Check if the record is added successfully
    if (responseJson['message'] == "Record successfully added") {
      return {'message': responseJson['message'], "executed": "Add"};
    }

    // Return error message if adding record fails
    return {'message': responseJson['message'], "executed": "error"};
  } catch (e) {
    // Throw exception if an error occurs during the HTTP request
    throw Exception('Error adding record: $e');
  }
}


// import 'dart:convert';
// import 'dart:io';

// import "package:http/http.dart" as http;

// Future<dynamic> addNewRecord(
//     Map<String, dynamic> data, String bearerToken) async {
//   final response = await http.post(
//       Uri.parse("https://ph-trauma-registry.onrender.com/api/records/"),
//       body: {
//         "content": jsonEncode(<String, dynamic>{
//           "hospitalID": data["hospitalID"], //
//           "patientID": data["patientID"], //
//           "patientStatus": data['patientStatus'], //
//           "patientType": data['patientType'], //
//           "recordID": data["recordID"], //
//           "preHospital": data['preHospital'], //
//           "er": data['er'], //
//           "surgery": data['surgery'], //
//           "inHospital": data['inHospital'], //
//           "discharge": data['discharge'], //
//         }),
//       },
//       headers: {
//         HttpHeaders.authorizationHeader: "Bearer $bearerToken",
//       });

//   Map<String, dynamic> responseJson = jsonDecode(response.body);
//   if (responseJson['message'] == "Record successfully added") {
//     // patient is a newly created patient
//     return {'message': responseJson['message'], "executed": "Add"};
//   }

//   return {'message': responseJson['message'], "executed": "error"};
// }
