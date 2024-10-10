const ROLE = {
  'ADMIN': 'Administrator',
  'HF_ADMIN': 'HF Administrator',
  'PH_STAFF': 'Pre-Hospital Staff',
  'ER_STAFF': 'ER Staff',
  'OR_STAFF': 'OR Staff',
  'INHOSPITAL_STAFF': 'In-Hospital Staff',
  'DISCHARGE_STAFF': 'Discharge Staff'
};

const STATUS = {
  'PRE': 'Pre-Hospital',
  'ER': 'Emergency Room',
  'OR': 'Operating Room',
  'IN': 'In-Hospital',
  'DIS': 'Discharged'
};

final hf = [
  {'hfID': '39596', 'name': 'Philippine General Hospital'},
  {'hfID': '39380', 'name': 'Las Pinas General Hospital and Trauma Center'},
  {
    'hfID': '43397',
    'name': 'Conrado F. Estrella Regional Medical & Trauma Center'
  },
];

final List<Map<String, dynamic>> users = [
  {
    'userID': '0021522',
    'patientID': '54-4400-00001', //Need pa ba ito?
    'firstName': 'Paulo', //
    'middleName': 'Lim', //
    'lastName': 'Rivera', //
    'suffix': 'Jr.',
    'username': 'privera',
    'email': 'privera@gmail.com',
    'password':
        '\$2a\$10\$IXA0xB8gyw1YMkZtpsagjeYNqQIXnenURisss6zQiubTsjPSYvM6u',
    'pin': '0000',
    'birthday': '1985-01-23',
    'sex': 'Male',
    'hfID': '39596',
    'occupation': 'IT Head Administrator',
    'role': 'Administrator',
    'device': ['E6:9F:21:41:C4:1A']
  },
  {
    'userID': '0035128',
    'patientID': null,
    'firstName': 'Gabriela',
    'middleName': 'Saavedra',
    'lastName': 'Carlos',
    'suffix': null,
    'username': 'gcarlos',
    'email': 'gcarlos@gmail.com',
    'password':
        '\$1b\$10\$IYA1xB8gyw1YMkZtpsagjeYNqQIXnenURisss6zQiubTsjPSYvM6u',
    'pin': '0000',
    'birthday': '2001-01-09',
    'sex': 'Female',
    'hfID': '39596',
    'occupation': 'Surgeon',
    'role': 'OR Staff',
    'device': ['51:51:51:51:51:00']
  },
];

final List<Map<String, dynamic>> patients = [
  {
    'patientID': '54-4400-00001', //
    'philHealthID': '3948824', //
    'patientStatus': 'DIS', //
    'firstName': 'Paulo', //
    'middleName': 'Lim', //
    'lastName': 'Rivera', //
    'suffix': null, //
    'birthday': '1985-01-23', //
    'sex': 'Male', //
    'presentAddress': {
      'street': 'Tulip St.', //
      'brgy': 'Magsaysay', //
      'cityMun': 'Naga City', //
      'province': 'Camarines Sur', //
      'region': 'V', //
      'zip': '4400', //
      'area': '54' //
    },
    'permanentAddress': {
      'street': 'Tulip St.',
      'brgy': 'Magsaysay',
      'cityMun': 'Naga City',
      'province': 'Camarines Sur',
      'region': 'V',
      'zip': '4400',
      'area': '54'
    },
  },
  {
    'patientID': '02-1811-00001',
    'philHealthID': '7654321',
    'patientStatus': 'ER',
    'firstName': 'Lindsay',
    'middleName': 'Dampog',
    'lastName': 'Cruz',
    'suffix': null,
    'birthday': '1985-09-22',
    'sex': 'Female',
    'presentAddress': {
      'street': null,
      'brgy': 'Concepcion 2',
      'cityMun': 'Marikina City',
      'province': 'Metro Manila',
      'region': 'NCR',
      'zip': '1811',
      'area': '02'
    },
    'permanentAddress': {
      'street': null,
      'brgy': 'Concepcion 2',
      'cityMun': 'Marikina City',
      'province': 'Metro Manila',
      'region': 'NCR',
      'zip': '1811',
      'area': '02'
    },
  },
];
