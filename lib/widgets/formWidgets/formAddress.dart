import 'package:dashboard/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class FormAddress extends StatefulWidget {
  final String? regionId;
  final String? provincesId;
  final String? citiesId;
  final String? regionDesc;
  final String? provincesDesc;
  final String? citiesDesc;
  final bool enabled;
  final ValueChanged<String?>? onRegionIDChanged;
  final ValueChanged<String?>? onProvincesIDChanged;
  final ValueChanged<String?>? onCitiesIDChanged;
  final ValueChanged<String?>? onRegionDescChanged;
  final ValueChanged<String?>? onProvincesDescChanged;
  final ValueChanged<String?>? onCitiesDescChanged;
  final String? Function(dynamic)? validator;

  const FormAddress(
      {super.key,
      required this.regionId,
      required this.provincesId,
      required this.citiesId,
      this.regionDesc,
      this.provincesDesc,
      this.citiesDesc,
      required this.onRegionIDChanged,
      required this.onProvincesIDChanged,
      required this.onCitiesIDChanged,
      required this.onRegionDescChanged,
      required this.onProvincesDescChanged,
      required this.onCitiesDescChanged,
      required this.enabled,
      this.validator});

  @override
  _FormAddressState createState() => _FormAddressState();
}

class _FormAddressState extends State<FormAddress> {
  late String presentRegionId;
  late String presentProvincesId;
  late String presentCitiesId;
  late String presentRegionDesc;
  late String presentProvincesDesc;
  late String presentCitiesDesc;
  List<dynamic> regions = [];
  List<dynamic> newRegions = [];

  List<dynamic> provincesMaster = [];
  List<dynamic> provinces = [];
  List<dynamic> newProvinces = [];

  List<dynamic> citiesMaster = [];
  List<dynamic> cities = [];
  List<dynamic> newCities = [];

  Future<void> readJsonRegions() async {
    final String response =
        await rootBundle.loadString('assets/json/refregion.json');
    final data = await json.decode(response);
    setState(() {
      regions = data["RECORDS"];
    });
    //print(data);
  }

  Future<void> readJsonProvinces() async {
    final String response =
        await rootBundle.loadString('assets/json/refprovince.json');
    final data = await json.decode(response);
    setState(() {
      provincesMaster = data["RECORDS"];
    });
    //print(data);
  }

  Future<void> readJsonCities() async {
    final String response =
        await rootBundle.loadString('assets/json/refcitymun.json');
    final data = await json.decode(response);
    setState(() {
      citiesMaster = data["RECORDS"];
    });
    //print(data);
  }

  @override
  void initState() {
    super.initState();
    presentRegionId = widget.regionId.toString();
    presentProvincesId = widget.provincesId.toString();
    presentCitiesId = widget.citiesId.toString();
    initializeData();
  }

