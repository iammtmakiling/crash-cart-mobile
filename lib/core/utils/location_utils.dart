import 'dart:convert';
import 'package:flutter/services.dart';

class LocationUtils {
  static Future<List<dynamic>> readJsonRegions() async {
    final String response =
        await rootBundle.loadString('assets/json/refregion.json');
    final data = await json.decode(response);
    return data["RECORDS"];
  }

  static Future<List<dynamic>> readJsonProvinces() async {
    final String response =
        await rootBundle.loadString('assets/json/refprovince.json');
    final data = await json.decode(response);
    return data["RECORDS"];
  }

  static Future<List<dynamic>> readJsonCities() async {
    final String response =
        await rootBundle.loadString('assets/json/refcitymun.json');
    final data = await json.decode(response);
    return data["RECORDS"];
  }
}
