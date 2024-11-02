import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:intl/intl.dart';

Map<String, dynamic> getRecord(Map<String, dynamic> json) {
  final preHospital = json['preHospital'];
  final er = json['er'];
  final inHospital = json['inHospital'];
  final surgery = json['surgery'];
  final discharge = json['discharge'];

  final record = {
    "hospitalID": json['hospitalID'] ?? '', //Not Decrypted??
    "patientID": json['patientID'] != null ? decryp(json['patientID']) : null,
    "patientStatus":
        json['patientStatus'] != null ? decryp(json['patientStatus']) : null,
    "patientType":
        json['patientType'] != null ? decryp(json['patientType']) : null,
    "recordID": json['recordID'] != null ? decryp(json['recordID']) : null,
    "preHospital": preHospital,
    "er": er,
    "inHospital": inHospital,
    "surgery": surgery,
    "discharge": discharge,
  };
  return record;
}

Map<String, dynamic> parsePreHospitalRecord(Map<String, dynamic> preHospital) {
  final firstAid = preHospital['firstAid'];
  final placeOfInjury = preHospital['placeOfInjury'];
  final natureOfInjury = preHospital['natureOfInjury'];

  // Vehicular Accident
  final vehicularAccident = preHospital['vehicularAccident'];
  final preInjuryActivity =
      vehicularAccident != null ? vehicularAccident['preInjuryActivity'] : null;
  final safetyIssues =
      vehicularAccident != null ? vehicularAccident['safetyIssues'] : null;
  final otherRisksFactors =
      vehicularAccident != null ? vehicularAccident['otherRisksFactors'] : null;
  final vehiclesInvolved =
      vehicularAccident != null ? vehicularAccident['vehiclesInvolved'] : null;

  return {
    "externalCauses": decryptList(preHospital['externalCauses']),
    "editHistory": preHospital['editHistory'] ?? [],
    "injuryTimestamp": preHospital['injuryTimestamp'] ?? '',
    "createHistory": preHospital['createHistory'] ?? {},
    "chiefComplaint": preHospital['chiefComplaint'] != null
        ? decryp(preHospital['chiefComplaint'])
        : null,
    "firstAid": firstAid != null
        ? {
            "firstAider": firstAid['firstAider'] ?? '',
            "isGiven": firstAid['isGiven'] != null
                ? decryp(firstAid['isGiven'])
                : null,
            "isStandard": firstAid['isStandard'] != null
                ? decryp(firstAid['isStandard'])
                : null,
            "methodGiven": firstAid['methodGiven'] != null
                ? decryp(firstAid['methodGiven'])
                : null
          }
        : null,
    "injuryIntent": preHospital['injuryIntent'] != null
        ? decryp(preHospital['injuryIntent'])
        : null,
    "placeOfInjury": placeOfInjury != null
        ? {
            "cityMun": placeOfInjury['cityMun'] != null
                ? decryp(placeOfInjury['cityMun'])
                : null,
            "province": placeOfInjury['province'] != null
                ? decryp(placeOfInjury['province'])
                : null,
            "region": placeOfInjury['region'] != null
                ? decryp(placeOfInjury['region'])
                : null,
          }
        : null,
    "massInjury": preHospital['massInjury'] != null
        ? decryp(preHospital['massInjury'])
        : null,
    "medicolegal": preHospital['medicolegal'] != null
        ? {
            "medicolegalCategory":
                preHospital['medicolegal']['medicolegalCategory'] != null
                    ? decryp(preHospital['medicolegal']['medicolegalCategory'])
                    : null,
            "isMedicolegal": preHospital['medicolegal']['isMedicolegal'] != null
                ? decryp(preHospital['medicolegal']['isMedicolegal'])
                : null,
          }
        : null,
    "natureOfInjury": decryptList(natureOfInjury),
    "natureOfInjuryExtraInfo": preHospital['natureOfInjuryExtraInfo'] != null
        ? decryp(preHospital['natureOfInjuryExtraInfo'])
        : null, // Added (only String)
    "vehicularAccident": vehicularAccident != null
        ? {
            "preInjuryActivity": decryptList(preInjuryActivity),
            "collision": vehicularAccident['collision'] != null
                ? decryp(vehicularAccident['collision'])
                : null,
            "safetyIssues": decryptList(safetyIssues),
            "otherRisksFactors": decryptList(otherRisksFactors),
            "type": vehicularAccident['type'] != null
                ? decryp(vehicularAccident['type'])
                : null,
            "placeOfOccurrence": vehicularAccident['placeOfOccurrence'] != null
                ? decryp(vehicularAccident['placeOfOccurrence'])
                : null,
            "position": vehicularAccident['position'] != null
                ? decryp(vehicularAccident['position'])
                : null,
            "isVehicular": vehicularAccident['isVehicular'] != null
                ? decryp(vehicularAccident['isVehicular'])
                : null,
            "vehiclesInvolved": vehiclesInvolved != null
                ? {
                    "otherVehicle": vehiclesInvolved['otherVehicle'] != null
                        ? decryp(vehiclesInvolved['otherVehicle'])
                        : null,
                    "patientVehicle": vehiclesInvolved['patientVehicle'] != null
                        ? decryp(vehiclesInvolved['patientVehicle'])
                        : null,
                  }
                : null,
          }
        : null,
  };
}

