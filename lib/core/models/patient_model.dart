import 'package:dashboard/core/utils/helper_utils.dart';

Map<String, dynamic> parsePatient(Map<String, dynamic> json) {
  String? decryptField(Map<String, dynamic> map, String key) {
    return (map[key] != null && map[key] != "") ? decryp(map[key]) : null;
  }

  Map<String, dynamic> decryptAddress(Map<String, dynamic> address) {
    return {
      'cityMun': decryptField(address, 'cityMun'),
      'province': decryptField(address, 'province'),
      'region': decryptField(address, 'region'),
    };
  }

  final general = json['general'];

  return {
    'patientID': decryptField(json, 'patientID'),
    'general': {
      'firstName': decryptField(general, 'firstName'),
      'middleName': decryptField(general, 'middleName'),
      'lastName': decryptField(general, 'lastName'),
      'suffix': decryptField(general, 'suffix'),
      'birthday': decryptField(general, 'birthday'),
      'sex': decryptField(general, 'sex'),
      'presentAddress': general['presentAddress'] != null
          ? decryptAddress(general['presentAddress'])
          : null,
      'permanentAddress': general['permanentAddress'] != null
          ? decryptAddress(general['permanentAddress'])
          : null,
      'philHealthID': decryptField(general, 'philHealthID'),
    },
  };
}
