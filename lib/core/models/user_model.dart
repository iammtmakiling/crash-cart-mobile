import 'package:flutter/foundation.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String? middleName;
  final String? suffix;
  final String username;
  final String? patientID;
  final String department;
  final String userID;
  final String pin;
  final String email;
  final String sex;
  final String birthday;
  final String occupation;
  final String role;
  final String userFirebaseGenId;
  final String hospitalID;
  final List<dynamic> devices;
  final String? bearerToken;

  // Authentication specific fields
  final String? key;
  final String? iv;
  final int? iat;
  final String? aud;
  final String? iss;
  final String? sub;

  UserModel({
    required this.firstName,
    required this.lastName,
    this.middleName,
    this.suffix,
    required this.username,
    this.patientID,
    required this.department,
    required this.userID,
    required this.pin,
    required this.email,
    required this.sex,
    required this.birthday,
    required this.occupation,
    required this.role,
    required this.userFirebaseGenId,
    required this.hospitalID,
    required this.devices,
    this.bearerToken,
    this.key,
    this.iv,
    this.iat,
    this.aud,
    this.iss,
    this.sub,
  });

  String get fullName =>
      '$firstName ${middleName ?? ''} $lastName ${suffix ?? ''}'.trim();

  factory UserModel.fromJson(
      Map<String, dynamic> userDetails, Map<String, dynamic> extraDetails,
      {String? bearerToken}) {
    return UserModel(
      firstName: userDetails['firstName'] ?? '',
      lastName: userDetails['lastName'] ?? '',
      middleName: userDetails['middleName'],
      suffix: userDetails['suffix'],
      username: userDetails['username'] ?? '',
      patientID: userDetails['patientID'],
      department: userDetails['role'] ?? '',
      userID: userDetails['userID'] ?? '',
      pin: userDetails['pin'] ?? '',
      email: userDetails['email'] ?? '',
      sex: userDetails['sex'] ?? '',
      birthday: userDetails['birthday'] ?? '',
      occupation: userDetails['occupation'] ?? '',
      role: userDetails['role'] ?? '',
      userFirebaseGenId: userDetails['documentID'] ?? '',
      hospitalID: userDetails['hospitalID'] ?? '',
      devices: userDetails['devices'] ?? [],
      bearerToken: bearerToken,
      key: extraDetails['key'],
      iv: extraDetails['iv'],
      iat: extraDetails['iat'],
      aud: extraDetails['aud'],
      iss: extraDetails['iss'],
      sub: extraDetails['sub'],
    );
  }
}