Map<String, dynamic> parseERRecord(Map<String, dynamic> er) {
  if (er.isEmpty) {
    return {};
  }

  return {
    "isTransferred":
        er['isTransferred'] != null ? decryp(er['isTransferred']) : null,
    "servicesOnboard": decryptList(er['servicesOnboard']),
    "editHistory": er['editHistory'] ?? [],
    "isReferred": er['isReferred'] != null ? decryp(er['isReferred']) : null,
    "createHistory": er['createHistory'] ?? {},
    "aliveCategory":
        er['aliveCategory'] != null ? decryp(er['aliveCategory']) : null,
    "cavityInvolved":
        er['cavityInvolved'] != null ? decryp(er['cavityInvolved']) : null,
    "dispositionER":
        er['dispositionER'] != null ? decryp(er['dispositionER']) : null,
    "externalCauseICD":
        er['externalCauseICD'] != null ? decryp(er['externalCauseICD']) : null,
    "natureofInjuryICD": er['natureofInjuryICD'] != null
        ? decryp(er['natureofInjuryICD'])
        : null,
    "initialImpression": er['initialImpression'] != null
        ? decryp(er['initialImpression'])
        : null,
    "isSurgical": er['isSurgical'] != null ? decryp(er['isSurgical']) : null,
    "outcome": er['outcome'] != null ? decryp(er['outcome']) : null,
    "previousHospitalID": er['previousHospitalID'] ?? '', // Not Decrypted
    "previousPhysicianID": er['previousPhysicianID'] ?? '', // Not Decrypted
    "statusOnArrival":
        er['statusOnArrival'] != null ? decryp(er['statusOnArrival']) : null,
    "transportation":
        er['transportation'] != null ? decryp(er['transportation']) : null,
  };
}

Map<String, dynamic> parseInHospitalRecord(Map<String, dynamic> inHospital) {
  if (inHospital.isEmpty) {
    return {};
  }

  // Extracting necessary fields from inHospital
  final vteProphylaxis = inHospital['vteProphylaxis'];
  final lifeSupportWithdrawal = inHospital['lifeSupportWithdrawal'];
  final icu = inHospital['icu'];
  final consultations = inHospital['consultations'] ?? [];

  // Processing consultations
  List<Map<String, dynamic>> consultationList = [];
  for (var consultation in consultations) {
    Map<String, dynamic> consultationElement = {
      "service": consultation["service"] != null
          ? decryp(consultation["service"])
          : null,
      "physician": consultation["physician"],
      "consultationTimestamp": consultation["consultationTimestamp"]
    };
    consultationList.add(consultationElement);
  }

  // Constructing inHospitalRecord
  return {
    'createHistory': inHospital['createHistory'] ?? {},
    'editHistory': inHospital['editHistory'] ?? [],
    'capriniScore': inHospital['capriniScore'] != null
        ? decryp(inHospital['capriniScore'])
        : null,
    'vteProphylaxis': {
      'inclusion': vteProphylaxis['inclusion'] != null
          ? decryp(vteProphylaxis['inclusion'])
          : null,
      'type': vteProphylaxis['type'] != null
          ? decryp(vteProphylaxis['type'])
          : null,
    },
    'lifeSupportWithdrawal': lifeSupportWithdrawal != null
        ? {
            'lswBoolean': lifeSupportWithdrawal['lswBoolean'] != null
                ? decryp(lifeSupportWithdrawal['lswBoolean'])
                : null,
            'lswTimestamp': lifeSupportWithdrawal['lswTimestamp'],
          }
        : null,
    'icu': {
      'arrival': icu['arrival'] != null ? decryp(icu['arrival']) : null,
      'exit': icu['exit'] != null ? decryp(icu['exit']) : null,
      'lengthOfStay':
          icu['lengthOfStay'] != null ? decryp(icu['lengthOfStay']) : null,
    },
    'consultations': consultationList,
    'complications': decryptList(inHospital['complications']),
    'comorbidities': decryptList(inHospital['comorbidities']),
    'dispositionInHospital': inHospital['dispositionInHospital'] != null
        ? decryp(inHospital['dispositionInHospital'])
        : null,
  };
}

