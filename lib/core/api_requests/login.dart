import 'dart:convert';
import 'dart:io';
import "package:http/http.dart" as http;
import 'package:jwt_decoder/jwt_decoder.dart';

/// Performs user authentication for logging into the trauma registry.
///
/// Sends a POST request to the trauma registry API to authenticate the user
/// with the provided email, password, and device MAC address.
///
/// Returns a Future containing a Map with an access token and device check result
/// if authentication is successful.
///
/// Returns a Map containing an access token and an error message if authentication fails.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<Map<String, dynamic>> loginAuth(
    String userEmail, String password, String macAddress) async {
  try {
    print("ENETEEERED");
    final response = await http.post(
      Uri.parse("https://ph-trauma-registry.onrender.com/api/login/"),
      body: {
        "email": userEmail,
        "password": password,
        "currentDevice": macAddress
      },
    );

    final responseJson = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Return access token and device check result if authentication is successful
      return {
        "accessToken": responseJson['accessToken'],
        "checkDevice": responseJson['checkDevice']
      };
    }
    print(responseJson['message']);

    // Return access token and error message if authentication fails
    return {"accessToken": null, "message": responseJson['message']};
  } catch (e) {
    // Throw exception if an error occurs during the HTTP request
    throw Exception('Error during login authentication: $e');
  }
}

/// Retrieves extra details of the user from the provided bearer token.
///
/// Decodes the JWT bearer token to extract and return extra details of the user.
///
/// Returns a Map containing extra details of the user extracted from the bearer token.
Map<String, dynamic> getUserExtraDetails(String bearerToken) {
  Map<String, dynamic> decodedToken = JwtDecoder.decode(bearerToken);
  return decodedToken;
}

/// Retrieves details of the user from the trauma registry.
///
/// Sends a GET request to the trauma registry API to retrieve details of the user
/// associated with the provided bearer token.
///
/// Returns a Future containing user details if the request is successful.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<dynamic> getUserDetails(String bearerToken) async {
  final response = await http.get(
    Uri.parse("https://ph-trauma-registry.onrender.com/api/user"),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    },
  );

  final responseJson = jsonDecode(response.body);
  return UserDetails.fromJson(responseJson);
}

/// Adds a device to the user in the trauma registry.
///
/// Sends a PUT request to the trauma registry API to add the provided device
/// with the specified MAC address to the user associated with the provided email,
/// using the provided bearer token for authorization.
///
/// Returns a Future containing the result of adding the device.
///
/// Throws an Exception if the HTTP request fails or encounters an error.
Future<dynamic> addDeviceToUser(
    String bearerToken, String macAddress, String email) async {
  final response = await http.put(
    Uri.parse(
        "https://ph-trauma-registry.onrender.com/api/users/$email/devices"),
    headers: {
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
    },
    body: {"currentDevice": macAddress},
  );

  final responseJson = jsonDecode(response.body);
  return addDevicePrompt.fromJson(responseJson);
}

/// Represents the prompt message when adding a device to the user.
class addDevicePrompt {
  final String message;

  const addDevicePrompt({required this.message});

  factory addDevicePrompt.fromJson(Map<String, dynamic> json) {
    return addDevicePrompt(message: json['message']);
  }
}

/// Represents the details of the user.
class UserDetails {
  final String message;
  final Map<String, dynamic> userDetails;

  const UserDetails({required this.message, required this.userDetails});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(message: json['message'], userDetails: json['user']);
  }
}


// Map<String, dynamic> getUserExtraDetails(String bearerToken) {
//   Map<String, dynamic> decodedToken = JwtDecoder.decode(bearerToken);
//   return decodedToken;
// }

// Future<dynamic> getUserDetails(String bearerToken) async {
//   final response = await http.get(
//       Uri.parse("https://ph-trauma-registry.onrender.com/api/user"),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
//       });

//   final responseJson = jsonDecode(response.body);
//   return UserDetails.fromJson(responseJson);
// }

// Future<dynamic> addDeviceToUser(
//     String bearerToken, String macAddress, String email) async {
//   final response = await http.put(
//       Uri.parse(
//           "https://ph-trauma-registry.onrender.com/api/users/$email/devices"),
//       headers: {
//         HttpHeaders.authorizationHeader: 'Bearer $bearerToken',
//       },
//       body: {
//         "currentDevice": macAddress
//       });

//   final responseJson = jsonDecode(response.body);
//   return addDevicePrompt.fromJson(responseJson);
// }

// class addDevicePrompt {
//   final String message;

//   const addDevicePrompt({required this.message});

//   factory addDevicePrompt.fromJson(Map<String, dynamic> json) {
//     return addDevicePrompt(message: json['message']);
//   }
// }

// class UserDetails {
//   final String message;
//   final Map<String, dynamic> userDetails;

//   const UserDetails({required this.message, required this.userDetails});

//   factory UserDetails.fromJson(Map<String, dynamic> json) {
//     return UserDetails(message: json['message'], userDetails: json['user']);
//   }
// }
