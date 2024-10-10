import 'dart:convert';
import 'dart:io';

import "package:http/http.dart" as http;

/// Updates a patient record in the trauma registry.
///
/// Sends a PUT request to the trauma registry API to update the patient record
/// with the specified record ID, using the provided bearer token for authorization.
///
/// Returns a Future containing a Map with the result of the update operation if successful.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<dynamic> updateRecord(
    String recordID, Map<String, dynamic> data, String bearerToken) async {
  try {
    final response = await http.put(
      Uri.parse(
          "https://ph-trauma-registry.onrender.com/api/records/$recordID"),
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

    Map<String, dynamic> responseJson = jsonDecode(response.body);
    if (responseJson['message'] == "Successfully updated patient") {
      return {'message': responseJson['message'], "executed": "Updated"};
    }

    return {'message': responseJson['message'], "executed": "error"};
  } catch (e) {
    throw Exception('Error updating patient record: $e');
  }
}
// Future<dynamic> updateRecord(
//     String recordID, Map<String, dynamic> data, String bearerToken) async {
//   final response = await http.put(
//       Uri.parse(
//           "https://ph-trauma-registry.onrender.com/api/records/$recordID"),
//       body: {
//         "content": jsonEncode(<String, dynamic>{
//           "hospitalID": data["hospitalID"],
//           "patientID": data["patientID"],
//           "patientStatus": data['patientStatus'],
//           "patientType": data['patientType'],
//           "recordID": data["recordID"],
//           "preHospital": data['preHospital'],
//           "er": data['er'],
//           "surgery": data['surgery'],
//           "inHospital": data['inHospital'],
//           "discharge": data['discharge'],
//         }),
//       },
//       headers: {
//         HttpHeaders.authorizationHeader: "Bearer $bearerToken",
//       });

//   Map<String, dynamic> responseJson = jsonDecode(response.body);
//   if (responseJson['message'] == "Successfully updated patient") {
//     return {'message': responseJson['message'], "executed": "Updated"};
//   }

//   return {'message': responseJson['message'], "executed": "error"};
// }