Map<String, dynamic> parseSurgeryRecord(Map<String, dynamic> surgery) {
  print("Original surgery data: $surgery");
  if (surgery.isEmpty) {
    return {};
  }

  String? parseDate(String? dateString) {
    if (dateString == null) return null;

    try {
      final date = DateTime.parse(dateString);
      print(date);
      return DateFormat('yyyy-MM-dd HH:mm').format(date);
    } catch (e) {
      print("Error parsing date: $e for date string: $dateString");
      return dateString; // Return original string if parsing fails
    }
  }

  final surgeriesList = surgery['surgeriesList'];
  List<Map<String, dynamic>> surgeriesListDecrypted = [];

  if (surgeriesList is List && surgeriesList.isNotEmpty) {
    for (var surgeryItem in surgeriesList) {
      Map<String, dynamic> surgeriesListElement = {
        "placeOfSurgery": surgeryItem["placeOfSurgery"],
        "rvsCode": surgeryItem['rvsCode'] != null
            ? decryp(surgeryItem['rvsCode'])
            : null,
        "cavityInvolved": surgeryItem['cavityInvolved'] != null
            ? decryp(surgeryItem['cavityInvolved'])
            : null,
        "servicesPresent": decryptList(surgeryItem['servicesPresent']),
        "phaseBegun": surgeryItem['phaseBegun'] != null
            ? decryp(surgeryItem['phaseBegun'])
            : null,
        "startTimestamp": parseDate(surgeryItem['startTimestamp']),
        "endTimestamp": parseDate(surgeryItem['endTimestamp']),
        "surgeryType": surgeryItem['surgeryType'] != null
            ? decryp(surgeryItem['surgeryType'])
            : null,
        "surgeonID": surgeryItem['surgeonID'],
        "hemorrhageControl": {
          "hemorrhageType": surgeryItem['hemorrhageControl']?['hemorrhageType'],
          "hemorrhageTimestamp": parseDate(
              surgeryItem['hemorrhageControl']?['hemorrhageTimestamp']),
        },
        "outcome": surgeryItem['outcome'] != null
            ? decryp(surgeryItem['outcome'])
            : null,
      };
      surgeriesListDecrypted.add(surgeriesListElement);
    }
  }

  Map<String, dynamic> result = {
    "createHistory": surgery['createHistory'] ?? {},
    "editHistory": surgery['editHistory'] ?? [],
    'needSurgery':
        surgery['needSurgery'] != null ? decryp(surgery['needSurgery']) : null,
    "surgeriesList": surgeriesListDecrypted,
    "dispositionSurgery": surgery['dispositionSurgery'] != null
        ? decryp(surgery['dispositionSurgery'])
        : null,
  };

  print("Parsed surgery data: $result");
  return result;
}

Map<String, dynamic> parseDischargeRecord(Map<String, dynamic> discharge) {
  return {
    'createHistory': discharge['createHistory'] ?? {},
    'editHistory': discharge['editHistory'] ?? [],
    'isTreatmentComplete': discharge['isTreatmentComplete'] != null
        ? decryp(discharge['isTreatmentComplete'])
        : null,
    'finalDiagnosis': discharge['finalDiagnosis'] != null
        ? decryp(discharge['finalDiagnosis'])
        : null,
    'dispositionDischarge': discharge['dispositionDischarge'] != null
        ? decryp(discharge['dispositionDischarge'])
        : null,
  };
}

