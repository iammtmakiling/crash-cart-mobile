import 'dart:ui';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/api_requests/_api.dart';
import '../provider/user_provider.dart';

/// Top-level variables to hold the encryption key, IV, bearer token, and hospital ID.
encrypt.Key? _key;
encrypt.IV? _iv;
String? _bearerToken;
String? _hospitalID;

/// Ensures that the encryption key, IV, bearer token, and hospital ID are initialized from `UserProvider`.
void initializeUserCredentials(UserProvider userProvider) {
  if (_key == null ||
      _iv == null ||
      _bearerToken == null ||
      _hospitalID == null) {
    _key = encrypt.Key.fromUtf8(userProvider.key);
    _iv = encrypt.IV.fromUtf8(userProvider.iv);
    _bearerToken = userProvider.bearerToken;
    _hospitalID = userProvider.hospitalID;
  }

  print('Key: $_key');
  print('IV: $_iv');
  print('Bearer Token: $_bearerToken');
  print('Hospital ID: $_hospitalID');
}

/// Formats a given date-time string into a readable format.
String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat dateFormat = DateFormat('MM/dd/yyyy - hh:mm a');
  return dateFormat.format(dateTime);
}

/// Decrypts the given text using AES encryption.
String decryp(String text) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));
  final decrypted = encrypter.decrypt64(text, iv: _iv!);
  return decrypted;
}

/// Decrypts a list of encrypted values.
List<String> decryptList(List<dynamic>? encryptedValues) {
  if (encryptedValues == null || encryptedValues.isEmpty) {
    return [];
  }

  return encryptedValues.map((value) => decryp(value)).toList();
}

/// Encrypts the given text using AES encryption.
String encryp(String text) {
  final encrypter =
      encrypt.Encrypter(encrypt.AES(_key!, mode: encrypt.AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: _iv!);
  return encrypted.base64;
}

/// Encrypts a list of values.
List<dynamic> encryptList(dynamic inputList) {
  if (inputList == null || inputList.isEmpty) {
    return [];
  }

  return inputList.map((text) => encryp(text)).toList();
}

/// Checks if the value is not empty, then encrypts it; otherwise, returns null.
dynamic nullChecker(dynamic value) {
  if (value is String) {
    if (value != "" && value != " ") {
      return encryp(value);
    } else {
      return null;
    }
  } else {
    if (value != null) {
      return encryp(value);
    } else {
      return null;
    }
  }
}

/// Returns the current date in a formatted string.
String currentDate() {
  return DateFormat('yyyy-MM-dd').format(DateTime.now());
}

/// Generates a unique patient ID based on the city code and description.
Future<String> generatePatientID(String cityCode, String cityDesc) async {
  final document = await getPatients(_bearerToken!);
  int count = document
          .where((patient) =>
              patient['general']['permanentAddress']['cityMun'] == cityDesc)
          .length +
      1;
  final paddedCount = count.toString().padLeft(5, '0');
  return '$cityCode-$paddedCount';
}

/// Generates a unique record ID based on the hospital ID and existing records.
Future<String> generateRecordID() async {
  final document = await getCurrentPatients(_hospitalID!, _bearerToken!);
  final numberOfRecords = document.length + 1;
  final paddedCount = numberOfRecords.toString().padLeft(5, '0');
  return '${_hospitalID!}-$paddedCount';
}

/// Checks if a patient already exists based on the provided form values.
Future<Map<String, dynamic>> checkIfPatientExist(
    Map<String, dynamic> formValues) async {
  if (formValues['firstName'] != null &&
      formValues['lastName'] != null &&
      formValues['birthday'] != null) {
    final encryptedPatient = {
      "firstName": nullChecker(formValues['firstName']),
      "lastName": nullChecker(formValues['lastName']),
      "middleName": nullChecker(formValues['middleName']),
      "suffix": nullChecker(formValues['suffix']),
      "birthday": nullChecker(formValues['birthday'].toString().split(" ")[0]),
    };
    final patientFound =
        await checkPatientExist(encryptedPatient, _bearerToken!);
    if (patientFound['ifExist']) {
      return {"isFound": true, "patient": patientFound['patient']};
    }
  }
  return {"isFound": false};
}

calculateAge(DateTime birthDate) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;
  int month1 = currentDate.month;
  int month2 = birthDate.month;
  if (month2 > month1) {
    age--;
  } else if (month1 == month2) {
    int day1 = currentDate.day;
    int day2 = birthDate.day;
    if (day2 > day1) {
      age--;
    }
  }
  return age;
}

String calculateAgeString(String birthday) {
  DateTime birthDate = DateTime.parse(birthday);
  DateTime today = DateTime.now();

  int years = today.year - birthDate.year;
  int months = today.month - birthDate.month;
  int days = today.day - birthDate.day;

  if (months < 0 || (months == 0 && days < 0)) {
    years--;
    months += (months < 0 ? 12 : 0);
  }

  if (years > 0) {
    return "$years years old";
  } else {
    return "$months months old";
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'Emergency Room':
      return Colors.yellow;
    case 'Pending Surgery':
      return const Color(0xFFF3B43F); // Orange #FF7F00
    case 'In-Surgery':
      return const Color(0xFFD42323); // Red
    case 'In-Hospital':
      return const Color(0xFF2E2EAA); // Blue
    case 'Pending Discharge':
      return Colors.lightGreen;
    case 'Discharged':
      return const Color(0xFF2EBB2E); // Green
    default:
      return const Color(0xFF353535); // Grey as default
  }
}

String getFormattedName(Map<String, dynamic> patientGeneralData) {
  String firstName = patientGeneralData['firstName'];
  String middleName = patientGeneralData['middleName'] != null
      ? "${patientGeneralData['middleName'][0]}."
      : '';
  String lastName = patientGeneralData['lastName'];
  return "$lastName, $firstName $middleName";
}

String formatDate(String timestamp) {
  try {
    DateTime dateTime = DateTime.parse(timestamp);
    return "${dateTime.month}/${dateTime.day}/${dateTime.year}";
  } catch (e) {
    print('Error parsing date: $e');
    return '';
  }
}
