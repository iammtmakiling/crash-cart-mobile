import 'dart:convert';

String firestoreModelToJson(FireStoreModel data) {
  return json.encode(data.toJson());
}

class FireStoreModel {
  // ignore: unused_field
  final String? centralRegistryID;

  final String? citymunCode;
  final String? hospitalID;
  final Map<String, dynamic> editHistory;

  final Map<String, dynamic> general;
  final List<Map<String, dynamic>> patientHistory;

  FireStoreModel(
    this.centralRegistryID,
    this.citymunCode,
    this.hospitalID,
    this.editHistory,
    this.general,
    this.patientHistory,
  );

  factory FireStoreModel.fromJson(Map<String, dynamic> json) => FireStoreModel(
      json["centralRegistryID"],
      json["citymunCode"],
      json["hospitalID"],
      json["editHistory"],
      json["general"],
      json["patientHistory"]);

  Map<String, dynamic> toJson() => {
        "centralRegistryID": centralRegistryID,
        "citymunCode": citymunCode,
        "hospitalID": hospitalID,
        "editHistory": editHistory,
        "general": general,
        "patientHistory": patientHistory
      };
}