Map<String, dynamic> parseRecord(Map<String, dynamic> json) {
  final preHospital = json['preHospital'];
  final er = json['er'];
  final inHospital = json['inHospital'];
  final surgery = json['surgery'];
  final discharge = json['discharge'];
  var erRecord = {};
  var preHospitalRecord = {};
  var surgeryRecord = {};
  var inHospitalRecord = {};
  var dischargeRecord = {};

  if (preHospital != {}) {
    final firstAid = preHospital['firstAid'];
    final placeOfInjury = preHospital['placeOfInjury'];
    final natureOfInjury = preHospital['natureOfInjury'];

    //Vehicular Accident
    final vehicularAccident = preHospital['vehicularAccident'];
    final preInjuryActivity = vehicularAccident['preInjuryActivity'];
    final safetyIssues = vehicularAccident['safetyIssues'];
    final otherRisksFactors = vehicularAccident['otherRisksFactors'];
    final vehiclesInvolved = vehicularAccident['vehiclesInvolved'];

    preHospitalRecord = {
      "externalCauses": decryptList(preHospital['externalCauses']),
      "editHistory": preHospital['editHistory'] ?? [],
      "injuryTimestamp": preHospital['injuryTimestamp'] ?? '',
      "createHistory": preHospital['createHistory'] ?? {},
      "chiefComplaint": preHospital['chiefComplaint'] != null
          ? decryp(preHospital['chiefComplaint'])
          : null,
      "firstAid": firstAid != null
          ? {
              "firstAider": firstAid['firstAider'] ?? '',
              "isGiven": firstAid['isGiven'] != null
                  ? decryp(firstAid['isGiven'])
                  : null,
              "isStandard": firstAid['isStandard'] != null
                  ? decryp(firstAid['isStandard'])
                  : null,
              "methodGiven": firstAid['methodGiven'] != null
                  ? decryp(firstAid['methodGiven'])
                  : null
            }
          : null,
      "injuryIntent": preHospital['injuryIntent'] != null
          ? decryp(preHospital['injuryIntent'])
          : null,
      "placeOfInjury": preHospital['placeOfInjury'] != null
          ? {
              "cityMun": placeOfInjury['cityMun'] != null
                  ? decryp(placeOfInjury['cityMun'])
                  : null,
              "province": placeOfInjury['province'] != null
                  ? decryp(placeOfInjury['province'])
                  : null,
              "region": placeOfInjury['region'] != null
                  ? decryp(placeOfInjury['region'])
                  : null,
            }
          : null,
      "massInjury": preHospital['massInjury'] != null
          ? decryp(preHospital['massInjury'])
          : null,
      "medicolegal": preHospital['medicolegal'] != null
          ? {
              "medicolegalCategory": preHospital['medicolegal']
                          ['medicolegalCategory'] !=
                      null
                  ? decryp(preHospital['medicolegal']['medicolegalCategory'])
                  : null,
              "isMedicolegal":
                  preHospital['medicolegal']['isMedicolegal'] != null
                      ? decryp(preHospital['medicolegal']['isMedicolegal'])
                      : null,
            }
          : null,
      "natureOfInjury": decryptList(natureOfInjury),
      "natureOfInjuryExtraInfo": preHospital["natureOfInjuryExtraInfo"] != null
          ? decryp(preHospital["natureOfInjuryExtraInfo"])
          : null, // Added (only String)
      "vehicularAccident": preHospital['vehicularAccident'] != null
          ? {
              "preInjuryActivity": decryptList(preInjuryActivity),
              "collision": vehicularAccident['collision'] != null
                  ? decryp(vehicularAccident['collision'])
                  : null,
              "safetyIssues": decryptList(safetyIssues),
              "otherRisksFactors": decryptList(otherRisksFactors),
              "type": vehicularAccident['type'] != null
                  ? decryp(vehicularAccident['type'])
                  : null,
              "placeOfOccurrence":
                  vehicularAccident['placeOfOccurrence'] != null
                      ? decryp(vehicularAccident['placeOfOccurrence'])
                      : null,
              "position": vehicularAccident['position'] != null
                  ? decryp(vehicularAccident['position'])
                  : null,
              "isVehicular": vehicularAccident['isVehicular'] != null
                  ? decryp(vehicularAccident['isVehicular'])
                  : null,
              "vehiclesInvolved": vehicularAccident['vehiclesInvolved'] != null
                  ? {
                      "otherVehicle": vehiclesInvolved['otherVehicle'] != null
                          ? decryp(vehiclesInvolved['otherVehicle'])
                          : null,
                      "patientVehicle":
                          vehiclesInvolved['patientVehicle'] != null
                              ? decryp(vehiclesInvolved['patientVehicle'])
                              : null,
                    }
                  : null,
            }
          : null,
    };
  }

  if (!er.isEmpty) {
    erRecord = {
      "isTransferred":
          er['isTransferred'] != null ? decryp(er['isTransferred']) : null,
      "servicesOnboard": decryptList(er['servicesOnboard']),
      "editHistory": er['editHistory'] ?? [],
      "isReferred": er['isReferred'] != null ? decryp(er['isReferred']) : null,
      "createHistory": er['createHistory'] ?? {},
      "aliveCategory":
          er['aliveCategory'] != null ? decryp(er['aliveCategory']) : null,
      "cavityInvolved":
          er['cavityInvolved'] != null ? decryp(er['cavityInvolved']) : null,
      "dispositionER":
          er['dispositionER'] != null ? decryp(er['dispositionER']) : null,
      "externalCauseICD": er['externalCauseICD'] != null
          ? decryp(er['externalCauseICD'])
          : null,
      "natureofInjuryICD": er['natureofInjuryICD'] != null
          ? decryp(er['natureofInjuryICD'])
          : null,
      "initialImpression": er['initialImpression'] != null
          ? decryp(er['initialImpression'])
          : null,
      "isSurgical": er['isSurgical'] != null ? decryp(er['isSurgical']) : null,
      "outcome": er['outcome'] != null ? decryp(er['outcome']) : null,
      "previousHospitalID": er['previousHospitalID'] ?? '', //Not Decrypted
      "previousPhysicianID": er['previousHospitalID'] ?? '', //Not Decrypted
      "statusOnArrival":
          er['statusOnArrival'] != null ? decryp(er['statusOnArrival']) : null,
      "transportation":
          er['transportation'] != null ? decryp(er['transportation']) : null
    };
  }

  // print("DONE FOR ER: $erRecord");

  if (inHospital.isNotEmpty) {
    // print("ENTERED IN HOSPITAL");

    // Extracting necessary fields from inHospital
    final vteProphylaxis = inHospital['vteProphylaxis'];
    final lifeSupportWithdrawal = inHospital['lifeSupportWithdrawal'];
    final icu = inHospital['icu'];
    final consultations = inHospital['consultations'] ?? [];

    // Processing consultations
    List<Map<String, dynamic>> consultationList = [];
    for (var consultation in consultations) {
      Map<String, dynamic> consultationElement = {
        "service": consultation["service"] != null
            ? decryp(consultation["service"])
            : null,
        "physician": consultation["physician"],
        "consultationTimestamp": consultation["consultationTimestamp"]
      };
      consultationList.add(consultationElement);
    }

    // Constructing inHospitalRecord
    inHospitalRecord = {
      'createHistory': inHospital['createHistory'] ?? {},
      'editHistory': inHospital['editHistory'] ?? [],
      'capriniScore': inHospital['capriniScore'] != null
          ? decryp(inHospital['capriniScore'])
          : null,
      'vteProphylaxis': {
        'inclusion': vteProphylaxis['inclusion'] != null
            ? decryp(vteProphylaxis['inclusion'])
            : null,
        'type': vteProphylaxis['type'] != null
            ? decryp(vteProphylaxis['type'])
            : null,
      },
      'lifeSupportWithdrawal': lifeSupportWithdrawal != null
          ? {
              'lswBoolean': lifeSupportWithdrawal['lswBoolean'] != null
                  ? decryp(lifeSupportWithdrawal['lswBoolean'])
                  : null,
              'lswTimestamp': lifeSupportWithdrawal['lswTimestamp'],
            }
          : null,
      'icu': {
        'arrival': icu['arrival'] != null ? decryp(icu['arrival']) : null,
        'exit': icu['exit'] != null ? decryp(icu['exit']) : null,
        'lengthOfStay':
            icu['lengthOfStay'] != null ? decryp(icu['lengthOfStay']) : null,
      },
      'consultations': consultationList,
      'complications': decryptList(inHospital['complications']),
      'comorbidities': decryptList(inHospital['comorbidities']),
      'dispositionInHospital': inHospital['dispositionInHospital'] != null
          ? decryp(inHospital['dispositionInHospital'])
          : null,
    };
  }

  if (!surgery.isEmpty) {
    final surgeriesList = surgery['surgeriesList'];
    List<Map<String, dynamic>> surgeriesListDecrypted = [];
    if (surgeriesList != []) {
      for (var index = 0; index < surgeriesList.length; index++) {
        Map<String, dynamic> surgeriesListElement = {
          "placeOfSurgery": surgeriesList[index]["placeOfSurgery"],
          "rvsCode": surgeriesList[index] != null
              ? decryp(surgeriesList[index]["rvsCode"])
              : null,
          "cavityInvolved": surgeriesList[index]["cavityInvolved"] != null
              ? decryp(surgeriesList[index]["cavityInvolved"])
              : null,
          "servicesPresent":
              decryptList(surgeriesList[index]["servicesPresent"]),
          "phaseBegun": surgeriesList[index]["phaseBegun"] != null
              ? decryp(surgeriesList[index]["phaseBegun"])
              : null,
          "startTimestamp": surgeriesList[index]["startTimestamp"], //
          "endTimestamp": surgeriesList[index]["endTimestamp"], //
          "surgeryType": surgeriesList[index]["surgeryType"] != null
              ? decryp(surgeriesList[index]["surgeryType"])
              : null,
          "surgeonID": surgeriesList[index]["surgeonID"], //
          "hemorrhageControl": {
            "hemmorhageType": surgeriesList[index]["hemorrhageControl"]
                ["hemmorhageType"],
            "hemmorhageTimestamp": surgeriesList[index]["hemorrhageControl"]
                ["hemmorhageTimestamp"]
          },
          "outcome": surgeriesList[index]["outcome"] != null
              ? decryp(surgeriesList[index]["outcome"])
              : null,
        };
        surgeriesListDecrypted.add(surgeriesListElement);
      }
    }

    // print("DONE SURGERY: $surgeriesListDecrypted");
    surgeryRecord = {
      "createHistory": surgery['createHistory'] ?? {},
      "editHistory": surgery['editHistory'] ?? [],
      'needSurgery': surgery['needSurgery'] != null
          ? decryp(surgery['needSurgery'])
          : null,
      "surgeriesList": surgeriesListDecrypted,
      "dispositionSurgery": surgery['dispositionSurgery'] != null
          ? decryp(surgery['dispositionSurgery'])
          : null,
    };
  }
  // print("DONE FOR SURGERY: $surgeryRecord");

  if (!discharge.isEmpty) {
    dischargeRecord = {
      'createHistory': discharge['createHistory'] ?? {},
      'editHistory': discharge['editHistory'] ?? [],
      'isTreatmentComplete': discharge['isTreatmentComplete'] != null
          ? decryp(discharge['isTreatmentComplete'])
          : null,
      'finalDiagnosis': discharge['finalDiagnosis'] != null
          ? decryp(discharge['finalDiagnosis'])
          : null,
      'dispositionDischarge': discharge['dispositionDischarge'] != null
          ? decryp(discharge['dispositionDischarge'])
          : null,
    };
  }

  // print("DONE FOR DISCHARGE: $dischargeRecord");

  final record = {
    "hospitalID": json['hospitalID'] ?? '', //Not Decrypted??
    "patientID": json['patientID'] != null ? decryp(json['patientID']) : null,
    "patientStatus":
        json['patientStatus'] != null ? decryp(json['patientStatus']) : null,
    "patientType":
        json['patientType'] != null ? decryp(json['patientType']) : null,
    "recordID": json['recordID'] != null ? decryp(json['recordID']) : null,
    "preHospital": preHospitalRecord,
    "er": erRecord,
    "inHospital": inHospitalRecord,
    "surgery": surgeryRecord,
    "discharge": dischargeRecord,
  };

  // print(record);

  return record;
}
