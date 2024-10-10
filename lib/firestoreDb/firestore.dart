import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore_model.dart';

class FireStoreDatabase {
  late FirebaseFirestore firestore;
  initialize() {
    firestore = FirebaseFirestore.instance;
  }

  static Future<List> readUsers() async {
    QuerySnapshot querySnapshot;
    List users = [];

    try {
      querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map<String, dynamic> user = {
            "id": doc.id,
            'department': doc['department'],
            'devices': doc['devices'],
            "firstName": doc['firstName'],
            'lastName': doc['lastName'],
            'middleName': doc['middleName'],
            'occupation': doc['occupation'],
            'password': doc['password'],
            'pin': doc['pin'],
            'position': doc['position'],
            'role': doc['role'],
            'userID': doc['userID'],
            'user_email': doc['user_email'],
            'username': doc['username'],
            'gender': doc['gender']
          };

          users.add(user);
        }
        // return users;
      }
    } catch (e) {
      print(e);
      print("Error in firestore.dart: readUsers()");
    }

    print(users);
    return users;
  }

  static void addMacAddress(
      String userEmail, String macAddress, List<dynamic> usersList) async {
    Map<String, dynamic> user = {};

    for (var doc in usersList) {
      if (doc['user_email'] == userEmail) {
        user = doc;
        user['devices'].add(macAddress);
        break;
      }
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user['id'])
          .update({'devices': user['devices']});
    } catch (e) {
      print(e);
    }
  }

  static Future<void> addPatient(
      FireStoreModel data, Map<String, dynamic> patientStreamData) async {
    QuerySnapshot querySnapshot;

    // adding patient into patientStream collection
    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('patientRecords')
          .where("centralRegistryID",
              isEqualTo: patientStreamData["centralRegistryID"].toString())
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var document = querySnapshot.docs[0];
        patientStreamData["patientDocumentID"] = document.id;
        print(patientStreamData);
        await FirebaseFirestore.instance
            .collection('patientStream')
            .add(patientStreamData);
      }
    } catch (e) {
      print(e);
      print(
          "Error for adding patient to patientStream collection in Firestore. {addPatient()}");
    }
  }

  static Future<List<Map<String, dynamic>>> readPatients() async {
    QuerySnapshot querySnapshot;
    List<Map<String, dynamic>> patients = [];

    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('patientRecordsFlutter')
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map<String, dynamic> patient = {
            "id": doc.id,
            "centralRegistryID": doc['centralRegistryID'],
            "citymunCode": doc["citymunCode"],
            "hospitalID": doc["hospitalID"],
            'general': doc['general'],
            'patientHistory': doc['patientHistory']
          };

          patients.add(patient);
        }
        // return users;
      }
    } catch (e) {
      print(e);
      print("Error in firestore.dart: readPatients()");
    }

    return patients;
  }

  static Future<bool> checkExistingPatient(FireStoreModel data) async {
    QuerySnapshot querySnapshot;

    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('patientRecordsFlutter')
          .where("general.fullName", isEqualTo: data.general["fullName"])
          .get();

      if (querySnapshot.docs.isNotEmpty) {}
    } catch (e) {}

    return false;
  }

  static Future<List<Map<String, dynamic>>> readFilteredPatients(
      String filter, String searchQuery) async {
    QuerySnapshot querySnapshot;
    List<Map<String, dynamic>> patients = [];

    try {
      if (filter == "First Name") {
        // querySnapshot = await FirebaseFirestore.instance.collection('patientRecordsFlutter').where("firstName",isEqualTo: searchQuery.toString()).get();
        querySnapshot = await FirebaseFirestore.instance
            .collection('patientRecordsFlutter')
            .where("general.firstName", isEqualTo: searchQuery.toString())
            .get();
      } else if (filter == "Last Name") {
        querySnapshot = await FirebaseFirestore.instance
            .collection('patientRecordsFlutter')
            .where("general.lastName", isEqualTo: searchQuery.toString())
            .get();
      } else if (filter == "Patient ID") {
        querySnapshot = await FirebaseFirestore.instance
            .collection('patientRecordsFlutter')
            .where("hospitalPatientID", isEqualTo: searchQuery.toString())
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('patientRecordsFlutter')
            .where("hospitalRegistryID", isEqualTo: searchQuery.toString())
            .get();
      }

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map<String, dynamic> patient = {
            "id": doc.id,
            "centralRegistryID": doc['centralRegistryID'],
            "citymunCode": doc["citymunCode"],
            "hospitalID": doc["hospitalID"],
            'general': doc['general'],
            'patientHistory': doc['patientHistory']
          };

          patients.add(patient);
        }
        // return users;
      }
    } catch (e) {
      print(e);
      print("Error in firestore.dart: readFilteredPatients()");
    }
    print(patients);
    return patients;
  }

  static Future<List<Map<String, dynamic>>> readPatientDetails(
      String documentID) async {
    QuerySnapshot querySnapshot;
    List<Map<String, dynamic>> patient = [];

    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('patientRecordsFlutter')
          .where("centralRegistryID", isEqualTo: documentID)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          Map<String, dynamic> patientDetails = {
            "id": doc.id,
            "centralRegistryID": doc['centralRegistryID'],
            "hospitalID": doc["hospitalID"],
            "editHistory": doc["editHistory"],
            'general': doc['general'],
            'patientHistory': doc['patientHistory']
          };

          patient.add(patientDetails);
        }
      } else {
        print("No patient matched.");
      }
    } catch (e) {
      print(e);
      print("Error in firestore.dart: readPatientDetails()");
    }
    return patient;
  }

  static Future<void> updatePatient(FireStoreModel data, String documentID,
      Map<String, dynamic> patientStreamData) async {
    QuerySnapshot querySnapshot;

    try {
      querySnapshot = await FirebaseFirestore.instance
          .collection('patientStream')
          .where("centralRegistryID",
              isEqualTo: patientStreamData["centralRegistryID"])
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          await FirebaseFirestore.instance
              .collection('patientStream')
              .doc(doc.id)
              .update({"currentPhase": patientStreamData['currentPhase']});
        }
      }
    } catch (e) {
      print(e);
      print(
          "Error for adding patient to patientStream collection in Firestore. {updatePatient()}");
    }

    print("passed");
  }
}
