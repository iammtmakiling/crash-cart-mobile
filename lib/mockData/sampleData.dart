var dischargeData = {
  "createHistory": {
    "user_email": "example@example.com",
    "deviceUsed": "Mobile",
    "editTimestamp": "2024-04-02 13:11:56.950"
  },
  "editHistory": {
    "editedBy": "John Doe",
    "editTimestamp": "2024-04-02 14:30:00"
  },
  "isTreatmentComplete": "yes",
  "finalDiagnosis": "Some new diagnosis",
  "dispositionDischarge": "Transferred"
};

var surgeryData = {
  "surgeryBoolean": null,
  "surgeriesList": [
    {
      "placeOfSurgery": "ER", //
      "rvsCode": "0008T: Upper gi endoscopy w/suture", //
      "cavityInvolved": "Head", //
      "servicesPresent": ["General Surgery"], //
      "phaseBegun": "Eyy", //
      "startTimestamp": "2024-04-02 12:00:00.000",
      "endTimestamp": "2024-04-02 19:00:00.000",
      "surgeryType": "Something",//
      "surgeon": "0912344",
      "hemorrhageControl": {
        "hemorrhageType": "Controlled",
        "hemorrhageTimestamp": "2024-04-01 18:00:00.000"
      },
    },
    {
      "placeOfSurgery": "OR",
      "rvsCode": "0008T: Upper gi endoscopy w/suture",
      "cavityInvolved": "Head",
      "servicesPresent": ["General Surgery"],
      "phaseBegun": "Eyy",
      "startTimestamp": "2024-04-02 12:00:00.000",
      "endTimestamp": "2024-04-02 19:00:00.000",
      "surgeryType": "Something",
      "surgeon": "0912344",
      "hemorrhageControl": {
        "hemorrhageType": "Controlled",
        "hemorrhageTimestamp": "2024-04-01 18:00:00.000"
      },
    }
  ],
  "dispositionSurgery": "No intervention and for Discharge"
};

Map<String, dynamic> inHospitalData = {
  "createHistory": {
    "user_email": "",
    "deviceUsed": "",
    "editTimestamp": "2024-04-04 10:35:33.935"
  },
  "editHistory": {},
  "capriniScore": "7",
  "vteProphylaxis": {
    "inclusion": "yes",
    "type": "kita",
    "date": "2024-04-01 12:00:00.000"
  },
  "lifeSupportWithdrawal": {
    "lswBoolean": true,
    "lswTimestamp": "2024-04-04 12:00:00.000"
  },
  "icu": {
    "arrival": "2024-04-02 00:00:00.000",
    "exit": "2024-04-03 00:00:00.000",
    "lengthOfStay": 1
  },
  "comorbidities": ["A000", "A001"],
  "consultations": [
    {
      "service": "Oks lng cya",
      "physician": "Physician",
      "consultationTimestamp": "2024-04-02 00:00:00.000"
    },
    {
      "service": "Oks lng cya",
      "physician": "Physician",
      "consultationTimestamp": "2024-04-02 00:00:00.000"
    }
  ],
  "complications": ["A009", "A0100"],
  "dispositionInHospital": "Died"
};

Map<String, dynamic> erData = {
  "isTransferred": "yes", //
  "previousHospitalID": "012345", //
  "previousPhysicianID": "012345", //
  "isReferred": "yes", //
  "servicesOnboard": ["General Surgery"], //
  "editHistory": {},
  "createHistory": {
    "user_email": "",
    "deviceUsed": "",
    "editTimestamp": "2024-04-05 00:00:00.000"
  },
  "aliveCategory": "Conscious", //
  "cavityInvolved": "Extremity", //
  "dispositionER": "Admit (Surgery)",
  "externalCauseICD": "A0100: Typhoid fever, unspecified", //
  "natureofInjuryICD":
      "A001: Cholera due to Vibrio cholerae 01, biovar eltor", //
  "initialImpression": "k lang", //
  "isSurgical": "yes", //
  "outcome": "Improved", //
  "statusOnArrival": "Alive", //
  "transportation": "Ambulance" //
};

Map<String, dynamic> preHospitalData = {
  "externalCauses": "Drowning",
  "editHistory": [],
  "injuryTimestamp": "2024-04-04 12:00:00.000",
  "createHistory": {
    "user_email": "",
    "deviceUsed": "",
    "editTimestamp": "2024-04-06 00:00:00.000",
  },
  "chiefComplaint": "secret",
  "firstAid": {
    "firstAider": "Kael",
    "isGiven": "yes",
    "isStandard": "yes",
    "methodGiven": "Keme keme",
  },
  "injuryIntent": "unintentional",
  "placeOfInjury": {
    "region": "REGION VIII (EASTERN VISAYAS)",
    "province": "NORTHERN SAMAR",
    "cityMun": "MAPANAS",
  },
  "massInjury": "yes",
  "medicolegal": {
    "isMedicolegal": "yes",
    "medicolegalCategory": "Violence against Children",
  },
  "natureOfInjury": ["Blunt Trauma", "Fracture (Closed Type)"],
  "natureOfInjuryExtraInfo": "Grabe jud",
  "vehicularAccident": {
    "preInjuryActivity": "Sports",
    "collision": "Collision",
    "safetyIssues": ["Sleepy", "Alcohol"],
    "otherRisksFactors": "N/A",
    "type": "Land",
    "placeOfOccurence": "Unknown",
    "position": "Driver",
    "isVehicular": "yes",
    "vehiclesInvolved": {
      "otherVehicle": null,
      "patientVehicle": "(none) Pedestrian",
    },
  },
};

Map<String, dynamic> generalData = {
  "suffix": "Jr.",
  "birthday": "2024-04-04 12:00:00.000",
  "firstName": "John",
  "lastName": "Doe",
  "middleName": "Smith",
  "permanentAddress": {
    "region": "REGION VIII (EASTERN VISAYAS)",
    "province": "NORTHERN SAMAR",
    "cityMun": "MAPANAS",
  },
  "philHealthID": "123456789012",
  "presentAddress": {
    "region": "REGION VIII (EASTERN VISAYAS)",
    "province": "NORTHERN SAMAR",
    "cityMun": "MAPANAS",
  },
  "sex": "Male",
};

Map<String, dynamic> generalData2 = {
  "suffix": "Ms.",
  "birthday": "2024-04-04 12:00:00.000",
  "firstName": "Maria",
  "lastName": "Pauline",
  "middleName": "Smith",
  "permanentAddress": {
    "region": "REGION VIII (EASTERN VISAYAS)",
    "province": "NORTHERN SAMAR",
    "cityMun": "MAPANAS",
  },
  "philHealthID": "123456789012",
  "presentAddress": {
    "region": "REGION VIII (EASTERN VISAYAS)",
    "province": "NORTHERN SAMAR",
    "cityMun": "MAPANAS",
  },
  "sex": "Male",
};

Map<String, dynamic> sampleRecord = {
  "hospitalID": "012345000",
  "patientID": "0123456",
  "patientStatus": "DIS",
  "patientType": 'OR',
  "recordID": "0123456",
  "general": generalData,
  "preHospital": preHospitalData,
  "er": erData,
  "surgery": surgeryData,
  "inHospital": inHospitalData,
  "discharge": dischargeData,
};

Map<String, dynamic> patient = {
  "patientID": "0123456",
  "general": generalData,
  "lastHospital": null,
  "lastStatus": null,
  "patientHistory": []
};

Map<String, dynamic> patient2 = {
  "patientID": "0123456",
  "general": generalData2,
  "lastHospital": null,
  "lastStatus": null,
  "patientHistory": []
};
