import 'package:dashboard/api_requests/checkPatient.dart';
import 'package:dashboard/api_requests/getPatient.dart';
import 'package:dashboard/globals.dart';
import 'package:encrypt/encrypt.dart';
import 'package:intl/intl.dart';
import '../globals.dart' as globals;

final newKey = Key.fromUtf8(key);
final newIv = IV.fromUtf8(iv);

//Functions for General Use

/// Formats a given date-time string into a readable format.
String formatDateTime(String dateTimeString) {
  DateTime dateTime = DateTime.parse(dateTimeString);
  DateFormat dateFormat = DateFormat('MM/dd/yyyy - hh:mm a');
  return dateFormat.format(dateTime);
}

/// Decrypts the given text using AES encryption.
String decryp(String text) {
  final encrypter = Encrypter(AES(newKey, mode: AESMode.cbc));
  final decrypted = encrypter.decrypt64(text, iv: newIv);
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
  final encrypter = Encrypter(AES(newKey, mode: AESMode.cbc));
  final encrypted = encrypter.encrypt(text, iv: newIv);
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
  final document = await getPatients(bearerToken);
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
  final document = await getCurrentPatients(hospitalID, bearerToken);
  final numberOfRecords = document.length + 1;
  final paddedCount = numberOfRecords.toString().padLeft(5, '0');
  return '$hospitalID-$paddedCount';
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
    final patientFound = await checkPatientExist(encryptedPatient, bearerToken);
    if (patientFound['ifExist']) {
      return {"isFound": true, "patient": patientFound['patient']};
    }
  }
  return {"isFound": false};
}

/// Calculates the age based on the provided birth date.
calculateAge(DateTime birthDate) {
  print(birthDate);
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

Future<void> resetGlobalValues() async {
  globals.firstName = "";
  globals.lastName = "";
  globals.middleName = "";
  globals.suffix = "";
  globals.name = "";
  globals.username = "";
  globals.patientID = "";
  globals.department = "";
  globals.userID = "";
  globals.pin = "";
  globals.email = "";
  globals.sex = "";
  globals.birthday = "";
  globals.occupation = "";
  globals.role = "";
  globals.userFirebaseGenId = "";
  globals.hospitalID = "";
  globals.devices = [];
}

Future<void> resetGlobalExtraValues() async {
  globals.key = "";
  globals.iv = "";
  globals.iat = 0;
  globals.aud = "";
  globals.iss = "";
  globals.sub = "";
}
