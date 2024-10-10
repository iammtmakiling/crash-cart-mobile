const STATUS = {
  'PRE': 'Pre-Hospital',
  'ER': 'Emergency Room',
  'OR': 'Operating Room',
  'IN': 'In-Hospital',
  'DIS': 'Discharged'
};

// Summary

//---- Pre Admission
// - wala sa data / kulang -
// Other risk factors
final List<Map<String, dynamic>> records = [
  {
    'recordID': '54-4400-00001-001', //
    'hfID': '39596', //
    'patientID': '54-4400-00001', //
    'patientStatus': 'Discharged',
    "patientType": "ER", //------------
    "hospitalID": "39596", //------------
    'preHospital': {
      'createHistory': {
        'userID': '0035128',
        'timestamp': '2023-01-01 21:30:00.000', //
      },
      'editHistory': {},
      'chiefComplaint': 'Bruises', // Di ko mahanap san toh?
      'massInjury': true, // Di ko mahanap san toh?
      'placeOfInjury': {
        //
        'street': null,
        'brgy': null,
        'cityMun': 'Tigaon',
        'province': 'Camarines Sur',
        'region': 'V',
        'zip': null,
        'area': null,
      },
      'injuryTimestamp': '2023-01-01 20:55:00.000', //
      'injuryIntent': 'Accidental', //
      'firstAid': {
        'isGiven': true,
        'firstAider': '0035128', // Pwede naman ito name diba?
        'isStandard': true,
        "methodGiven": "Wound Care", //-------------
        // "What is Given na string?"
      },
      "natureOfInjury": [
        [
          "Concussion",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        ],
        [
          "Fracture",
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        ]
      ], // Can be multiple with notes [["Laceration", "Notes"],["Avulsion", "Notes"]
      'externalCauses': ['Fall', 'Fly'], // Can be multiple []
      'safetyIssues': [''],
      'vehicularAccident': {
        //
        'isVehicular': true,
        'vehicularType': 'Car',
        'position': 'Pedestrian',
        'collision': true, // ----------
        "type": "Land", // ---------
        'partiesInvolved': ['Driver', 'Pedestrian'],
        'placeOfOccurrence': 'Street',
      },
      "preInjuryActivity": ["Going to bed", "Eating"],
      "otherRisksFactors": ["Sleepy"],
      'medicolegal': {
        // Di ko mahanap san toh?
        'isMedicolegal': true,
        'medicolegalCategory': 'Motor Vehicle Accident',
      },
    },
    'erData': {
      'createHistory': {
        'userID': '0035128',
        'timestamp': '2023-01-02 00:45:00.000',
      },
      'editHistory': [],
      'statusOnArrival': 'Stable', //
      'aliveCategory': 'Ambulatory', //
      'transportation': 'Ambulance', //
      'initialImpression': 'Conscious and coherent', //
      'isSurgical': 'no',
      'cavityInvolved': null,
      'servicesOnboard': ['Oxygen', 'Intravenous access', 'Carbon'],
      'dispositionER': 'Admitted', //
      'outcome': 'Stable', //
      "natureofInjuryICD": "Code Blue",
      "externalCauseICD": "Code red",
    },
    "surgery": {
      "createHistory": {
        "userID": "0035128",
        "timestamp": "2023-01-02 12:00:00.000"
      },
      "editHistory": [],
      'needSurgery': true,
      "surgeriesList": [
        {
          "cavityInvolved": "Extremity",
          "placeOfSurgery": "Operating Room (OR)",
          "servicesPresent": [],
          "rvsCode": "0008T: Upper gi endoscopy w/suture",
          "phaseBegun": "",
          "startTimestamp": "2023-01-02 12:30:00.000",
          "endTimestamp": "2023-01-02 2:30:00.000",
          "surgeryType": "ORIF",
          "surgeonID": "0035128",
          "hemorrhageControl": {
            "hemmorhageType": null,
            "hemmorhageTimestamp": null
          },
          "dispositionSurgery": "Transferred",
          "outcome": "Improved"
        }
      ],
    },
    'inHospitalData': {
      'createHistory': {
        'userID': '0035128',
        'timestamp': '2023-01-02 12:00:00.000',
      },
      'editHistory': [],
      'capriniScore': '3',
      'vteProphylaxis': {
        'date': '2023-01-02',
        'inclusion': 'Yes',
        'type': 'Chemoprophylaxis',
      },
      'lifeSupportWithdrawal': {
        'lswBoolean': 'no',
        'lswTimestamp': null,
      },
      'icu': {
        'arrival': null,
        'exit': null,
        'lengthOfStay': null,
      },
      'comorbidities': [],
      'consultations': [],
      'complications': [],
      'dispositionInHospital': null,
    },
    'dischargeData': {
      'createHistory': {
        'userID': '0035128',
        'timestamp': '2023-01-03 12:00:00.000',
      },
      'editHistory': [],
      'isTreatmentComplete': true,
      'finalDiagnosis': 'Fall-related injury',
      'dispositionDischarge': 'Discharged to Home with Home Care Instructions',
    },
  },
];