  @override
  void didUpdateWidget(covariant FormAddress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.regionId != widget.regionId ||
        oldWidget.provincesId != widget.provincesId ||
        oldWidget.citiesId != widget.citiesId ||
        oldWidget.regionDesc != widget.regionDesc ||
        oldWidget.provincesDesc != widget.provincesDesc ||
        oldWidget.citiesDesc != widget.citiesDesc) {
      setState(() {
        presentRegionId = widget.regionId.toString();
        presentProvincesId = widget.provincesId.toString();
        presentCitiesId = widget.citiesId.toString();
        presentRegionDesc = widget.regionDesc.toString();
        presentProvincesDesc = widget.provincesDesc.toString();
        presentCitiesDesc = widget.citiesDesc.toString();
        newRegions = [
          {"regDesc": presentRegionDesc, "regCode": presentRegionId}
        ];
        newProvinces = [
          {"provDesc": presentProvincesDesc, "provCode": presentProvincesId}
        ];
        newCities = [
          {"citymunDesc": presentCitiesDesc, "citymunCode": presentCitiesId}
        ];
      });
      initializeData();
    }
  }

  Future<void> initializeData() async {
    List<Future> asyncTasks = [
      readJsonRegions(),
      readJsonProvinces(),
      readJsonCities(),
    ];

    await Future.wait(asyncTasks);

    if (presentRegionId != "") {
      provinces = provincesMaster
          .where(
            (provincesItem) =>
                provincesItem["regionCode"].toString() == presentRegionId,
          )
          .toList();
    }

    if (presentProvincesId != "") {
      cities = citiesMaster
          .where((citiesItem) =>
              citiesItem["provCode"].toString() == presentProvincesId)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FormHelper.dropDownWidgetWithLabel(
          context,
          "Region",
          "Select Region",
          presentRegionId,
          widget.enabled ? regions : newRegions,
          (onChangedVal) {
            setState(() {
              presentRegionId = onChangedVal;
              widget.onRegionIDChanged?.call(onChangedVal);

              for (var region in regions) {
                if (region["regCode"].toString() == onChangedVal.toString()) {
                  widget.onRegionDescChanged
                      ?.call(region["regDesc"].toString());

                  break;
                }
              }

              provinces = provincesMaster
                  .where(
                    (provincesItem) =>
                        provincesItem["regionCode"].toString() ==
                        onChangedVal.toString(),
                  )
                  .toList();
            });
          },
          (onValidateVal) {
            if (onValidateVal == null) {
              return "Please select Region";
            }
            return null;
          },
          optionLabel: "regDesc",
          optionValue: "regCode",
          labelBold: false,
          labelFontSize: 12,
          hintFontSize: 12,
          borderFocusColor: AppColors.primary.withOpacity(0.5),
          borderWidth: 1,
          borderColor: AppColors.primary.withOpacity(0.1),
          borderRadius: 4,
        ),
        FormHelper.dropDownWidgetWithLabel(
          context,
          "Province",
          "Select Province",
          presentProvincesId,
          widget.enabled ? provinces : newProvinces,
          // provinces,
          (onChangedVal) {
            setState(() {
              presentProvincesId = onChangedVal;
              widget.onProvincesIDChanged?.call(onChangedVal);
              // print("Provinces ID: $presentProvincesId");
              for (var province in provinces) {
                if (province["provCode"].toString() ==
                    onChangedVal.toString()) {
                  widget.onProvincesDescChanged
                      ?.call(province["provDesc"].toString());
                  // print(
                  //     "Province Description: ${province["provDesc"].toString()}");
                  break;
                }
              }
              cities = citiesMaster
                  .where(
                    (citiesItem) =>
                        citiesItem["provCode"].toString() ==
                        onChangedVal.toString(),
                  )
                  .toList();
              // presentCitiesId = '';
            });
          },
          (onValidate) {
            return null;
          },
          optionLabel: "provDesc",
          optionValue: "provCode",
          labelBold: false,
          labelFontSize: 12,
          hintFontSize: 12,
          borderFocusColor: AppColors.primary.withOpacity(0.5),
          borderWidth: 1,
          borderColor: AppColors.primary.withOpacity(0.1),
          borderRadius: 4,
        ),
        FormHelper.dropDownWidgetWithLabel(
          context,
          "City/Municipality",
          "Select City/Municipality",
          presentCitiesId,
          widget.enabled ? cities : newCities,
          // cities,
          (onChangedVal) {
            setState(() {
              presentCitiesId = onChangedVal;
              widget.onCitiesIDChanged?.call(onChangedVal);
              // print("Cities ID: $presentCitiesId");
              for (var city in cities) {
                if (city["citymunCode"].toString() == onChangedVal.toString()) {
                  widget.onCitiesDescChanged
                      ?.call(city["citymunDesc"].toString());
                  // print("City Description: ${city["citymunDesc"].toString()}");
                  break;
                }
              }
            });
          },
          (onValidate) {
            return null;
          },
          optionLabel: "citymunDesc",
          optionValue: "citymunCode",
          labelBold: false,
          labelFontSize: 12,
          hintFontSize: 12,
          borderFocusColor: AppColors.primary.withOpacity(0.5),
          borderWidth: 1,
          borderColor: AppColors.primary.withOpacity(0.1),
          borderRadius: 4,
        ),
      ],
    );
  }
}
