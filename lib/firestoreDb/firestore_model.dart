import 'dart:convert';

String firestoreModelToJson(FireStoreModel data){
  return json.encode(data.toJson());
} 

class FireStoreModel {

  // ignore: unused_field
  final String? centralRegistryID;

  final String? citymunCode;
  final String? hospitalID;
  final Map<String, dynamic> editHistory;

  final Map <String, dynamic> general;
  final List <Map<String, dynamic>> patientHistory;


  // final Map <String, dynamic> prehospital;
  // final Map <String, dynamic> er;
  // final Map <String, dynamic> surgery;
  // final Map <String, dynamic> inhospital;
  // final Map <String, dynamic> discharge;
  // // ignore: non_constant_identifier_names
  // final Map <String, dynamic> edit_history;

  FireStoreModel(
    this.centralRegistryID, 
    this.citymunCode,
    this.hospitalID, 
    this.editHistory,
    this.general, 
    this.patientHistory,
    // this.prehospital,
    // this.er, 
    // this.surgery, 
    // this.inhospital, 
    // this.discharge, 
    // this.edit_history, 
    );

    factory FireStoreModel.fromJson(Map<String, dynamic> json) => FireStoreModel(
      json["centralRegistryID"],  
      json["citymunCode"],
      json["hospitalID"],
      json["editHistory"],
      json["general"], 
      // json["prehospital"], 
      // json["er"], 
      // json["surgery"], 
      // json["inhospital"], 
      // json["discharge"], 
      // json["edit_history"]
      json["patientHistory"]
      );

    Map <String, dynamic> toJson () => 
    {
        "centralRegistryID": centralRegistryID,
        "citymunCode": citymunCode,
        "hospitalID": hospitalID,
        "editHistory": editHistory,
        "general": general,
        "patientHistory": patientHistory
    };

}

// class StreamModel{
//   final String? hospitalPatientID;
//   final String? hospitalRegistryID;
//   final String? firstName;
//   final String? lastName;
//   final String? patientDocumentID;

//   final String? currentPhase;

// }

