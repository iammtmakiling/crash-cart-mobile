// ignore_for_file: use_build_context_synchronously
import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/core/theme/app_text_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/api_requests/_api.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/initializedList.dart';

import 'package:dashboard/screens/screens.dart';
import 'package:dashboard/widgets/formWidgets/formTextArea.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';

import '../../widgets/formWidgets/formWidgets.dart';
import '../../globals.dart' as globals;

import 'dart:convert';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';

class AddInfoER extends StatefulWidget {
  final VoidCallback onBack;
  const AddInfoER({super.key, required this.onBack});

  @override
  AddInfoERState createState() => AddInfoERState();
}

class AddInfoERState extends State<AddInfoER>
    with SingleTickerProviderStateMixin {
  // Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Screens
  bool isSending = false;
  bool isSentSuccessfully = false;

  // Lists
  List<dynamic> externalCauses = [];
  List<dynamic> naturesOfInjuryList = [];
  List<dynamic> regions = [];
  List<dynamic> provincesMaster = [];
  List<dynamic> provinces = [];
  List<dynamic> citiesMaster = [];
  List<dynamic> cities = [];
  // List<dynamic> ICDCodes = [];
  // List<String> ICDCodesArray = [];

  // Address
  String address = "";

  // Present Address
  String presentRegionId = "";
  String presentProvincesId = "";
  String presentCitiesId = "";
  String presentRegionDesc = "";
  String presentProvincesDesc = "";
  String presentCitiesDesc = "";

  // Permanent Address
  String permanentRegionId = "";
  String permanentProvincesId = "";
  String permanentCitiesId = "";
  String permanentRegionDesc = "";
  String permanentProvincesDesc = "";
  String permanentCitiesDesc = "";

  // Place of Injury
  String regionId = "";
  String provincesId = "";
  String citiesId = "";
  String regionDesc = "";
  String provincesDesc = "";
  String citiesDesc = "";

  bool isSameAddress = false;

  // General Data
  String patientStatus = 'In-Hospital';
  late Map<String, dynamic> currentPatient;
  bool ifPatientExist = false;

  // Pre-Hospital Data
  bool visibleFirstAidGiven = false;
  bool visibleVehicularAccident = false;
  bool visibleMedicolegal = false;
  bool visibleCollision = false;

  // ER Data
  bool visibleTransferDetails = false;
  bool visiblePatientArrivalStatus = false;
  bool visibleOutrightSurgery = false;

  //Dropdown Values
  String ddChiefComplaint = 'Trauma/Injuries...';
  String ddMethodGiven = "";
  String ddPlaceofOccurence = "";
  String ddMedicolegal = "";
  String ddCavityForSurgery = "";

  late TabController _controller;

  // Unknown Patient
  bool isUnkown = false;

  List<String> phase = [
    'In-Hospital',
    'Pending Surgery',
    'Pending Discharge',
    'Deceased',
  ];
  List<String> errorFields = [];

  void permanentAddressReset() {
    permanentRegionId = "";
    permanentProvincesId = "";
    permanentCitiesId = "";
    permanentRegionDesc = "";
    permanentProvincesDesc = "";
    permanentCitiesDesc = "";
  }

  void presentAddressReset() {
    presentRegionId = "";
    presentProvincesId = "";
    presentCitiesId = "";
    presentRegionDesc = "";
    presentProvincesDesc = "";
    presentCitiesDesc = "";
  }

  //end of arrays to transfer to centralized data file

  Future<void> readJsonRegions() async {
    final String response =
        await rootBundle.loadString('assets/json/refregion.json');
    final data = await json.decode(response);
    setState(() {
      regions = data["RECORDS"];
    });
  }

  Future<void> readJsonProvinces() async {
    final String response =
        await rootBundle.loadString('assets/json/refprovince.json');
    final data = await json.decode(response);
    setState(() {
      provinces = data["RECORDS"];
    });
  }

  Future<void> readJsonCities() async {
    final String response =
        await rootBundle.loadString('assets/json/refcitymun.json');
    final data = await json.decode(response);
    setState(() {
      cities = data["RECORDS"];
    });
  }

  // General Info Widgets

  Padding ifUnknown() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            fillColor: isUnkown
                ? WidgetStateProperty.all(AppColors.primary)
                : WidgetStateProperty.all(AppColors.primary.withOpacity(0.1)),
            side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
            value: isUnkown,
            onChanged: (value) {
              setState(() {
                isUnkown = value!;
              });
            },
          ),
          const Text('Patient is Unkown'),
        ],
      ),
    );
  }

  Padding knownPatientDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        children: [
          patientName(),
          bdayAge(),
          genderPick(),
          presentPermanentAddress(),
          philhealthID(),
        ],
      ),
    );
  }

  Padding unknownPatientDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        children: [
          genderPick(),
        ],
      ),
    );
  }

  Padding patientName() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Patient Full Name",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: Column(
                  children: [
                    FormTextField(
                      name: 'lastName',
                      labelName: 'Last Name',
                      enabled: !ifPatientExist,
                      validator: FormBuilderValidators.required(),
                      onChanged: (value) async {
                        if (ifPatientExist == false) {
                          _formKey.currentState!.save();

                          Map<String, dynamic>? patientData =
                              await checkIfPatientExist(
                                  _formKey.currentState!.value);

                          if (patientData['isFound'] == true) {
                            showExistingPatient(
                                context, patientData['patient']);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    FormTextField(
                      name: 'firstName',
                      labelName: 'First Name',
                      enabled: !ifPatientExist,
                      validator: FormBuilderValidators.required(),
                      onChanged: (value) async {
                        if (ifPatientExist == false) {
                          _formKey.currentState!.save();

                          Map<String, dynamic>? patientData =
                              await checkIfPatientExist(
                                  _formKey.currentState!.value);

                          if (patientData['isFound'] == true) {
                            showExistingPatient(
                                context, patientData['patient']);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    FormTextField(
                      name: 'middleName',
                      labelName: 'Middle Name',
                      enabled: !ifPatientExist,
                      onChanged: (value) async {
                        if (ifPatientExist == false) {
                          _formKey.currentState!.save();

                          Map<String, dynamic>? patientData =
                              await checkIfPatientExist(
                                  _formKey.currentState!.value);

                          if (patientData['isFound'] == true) {
                            showExistingPatient(
                                context, patientData['patient']);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    FormTextField(
                      name: 'suffix',
                      labelName: 'Suffix',
                      enabled: !ifPatientExist,
                      onChanged: (value) async {
                        if (ifPatientExist == false) {
                          _formKey.currentState!.save();

                          Map<String, dynamic>? patientData =
                              await checkIfPatientExist(
                                  _formKey.currentState!.value);

                          if (patientData['isFound'] == true) {
                            showExistingPatient(
                                context, patientData['patient']);
                          }
                        }
                      },
                    ),
                  ],
                )),
          ],
        ));
  }

  Padding patientType() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Type of Patient",
              style: Theme.of(context).textTheme.bodyMedium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FormRadio(
              name: 'patientType',
              initialValue: 'ER',
              enabled: true,
              values: const ['ER', 'OPD', 'In-Patient', 'BHS', 'RHU'],
              texts: const ['ER', 'OPD', 'In-Patient', 'BHS', 'RHU'],
              validator: FormBuilderValidators.required(),
            ),
          ),
        ],
      ),
    );
  }

  Padding genderPick() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sex", style: Theme.of(context).textTheme.bodyMedium),
          FormRadio(
            name: 'gender',
            enabled: !ifPatientExist,
            values: const ['Male', 'Female'],
            texts: const ['Male', 'Female'],
          ),
        ],
      ),
    );
  }

  Future<void> showExistingPatient(
      BuildContext context, Map<String, dynamic> patient) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Is this the same patient?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "${patient['general']['firstName']} ${patient['general']['middleName'] ?? ''} ${patient['general']['lastName']} ${patient['general']['suffix'] ?? ''}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("Birthday: ${patient['general']['birthday']}"),
              if (patient['general']['sex'] != null)
                Text("Sex: ${patient['general']['sex']}"),
              const SizedBox(height: 8),
              const Text(
                "Permanent Address",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                  "City: ${patient['general']['permanentAddress']['cityMun']}"),
              Text(
                  "Province: ${patient['general']['permanentAddress']['province']}"),
              Text(
                  "Region: ${patient['general']['permanentAddress']['region']}"),
              const SizedBox(height: 8),
              const Text(
                'Present Address',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("City: ${patient['general']['presentAddress']['cityMun']}"),
              Text(
                  "Province: ${patient['general']['presentAddress']['province']}"),
              Text("Region: ${patient['general']['presentAddress']['region']}"),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        const BorderSide(color: Colors.cyan),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: MaterialButton(
                    color: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onPressed: () async {
                      ifPatientExist = true;
                      try {
                        _formKey.currentState!.fields['philHealthID']!
                            .didChange(patient['general']['philHealthID']);
                        _formKey.currentState!.fields['gender']!
                            .didChange(patient['general']['sex']);
                      } catch (e) {
                        // Handle any potential errors
                        // print("Error occurred: $e");
                      }

                      final Map<String, dynamic> permanentAddress =
                          patient['general']['permanentAddress'];
                      final Map<String, dynamic> presentAddress =
                          patient['general']['presentAddress'];

                      setState(() {
                        permanentRegionDesc = permanentAddress['region'];
                        permanentProvincesDesc = permanentAddress['province'];
                        permanentCitiesDesc = permanentAddress['cityMun'];
                        presentRegionDesc = presentAddress['region'];
                        presentProvincesDesc = presentAddress['province'];
                        presentCitiesDesc = presentAddress['cityMun'];
                      });

                      for (var region in regions) {
                        if (region["regDesc"] == permanentRegionDesc) {
                          setState(() {
                            permanentRegionId = region['regCode'];
                          });
                        }
                        if (region["regDesc"] == presentRegionDesc) {
                          setState(() {
                            presentRegionId = region['regCode'];
                          });
                        }
                        if (permanentRegionId.isNotEmpty &&
                            presentRegionId.isNotEmpty) {
                          break;
                        }
                      }

                      for (var province in provinces) {
                        if (province["provDesc"] == permanentProvincesDesc) {
                          setState(() {
                            permanentProvincesId = province['provCode'];
                          });
                        }
                        if (province["provDesc"] == presentProvincesDesc) {
                          setState(() {
                            presentProvincesId = province['provCode'];
                          });
                        }

                        if (permanentProvincesId.isNotEmpty &&
                            presentProvincesId.isNotEmpty) {
                          break;
                        }
                      }

                      for (var city in cities) {
                        if (city["citymunDesc"] == permanentCitiesDesc) {
                          setState(() {
                            permanentCitiesId = city['citymunCode'];
                          });
                        }
                        if (city["citymunDesc"] == presentCitiesDesc) {
                          setState(() {
                            presentCitiesId = city['citymunCode'];
                          });
                        }

                        if (permanentCitiesId.isNotEmpty &&
                            presentCitiesId.isNotEmpty) {
                          break;
                        }
                      }

                      currentPatient = patient;
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Padding bdayAge() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Birthday & Age",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            FormBuilderDateTimePicker(
              inputType: InputType.date,
              name: 'birthday',
              enabled: !ifPatientExist,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              format: DateFormat('yyyy-MM-dd'),
              onChanged: (DateTime? value) async {
                // ignore: prefer_typing_uninitialized_variables
                var patientAge;

                if (ifPatientExist == false) {
                  _formKey.currentState!.save();
                  Map<String, dynamic>? patientData =
                      await checkIfPatientExist(_formKey.currentState!.value);

                  if (patientData['isFound'] == true) {
                    showExistingPatient(context, patientData['patient']);
                  } else {}
                }

                setState(() {
                  // ignore: unnecessary_null_comparison
                  if (value == null) {
                  } else {
                    patientAge = calculateAge(value);
                    _formKey.currentState!.fields['age']!
                        .didChange(patientAge.toString());
                  }
                });
              },
              decoration: InputDecoration(
                labelText: 'Birthday',
                filled: true,
                fillColor: AppColors.primaryVariant.withOpacity(0.1),
                labelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                hintStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.error),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.error),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FormBuilderTextField(
              enabled: false,
              name: 'age',
              decoration: InputDecoration(
                labelText: 'Age',
                filled: true,
                fillColor: AppColors.textTertiary.withOpacity(0.01),
                labelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                hintStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.textTertiary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.error),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.error),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding presentPermanentAddress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Present Address",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          FormAddress(
            enabled: !ifPatientExist,
            regionDesc: permanentRegionDesc,
            provincesDesc: permanentProvincesDesc,
            citiesDesc: permanentCitiesDesc,
            regionId: presentRegionId,
            provincesId: presentProvincesId,
            citiesId: presentCitiesId,
            onRegionIDChanged: (String? newValue) {
              setState(() {
                presentRegionId = newValue!;
              });
            },
            onProvincesIDChanged: (String? newValue) {
              setState(() {
                presentProvincesId = newValue!;
              });
            },
            onCitiesIDChanged: (String? newValue) {
              setState(() {
                presentCitiesId = newValue!;
              });
            },
            onRegionDescChanged: (String? newValue) {
              setState(() {
                presentRegionDesc = newValue!;
              });
            },
            onProvincesDescChanged: (String? newValue) {
              setState(() {
                presentProvincesDesc = newValue!;
              });
            },
            onCitiesDescChanged: (String? newValue) {
              setState(() {
                presentCitiesDesc = newValue!;
              });
            },
          ),
          const SizedBox(height: 16),
          Text(
            "Permanent Address",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          if (!ifPatientExist)
            Row(
              children: [
                Checkbox(
                  fillColor: isSameAddress
                      ? WidgetStateProperty.all(AppColors.primary)
                      : WidgetStateProperty.all(
                          AppColors.primary.withOpacity(0.1)),
                  side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  value: isSameAddress,
                  onChanged: (value) {
                    setState(() {
                      isSameAddress = value!;
                      if (isSameAddress == true) {
                        permanentCitiesId = presentCitiesId;
                        permanentProvincesId = presentProvincesId;
                        permanentRegionId = presentRegionId;
                        permanentCitiesDesc = presentCitiesDesc;
                        permanentProvincesDesc = presentProvincesDesc;
                        permanentRegionDesc = presentRegionDesc;
                      } else {
                        permanentCitiesId = "";
                        permanentProvincesId = "";
                        permanentRegionId = "";
                        permanentCitiesDesc = "";
                        permanentProvincesDesc = "";
                        permanentRegionDesc = "";
                      }
                    });
                  },
                ),
                const Text('Same as Present Address'),
              ],
            ),
          const SizedBox(height: 5),
          if (isSameAddress != null && isSameAddress == false)
            FormAddress(
              enabled: !ifPatientExist,
              regionDesc: permanentRegionDesc,
              provincesDesc: permanentProvincesDesc,
              citiesDesc: permanentCitiesDesc,
              regionId: permanentRegionId,
              provincesId: permanentProvincesId,
              citiesId: permanentCitiesId,
              onRegionIDChanged: (String? newValue) {
                setState(() {
                  permanentRegionId = newValue!;
                });
              },
              onProvincesIDChanged: (String? newValue) {
                setState(() {
                  permanentProvincesId = newValue!;
                });
              },
              onCitiesIDChanged: (String? newValue) {
                setState(() {
                  permanentCitiesId = newValue!;
                });
              },
              onRegionDescChanged: (String? newValue) {
                setState(() {
                  permanentRegionDesc = newValue!;
                });
              },
              onProvincesDescChanged: (String? newValue) {
                setState(() {
                  permanentProvincesDesc = newValue!;
                });
              },
              onCitiesDescChanged: (String? newValue) {
                setState(() {
                  permanentCitiesDesc = newValue!;
                });
              },
            ),
        ],
      ),
    );
  }

  Padding philhealthID() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "PhilHealth ID",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: FormTextField(
              name: "philHealthID",
              labelName: "",
              enabled: !ifPatientExist,
            ),
          ),
        ],
      ),
    );
  }
  //End of General Info Widgets

  Padding dateTimeInjury() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 0, 0.0, 0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          FractionallySizedBox(
            widthFactor: 0.95,
            child: FormBuilderDateTimePicker(
              name: 'dateTimeInjury',
              firstDate: DateTime(1900),
              lastDate: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  DateTime.now().hour,
                  DateTime.now().minute),
              format: DateFormat('yyyy-MM-dd HH:mm:ss'),
              validator: FormBuilderValidators.required(),
              onChanged: (DateTime? value) {},
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.textTertiary.withOpacity(0.01),
                labelStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
                hintStyle: AppTextTheme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textTertiary,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary.withOpacity(0.1)),
                  borderRadius: BorderRadius.circular(8),
                ),
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: AppColors.textTertiary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primary.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.error),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: AppColors.error),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding condFirstAiderDetails() {
    // need validators for ID format
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "First Aider ID:",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormTextField(
              initialValue: userID, name: "firstAider", labelName: ""),
          const SizedBox(height: 16),
          Text(
            "Is first aid given properly?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormRadio(
            enabled: true,
            name: "firstAidGivenProperly",
            values: yesNoList,
            texts: yesNoList,
          ),
          const SizedBox(height: 8),
          Text(
            "Method given:",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormSearchableDropdown(
            formKey: _formKey,
            name: "methodGiven",
            selectedValue: ddMethodGiven,
            onChange: (value) {
              setState(() {
                ddMethodGiven = value!;
              });
            },
            items: ["Others", ...firstAidMethods],
            textFieldLabel: "Specify First Aid",
          ),
        ],
      ),
    );
  }

  Padding condVehicularAccident() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Type of Vehicular Accident?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FormRadio(
              enabled: true,
              name: 'typeVehicularAccident',
              values: vehicleAccidentType,
              texts: vehicleAccidentType,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Collision or Non-Collision",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormRadio(
            enabled: true,
            name: 'collisionOrNonCollision',
            values: const ['Collision', 'Non-Colision'],
            texts: const ['Collision', 'Non-Colision'],
            onChanged: (collisionValue) {
              if (collisionValue == "Collision") {
                setState(() {
                  visibleCollision = true;
                });
              } else {
                setState(() {
                  visibleCollision = false;
                });
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            "Patient's Vehicle",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormRadio(
            enabled: true,
            name: 'patientVehicle',
            values: ['(none) Pedestrian', ...vehiclesList],
            texts: ['(none) Pedestrian', ...vehiclesList],
          ),
          const SizedBox(height: 8),
          if (visibleCollision)
            Text(
              "Other Party's Vehicle",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          if (visibleCollision) const SizedBox(height: 8),
          if (visibleCollision)
            FormRadio(
              enabled: true,
              name: 'otherVehicle',
              values: ['(none) Pedestrian', ...vehiclesList],
              texts: ['(none) Pedestrian', ...vehiclesList],
            ),
          const SizedBox(height: 8),
          Text(
            "Position of Patient?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormRadio(
              enabled: true,
              name: 'positionOfPatient',
              values: positionOfPatientList,
              texts: positionOfPatientList),
          const SizedBox(height: 8),
          Text(
            "Place of Occurence?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormSearchableDropdown(
            formKey: _formKey,
            name: 'placeOfOccurrence',
            selectedValue: ddPlaceofOccurence,
            onChange: (value) {
              setState(() {
                ddPlaceofOccurence = value!;
                // print(ddMethodGiven);
              });
            },
            items: ["Others", ...placesOfOccurrence],
            textFieldLabel: "Specify Place",
          ),
          const SizedBox(height: 16),
          Text(
            "Activity During Injury?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const FormCheckbox(
            name: 'activityDuringAccident',
            options: ['Sports', 'Leisure', 'Work-related', 'Unknown'],
          ),
          const SizedBox(height: 16),
          Text(
            "Other risk factors at the time of the incident:",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormCheckbox(name: "otherRisksFactors", options: otherRisksFactors),
          const SizedBox(height: 16),
          Text(
            "Safety Issues? (Select all that apply)",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormCheckbox(name: 'safetyIssues', options: safetyIssues)
        ],
      ),
    );
  }

  Padding condMedicolegal() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Category",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormSearchableDropdown(
            formKey: _formKey,
            name: "medicolegalCategory",
            selectedValue: ddMedicolegal,
            onChange: (value) {
              setState(() {
                ddMedicolegal = value!;
              });
            },
            items: ["Others", ...medicolegalList],
            textFieldLabel: "Specify Category",
          ),
        ],
      ),
    );
  }

  Padding injuryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Place of Injury",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        FormAddress(
          enabled: true,
          regionId: regionId,
          provincesId: provincesId,
          citiesId: citiesId,
          onRegionIDChanged: (String? newValue) {
            setState(() {
              regionId = newValue!;
            });
          },
          onProvincesIDChanged: (String? newValue) {
            setState(() {
              provincesId = newValue!;
            });
          },
          onCitiesIDChanged: (String? newValue) {
            setState(() {
              citiesId = newValue!;
            });
          },
          onRegionDescChanged: (String? newValue) {
            setState(() {
              regionDesc = newValue!;
            });
          },
          onProvincesDescChanged: (String? newValue) {
            setState(() {
              provincesDesc = newValue!;
            });
          },
          onCitiesDescChanged: (String? newValue) {
            setState(() {
              citiesDesc = newValue!;
            });
          },
        ),
        const SizedBox(height: 16),
        Text(
          "Date and Time of Injury",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        dateTimeInjury(),
        const SizedBox(height: 16),
        Text(
          "Injury Intent",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        FormRadio(
            enabled: true,
            name: 'injuryType',
            values: injuryTypeList,
            texts: injuryTypeList),
      ]),
    );
  }

  Padding firstAidDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "First Aid Given",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        FormRadio(
          enabled: true,
          name: 'firstAidGiven',
          onChanged: (valueFirstAidGiven) {
            if (valueFirstAidGiven == "yes") {
              setState(() {
                visibleFirstAidGiven = true; //verify for conditional rendering
              });
            } else {
              setState(() {
                visibleFirstAidGiven = false; //verify for conditional rendering
              });
            }
          },
          values: const [
            'yes',
            'no',
          ],
          texts: const [
            'Yes',
            'No',
          ],
        ),
        Visibility(
          visible: visibleFirstAidGiven,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            child: condFirstAiderDetails(),
          ),
        ),
      ]),
    );
  }

  Padding natureOfInjuryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Nature of Injury",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
            decoration: BoxDecoration(
              color: AppColors.primaryVariant.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1.0,
              ),
            ),
            child: MultiSelectBottomSheetField(
              initialValue: naturesOfInjuryList,
              searchTextStyle: Theme.of(context).textTheme.bodyMedium,
              selectedItemsTextStyle: Theme.of(context).textTheme.bodyMedium,
              selectedColor: AppColors.primary,
              buttonIcon: const Icon(LucideIcons.chevronDown),
              chipDisplay: MultiSelectChipDisplay(
                height: 50,
                scroll: true,
              ),
              listType: MultiSelectListType.LIST,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Add",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              searchable: true,
              searchIcon: const Icon(Icons.search),
              items: naturesOfInjury.map((e) => MultiSelectItem(e, e)).toList(),
              onConfirm: (selectedItems) {
                setState(
                  () {
                    naturesOfInjuryList = selectedItems;
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          FormTextArea(
              name: "natureOfInjuryExtraInfo", labelName: "Additional Details"),
          const SizedBox(height: 16),
          Text(
            "External Causes of Injury",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.fromLTRB(12, 9, 12, 9),
            decoration: BoxDecoration(
              color: AppColors.primaryVariant.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary.withOpacity(0.1),
                width: 1.0,
              ),
            ),
            child: MultiSelectBottomSheetField(
              initialValue: externalCauses,
              searchTextStyle: Theme.of(context).textTheme.bodyMedium,
              selectedItemsTextStyle: Theme.of(context).textTheme.bodyMedium,
              selectedColor: AppColors.primary,
              buttonIcon: const Icon(LucideIcons.chevronDown),
              chipDisplay: MultiSelectChipDisplay(
                height: 50,
                scroll: true,
              ),
              listType: MultiSelectListType.LIST,
              title: const Text("Add"),
              searchable: true,
              searchIcon: const Icon(Icons.search),
              items: externalCausesInjury
                  .map((e) => MultiSelectItem(e, e))
                  .toList(),
              onConfirm: (selectedItems) {
                setState(
                  () {
                    externalCauses = selectedItems;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding vehicularDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vehicular Accident?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            FormRadio(
              enabled: true,
              name: 'vehicularAccidentBool',
              onChanged: (valueVehicularAccident) {
                if (valueVehicularAccident == "yes") {
                  setState(() {
                    visibleVehicularAccident = true;
                  });
                } else {
                  setState(() {
                    visibleVehicularAccident = false;
                  });
                }
              },
              values: const ['yes', 'no'],
              texts: const ['Yes', 'No'],
            ),
            Visibility(
              visible: visibleVehicularAccident,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.white,
                child: condVehicularAccident(),
              ),
            ),
          ]),
    );
  }

  Padding medicolegalDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        Text(
          "Medicolegal Case?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        FormRadio(
          enabled: true,
          name: 'medicolegalCase',
          onChanged: (valueMedicolegalCase) {
            if (valueMedicolegalCase == "yes") {
              setState(() {
                visibleMedicolegal = true;
              });
            } else {
              setState(() {
                visibleMedicolegal = false;
              });
            }
          },
          values: yesNoList,
          texts: yesNoList,
        ),
        Visibility(
          visible: visibleMedicolegal,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            child: condMedicolegal(),
          ),
        ),
      ]),
    );
  }

  Padding chiefComplaint() {
    // need validators for ID format
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chief Complaint",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormSearchableDropdown(
            formKey: _formKey,
            name: "methodGiven",
            selectedValue: ddChiefComplaint,
            onChange: (value) {
              setState(() {
                ddChiefComplaint = value!;
              });
            },
            items: ["Others", ...chiefComplaints],
            textFieldLabel: "Specify Chief Complaints",
          ),
        ],
      ),
    );
  }

  Padding massInjuryTF() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Mass Injury",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormRadio(
            enabled: true,
            name: 'massInjury',
            values: ['yes', 'no'],
            texts: ['Yes', 'No'],
          ),
        ],
      ),
    );
  }
  //End of PreHospital Widgets

  //End of ER Widget

  //Start of Layout Widgets
  Future<void> _showMissingDialog() async {
    var widthScreen = MediaQuery.of(context).size.width;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Please fill the missing details.",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  // you may want to use an aspect ratio here for tablet support
                  height: 200.0,
                  width: widthScreen * 90,
                  child: ListView.builder(
                    // store this controller in a State to save the carousel scroll position
                    // controller: PageController(viewportFraction: 0.9),
                    itemCount: errorFields.length,
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    itemBuilder: (context, index) {
                      return Text(
                        errorFields[index],
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        const BorderSide(color: Colors.cyan),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      errorFields = [];
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Patient Status:',
                textAlign: TextAlign.center,
              ),
              FormDropdown(
                name: 'patientStatus',
                initialValue: patientStatus,
                items: phase,
                onChange: (newValue) {
                  setState(() {
                    patientStatus = newValue.toString();
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                      side: WidgetStateProperty.all(
                        const BorderSide(color: Colors.cyan),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.cyan),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: MaterialButton(
                    color: Colors.cyan,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop();
                      _formKey.currentState!.save();
                      if (patientStatus != "") {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const PinCodeScreen(),
                              fullscreenDialog: true,
                            ));

                        if (result == true) {
                          setState(() {
                            isSending = true;
                          });

                          bool success = await _insertData(
                            _formKey.currentState!.value,
                          );

                          setState(() {
                            isSending = false;
                            if (success) {
                              isSentSuccessfully = true;
                            }
                          });
                        }
                      }
                      // }
                    },
                    child: const Text(
                      "Confirm",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Padding buttonNav(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ResetButton(
            onReset: () {
              // Form reset logic
              ifPatientExist = false;
              _formKey.currentState!.save();
              _formKey.currentState!.reset();

              // Update state
              setState(() {
                // Present Address
                presentRegionId = "";
                presentProvincesId = "";
                presentCitiesId = "";
                presentRegionDesc = "";
                presentProvincesDesc = "";
                presentCitiesDesc = "";

                // Permanent Address
                permanentRegionId = "";
                permanentProvincesId = "";
                permanentCitiesId = "";
                permanentRegionDesc = "";
                permanentProvincesDesc = "";
                permanentCitiesDesc = "";
              });
            },
          ),
        ],
      ),
    );
  }
  //Start of ER Widgets

  Padding patientTransferDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Patient Transferred?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormRadio(
            enabled: true,
            name: 'patientTransferred',
            onChanged: (valuePatientTransferred) {
              if (valuePatientTransferred == "yes") {
                setState(() {
                  visibleTransferDetails =
                      true; //verify for conditional rendering
                });
              } else {
                setState(() {
                  visibleTransferDetails =
                      false; //verify for conditional rendering
                });
              }
            },
            values: const ['yes', 'no'],
            texts: const ['Yes', 'No'],
          ),
          Visibility(
            visible: visibleTransferDetails,
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: Colors.white,
              child: condTransferDetails(),
            ),
          ),
        ],
      ),
    );
  }

  Padding patientArrivalDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        Text(
          "Status on Arrival?",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        FormRadio(
          enabled: true,
          name: "statusOnArrival",
          onChanged: (valuePatientArrival) {
            if (valuePatientArrival == "Alive") {
              setState(() {
                visiblePatientArrivalStatus = true;
              });
            } else {
              patientStatus = 'Deceased';
              _formKey.currentState!.fields['outcome']!.didChange('Died');

              setState(() {
                visiblePatientArrivalStatus = false;
              });
            }
          },
          values: const ['Dead on Arrival', 'Alive'],
          texts: const ['Dead on Arrival', 'Alive'],
        ),
        Visibility(
          visible: visiblePatientArrivalStatus,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            child: condArrivalStatus(),
          ),
        ),
      ]),
    );
  }

  Padding patientTransportationDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Model of Transportation",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormDropdown(
            name: "modeOfTransport",
            items: modeOfTranspo,
          )
        ],
      ),
    );
  }

  Padding patientStatusDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        // const Text(
        //   "Initial Impression",
        //   style: TextStyle(
        //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        const SizedBox(height: 8),
        const FormTextArea(
            name: 'initialImpression', labelName: "Initial Impression"),
        const SizedBox(height: 16),
        Text(
          "Outcome",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        FormRadio(
          enabled: patientStatus == 'Deceased' ? false : true,
          name: 'outcome',
          onChanged: (value) {
            if (value == 'Died') {
              patientStatus = 'Deceased';
            }
          },
          values: const ['Improved', 'Unimproved', 'Died'],
          texts: const ['Improved', 'Unimproved', 'Died'],
        ),
      ]),
    );
  }

  Padding patientOutrightSurgeryDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: 16),
        Text(
          "Outright Surgery",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        FormRadio(
          enabled: true,
          name: 'outrightSurgical',
          onChanged: (valueSurgical) {
            if (valueSurgical == "yes") {
              setState(() {
                visibleOutrightSurgery = true;
              });
            } else {
              setState(() {
                visibleOutrightSurgery = false;
              });
            }
          },
          values: const [
            'yes',
            'no',
          ],
          texts: const [
            'Yes',
            'No',
          ],
        ),
        Visibility(
          visible: visibleOutrightSurgery,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            color: Colors.white,
            child: condSurgicalDetails(),
          ),
        ),
      ]),
    );
  }

  Padding condTransferDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Is Referred?",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            FormRadio(
              enabled: true,
              name: "isReferred",
              values: ["yes", "no"],
              texts: ["yes", "no"],
            ),
            SizedBox(height: 16),
            Text(
              "Originating Hospital (ID)",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            FormTextField(name: "originatingHospitalID", labelName: ""),
            SizedBox(height: 16),
            Text(
              "Previous Physician (ID)",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            FormTextField(name: "previousPhysicianID", labelName: ''),
          ]),
    );
  }

  Padding condArrivalStatus() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "State on Arrival?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormRadio(
            enabled: true,
            name: "aliveStatus",
            values: ["Conscious", "Unconscious", "In Extremis"],
            texts: ["Conscious", "Unconscious", "In Extremis"],
          )
        ],
      ),
    );
  }

  Padding condSurgicalDetails() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Cavity for surgery:",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormSearchableDropdown(
            formKey: _formKey,
            name: "cavityForSurgery",
            selectedValue: ddCavityForSurgery,
            onChange: (value) {
              setState(() {
                ddCavityForSurgery = value!;
              });
            },
            items: ["Others", ...cavitiesForSurgery],
            textFieldLabel: "Specify Cavity",
          ),
          const SizedBox(height: 16),
          Text(
            "Services on Board",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          FormCheckbox(name: "servicesOnboardSurgery", options: servicesOnboard)
        ],
      ),
    );
  }

  //End of ER Widget

  //End of Layout Widgets

  Future<bool> _insertData(Map<String, dynamic> formValues) async {
    if (visiblePatientArrivalStatus == false) {
      _formKey.currentState!.fields['statusOnArrival']!
          .didChange('Dead on Arrival');
    }

    //generate patientID based on location
    late String encryptedPatientID = "";
    late Map<String, dynamic> general = {};
    if (ifPatientExist == false) {
      var patientDesc = "";
      if (!isUnkown) {
        patientDesc =
            await generatePatientID(permanentCitiesId, permanentCitiesDesc);
      } else {
        patientDesc = await generatePatientID(citiesId, citiesDesc);
      }
      encryptedPatientID = encryp(patientDesc);

      if (isUnkown) {
        general = {
          "isIdentified": nullChecker("yes"),
          "firstName": formValues["gender"] == "Male"
              ? nullChecker("John")
              : nullChecker("Jane"),
          "middleName": null,
          "lastName": nullChecker("Doe"),
          "suffix": null,
          "birthday": null,
          "sex": nullChecker(formValues["gender"]),
          "presentAddress": {
            "cityMun": null,
            "province": null,
            "region": null,
          },
          "permanentAddress": {
            "cityMun": nullChecker(citiesDesc),
            "province": nullChecker(provincesDesc),
            "region": nullChecker(regionDesc),
          },
          "philHealthID": null,
        };
      } else {
        general = {
          "firstName": nullChecker(formValues["firstName"]),
          "middleName": nullChecker(formValues["middleName"]),
          "lastName": nullChecker(formValues["lastName"]),
          "suffix": nullChecker(formValues["suffix"]),
          "birthday":
              nullChecker(formValues["birthday"].toString().split(" ")[0]),
          "sex": nullChecker(formValues["gender"]),
          "presentAddress": {
            "cityMun": nullChecker(presentCitiesDesc),
            "province": nullChecker(presentProvincesDesc),
            "region": nullChecker(presentRegionDesc),
          },
          "permanentAddress": {
            "cityMun": nullChecker(permanentCitiesDesc),
            "province": nullChecker(permanentProvincesDesc),
            "region": nullChecker(permanentRegionDesc),
          },
          "philHealthID": nullChecker(formValues["philHealthID"]),
        };
      }
    }

    final recordDesc = await generateRecordID();
    final encryptedRecordID = encryp(recordDesc);

    var createHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    // print("NEW PATIENT");
    // print(ddMethodGiven);

    Map<String, dynamic> prehospital = {
      "externalCauses": encryptList(externalCauses),
      "editHistory": [],
      "injuryTimestamp": formValues["dateTimeInjury"].toString(),
      "createHistory": createHistory,
      "chiefComplaint": nullChecker(ddChiefComplaint),
      "firstAid": {
        "firstAider": formValues["firstAider"],
        "isGiven": nullChecker(formValues["firstAidGiven"]),
        "isStandard": nullChecker(formValues["firstAidGivenProperly"]),
        "methodGiven": nullChecker(ddMethodGiven),
      },
      "injuryIntent": nullChecker(formValues["injuryType"]),
      "placeOfInjury": {
        "region": nullChecker(regionDesc),
        "province": nullChecker(provincesDesc),
        "cityMun": nullChecker(citiesDesc)
      },
      "massInjury": nullChecker(formValues["massInjury"]),
      "medicolegal": {
        "isMedicolegal": nullChecker(formValues["medicolegalCase"]),
        "medicolegalCategory": nullChecker(formValues["medicolegalCategory"])
      },
      "natureOfInjury": encryptList(naturesOfInjuryList),
      "natureOfInjuryExtraInfo":
          nullChecker(formValues["natureOfInjuryExtraInfo"]),
      "vehicularAccident": {
        "preInjuryActivity": encryptList(formValues["activityDuringAccident"]),
        "collision": nullChecker(formValues["collisionOrNonCollision"]),
        "safetyIssues": encryptList(formValues["safetyIssues"]),
        "otherRisksFactors": encryptList(formValues["otherRisksFactors"]),
        "type": nullChecker(formValues["typeVehicularAccident"]),
        "placeOfOccurrence": nullChecker(ddPlaceofOccurence),
        "position": nullChecker(formValues["positionOfPatient"]),
        "isVehicular": nullChecker(formValues["vehicularAccidentBool"]),
        "vehiclesInvolved": {
          "otherVehicle": nullChecker(formValues["otherVehicle"]),
          "patientVehicle": nullChecker(formValues["patientVehicle"]),
        }
      },
    };

    Map<String, dynamic> er = {
      "isTransferred": nullChecker(formValues["patientTransferred"]),
      "previousHospitalID": formValues["originatingHospitalID"],
      "previousPhysicianID": formValues["previousPhysicianID"],
      "isReferred": nullChecker(formValues["isReferred"]),
      "servicesOnboard": encryptList(formValues["servicesOnboardSurgery"]),
      "editHistory": [],
      "createHistory": createHistory,
      "aliveCategory": nullChecker(formValues["aliveStatus"]),
      "cavityInvolved": nullChecker(ddCavityForSurgery),
      "dispositionER": encryp(patientStatus),
      "externalCauseICD": null,
      "natureofInjuryICD": null,
      "initialImpression": nullChecker(formValues["initialImpression"]),
      "isSurgical": nullChecker(formValues["outrightSurgical"]),
      "outcome": nullChecker(formValues["outcome"]),
      "statusOnArrival": nullChecker(formValues["statusOnArrival"]),
      "transportation": nullChecker(formValues["modeOfTransport"]),
    };
    Map<String, dynamic> newRecord = {
      "hospitalID": hospitalID,
      "patientID": encryptedPatientID != ""
          ? encryptedPatientID
          : encryp(currentPatient['patientID']),
      "patientStatus": encryp(patientStatus),
      "patientType": encryp(formValues['patientType']),
      "recordID": encryptedRecordID,
      "general": ifPatientExist ? currentPatient['general'] : general,
      "preHospital": prehospital,
      "er": er,
      "surgery": {},
      "inHospital": {},
      "discharge": {},
    };

    // if (ifPatientExist == false) {
    //   Map<String, dynamic> newPatient = {
    //     "patientID": encryptedPatientID,
    //     "general": general,
    //     "lastHospital": null,
    //     "lastStatus": null,
    //     "patientHistory": []
    //   };
    //   print("NEW PATIENT");
    //   print(newPatient);
    //   await addNewPatient(newPatient, globals.bearerToken);
    // }
    // print("NEW PRECORD");
    // print(newRecord);
    // await addNewRecord(newRecord, globals.bearerToken);
    try {
      // Simulate an error randomly (remove this in production)
      // if (Random().nextBool()) {
      //   throw Exception("Simulated API error");
      // }

      if (!ifPatientExist) {
        Map<String, dynamic> newPatient = {
          "patientID": encryptedPatientID,
          "general": general,
          "lastHospital": null,
          "lastStatus": null,
          "patientHistory": []
        };
        // print("NEW PATIENT");
        // print(newPatient);
        await addNewPatient(newPatient, globals.bearerToken);
      }
      // print("NEW PRECORD");
      // print(newRecord);
      await addNewRecord(newRecord, globals.bearerToken);
      return true;
    } catch (e) {
      // print("Error occurred: $e");
      showErrorModal(context, e.toString());
      return false;
    }
  }

  void showErrorModal(BuildContext context, String errorMessage) {
    List<String> errorFields = [
      "API Error: $errorMessage",
      "Please try again later.",
      "If the problem persists, contact support."
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ErrorModal(
          errorFields: errorFields,
          onClose: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    // readJsonICDCodes();
    readJsonRegions();
    readJsonProvinces();
    readJsonCities();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // isSending
            //     ? const SendingWidget()
            //     : isSentSuccessfully
            //         ? SuccessfulWidget(
            //             message: "Successful!",
            //             onPressed: () {
            //               Navigator.of(context).pushReplacement(
            //                 MaterialPageRoute(
            //                   builder: (context) => const MainNavigation(),
            //                 ),
            //               );
            //             },
            //           )
            //         :
            Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: 3,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Text("Adding Patient Data",
                        style: Theme.of(context).textTheme.titleLarge),
                    leading: IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(LucideIcons.arrowLeft),
                    ),
                    centerTitle: true,
                    bottom: TabBar(
                      isScrollable: false,
                      labelStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                      unselectedLabelStyle: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textSecondary),
                      indicator: const UnderlineTabIndicator(
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 2),
                        insets: EdgeInsets.zero,
                      ),
                      controller: _controller,
                      tabs: <Widget>[
                        Tab(
                          text: "General",
                        ),
                        Tab(
                          text: "Pre-Hospital",
                        ),
                        Tab(
                          text: "ER",
                        ),
                      ],
                    ),
                  ),
                  body: FormBuilder(
                    key: _formKey,
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        // General Data
                        Scaffold(
                          persistentFooterButtons: [buttonNav(context)],
                          body: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        ifUnknown(),
                                        Divider(
                                            color: AppColors.primary
                                                .withOpacity(0.1)),
                                        Visibility(
                                          visible: isUnkown,
                                          child: unknownPatientDetails(),
                                        ),
                                        Visibility(
                                          visible: !isUnkown,
                                          child: knownPatientDetails(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // PreHospital Data
                        Scaffold(
                          persistentFooterButtons: [buttonNav(context)],
                          body: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        patientType(),
                                        injuryDetails(),
                                        firstAidDetails(),
                                        chiefComplaint(),
                                        vehicularDetails(),
                                        medicolegalDetails(),
                                        massInjuryTF(),
                                        natureOfInjuryDetails(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //ER Data
                        Scaffold(
                          body: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                patientTransferDetails(),
                                patientArrivalDetails(),
                                patientTransportationDetails(),
                                patientStatusDetails(),
                                patientOutrightSurgeryDetails(),
                              ],
                            )),
                          ),
                          persistentFooterButtons: [
                            FormBottomButton(
                              formKey: _formKey,
                              onSubmitPressed: () async {
                                _formKey.currentState!.save();
                                var value = _formKey.currentState!.value;

                                // Helper function to check and add errors
                                void checkField(
                                    dynamic fieldValue, String fieldName) {
                                  if (fieldValue == null || fieldValue == "") {
                                    errorFields.add(fieldName);
                                  }
                                }

                                // General Infos
                                if (isUnkown) {
                                  checkField(value['gender'], 'Sex');
                                } else {
                                  checkField(value['gender'], 'Sex');
                                  checkField(value['firstName'], 'firstName');
                                  checkField(value['lastName'], 'lastName');
                                  checkField(value['birthday'], 'birthday');
                                  checkField(
                                      presentCitiesId, 'present address');
                                  checkField(
                                      permanentCitiesId, 'permanent address');
                                }

                                // Emergency Room Infos
                                checkField(
                                    value['patientType'], 'patient type');
                                checkField(
                                    externalCauses.isNotEmpty ? true : "",
                                    'external causes');
                                checkField(
                                    naturesOfInjuryList.isNotEmpty ? true : "",
                                    'natures of injury');
                                if (regionId == "" &&
                                    provincesId == "" &&
                                    citiesId == "") {
                                  errorFields.add('place of injury');
                                }

                                // Medicolegal
                                if (value["medicolegalCase"] == "yes") {
                                  checkField(ddMedicolegal, 'Is Medicolegal');
                                }

                                // Vehicular accident-specific checks
                                if (value['vehicularAccidentBool'] == "yes") {
                                  checkField(value['collisionOrNonCollision'],
                                      'collision');
                                  checkField(value['typeVehicularAccident'],
                                      'Vehicular Accident Type');
                                  checkField(ddPlaceofOccurence,
                                      'Vehicular Place of Occurrence');
                                  checkField(value['positionOfPatient'],
                                      'Vehicular Patient Position');
                                  checkField(value['activityDuringAccident'],
                                      'Vehicular Patient PreInjury Activity');
                                }

                                // Show confirmation or missing fields dialog
                                if (errorFields.isEmpty) {
                                  _showConfirmationDialog();
                                } else {
                                  _showMissingDialog();
                                }
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
