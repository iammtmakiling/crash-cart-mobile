// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/core/api_requests/_api.dart';
import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/core/theme/app_text_theme.dart';
import 'package:dashboard/core/utils/utility.dart';
import 'package:dashboard/widgets/widgets.dart';
import 'package:dashboard/initializedList.dart';
import 'package:dashboard/screens/screens.dart';

class AddEmergencyRoomData extends StatefulWidget {
  final VoidCallback onBack;
  const AddEmergencyRoomData({super.key, required this.onBack});

  @override
  AddEmergencyRoomDataState createState() => AddEmergencyRoomDataState();
}

class AddEmergencyRoomDataState extends State<AddEmergencyRoomData>
    with SingleTickerProviderStateMixin {
// Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

// Authentication
  String bearerToken = "";
  String userID = "";

// Screens
  bool isSending = false;
  bool isSentSuccessfully = false;

// Lists
  List<dynamic> regions = [];
  List<dynamic> provincesMaster = [];
  List<dynamic> provinces = [];
  List<dynamic> citiesMaster = [];
  List<dynamic> cities = [];

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

// General Data
  String patientStatus = 'In-Hospital';
  late Map<String, dynamic> currentPatient;
  bool ifPatientExist = false;

// Dropdown Values
  String ddPlaceofOccurence = "";
  String ddMechanismOfInjury = "";
  String ddVehicularCrashPatient = "";
  String ddPastMedicalHistory = "";
  String ddBodyInjury = "";

// Tab Controller
  late TabController _controller;

// Unknown Patient
  bool isUnkown = false;

// Phase States
  List<String> phase = [
    'In-Hospital',
    'Pending Surgery',
    'Pending Discharge',
    'Deceased',
  ];

// Error Fields
  List<String> errorFields = [];

// Methods
  void permanentAddressReset() {
    permanentRegionId = "";
    permanentProvincesId = "";
    permanentCitiesId = "";
    permanentRegionDesc = "";
    permanentProvincesDesc = "";
    permanentCitiesDesc = "";
  }

  Future<void> _loadLocationData() async {
    final regionsData = await LocationUtils.readJsonRegions();
    final provincesData = await LocationUtils.readJsonProvinces();
    final citiesData = await LocationUtils.readJsonCities();

    setState(() {
      regions = regionsData;
      provinces = provincesData;
      cities = citiesData;
    });
  }

  // General Info Widgets

  Padding ifUnknown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          patientName(),
          bdayAge(),
          genderPick(),
          presentPermanentAddress(),
          occupation(),
        ],
      ),
    );
  }

  Padding unknownPatientDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            const SizedBox(height: 8),
            TitleWidget(title: "Patient Full Name", isRequired: true),
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

  Padding genderPick() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Sex", isRequired: true),
          const SizedBox(height: 8),
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
                        _formKey.currentState!.fields['gender']!
                            .didChange(patient['general']['sex']);
                      } catch (e) {
                        // Handle any potential errors
                        // print("Error occurred: $e");
                      }

                      final Map<String, dynamic> permanentAddress =
                          patient['general']['permanentAddress'];

                      setState(() {
                        permanentRegionDesc = permanentAddress['region'];
                        permanentProvincesDesc = permanentAddress['province'];
                        permanentCitiesDesc = permanentAddress['cityMun'];
                      });

                      for (var region in regions) {
                        if (region["regDesc"] == permanentRegionDesc) {
                          setState(() {
                            permanentRegionId = region['regCode'];
                          });
                        }
                      }

                      for (var province in provinces) {
                        if (province["provDesc"] == permanentProvincesDesc) {
                          setState(() {
                            permanentProvincesId = province['provCode'];
                          });
                        }
                      }

                      for (var city in cities) {
                        if (city["citymunDesc"] == permanentCitiesDesc) {
                          setState(() {
                            permanentCitiesId = city['citymunCode'];
                          });
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
            TitleWidget(title: "Birthday & Age", isRequired: true),
            const SizedBox(height: 8),
            FormDateTimePicker(
              name: 'birthday',
              enabled: !ifPatientExist,
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
            ),
            const SizedBox(height: 8),
            FormBuilderTextField(
              enabled: false,
              name: 'age',
              decoration: InputDecoration(
                labelText: '0',
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
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Address", isRequired: true),
          const SizedBox(height: 8),
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

  Padding occupation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "Occupation", isRequired: true),
        const SizedBox(height: 8),
        FormTextField(
            name: "occupation", labelName: "e.g. Farmer, Teacher, etc."),
      ]),
    );
  }

  //End of General Info Widgets

  Padding condVehicularAccident() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "Vehicular Crash Patient", isRequired: true),
        FormRadio(
          enabled: true,
          name: 'vehicularCrash',
          values: vehiclesList,
          texts: vehiclesList,
        ),
        const SizedBox(height: 16),
        TitleWidget(title: "Other Party", isRequired: true),
        FormRadio(
          enabled: true,
          name: 'vehicularCrashOtherParty',
          values: vehiclesList,
          texts: vehiclesList,
        ),
        const SizedBox(height: 16),
        TitleWidget(title: "With Helmet?", isRequired: true),
        if (ddMechanismOfInjury == 'Vehicular Crash')
          FormRadio(
            enabled: true,
            name: 'withHelmet',
            values: yesNoList,
            texts: yesNoList,
          )
      ]),
    );
  }

  Padding condFall() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "Height of Fall", isRequired: true),
        const SizedBox(height: 8),
        FormRadio(
          enabled: true,
          name: 'fall',
          values: ['<1 meters', '1-3 meters', '3-6 meters', '>6 meters'],
          texts: ['<1 meters', '1-3 meters', '3-6 meters', '>6 meters'],
        )
      ]),
    );
  }

  Padding condStab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "Weapon Used", isRequired: true),
        const SizedBox(height: 8),
        FormTextField(
            name: "weaponUsed", labelName: "e.g. Knife, Machete, etc."),
        const SizedBox(height: 16),
        TitleWidget(title: "Weapon Length", isRequired: true),
        const SizedBox(height: 8),
        FormTextField(
            name: "weaponLength", labelName: "e.g. 10 cm, 15 cm, etc.")
      ]),
    );
  }

  Padding condGunshot() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "Gunshot", isRequired: true),
        const SizedBox(height: 8),
        FormRadio(
          enabled: true,
          name: 'gunshot',
          values: ['Single', 'Multiple Gunshot'],
          texts: ['Single', 'Multiple Gunshot'],
        ),
        const SizedBox(height: 16),
        TitleWidget(title: "Caliber of Bullet", isRequired: true),
        const SizedBox(height: 8),
        FormTextField(
            name: "caliberOfBullet", labelName: "e.g. 9mm, 45mm, etc.")
      ]),
    );
  }

  Padding condBurn() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "Burn", isRequired: true),
        const SizedBox(height: 8),
        FormRadio(
          enabled: true,
          name: 'burn',
          values: [
            'Flame',
            'Scald',
            'Flash',
            'Chemical',
            'Contact',
            'Friction',
          ],
          texts: [
            'Flame',
            'Scald',
            'Flash',
            'Chemical',
            'Contact',
            'Friction',
          ],
        ),
        const SizedBox(height: 16),
        TitleWidget(title: "TBSA", isRequired: true),
        const SizedBox(height: 8),
        FormTextField(name: "tbsa", labelName: "e.g. 10%, 20%, etc."),
        const SizedBox(height: 16),
        TitleWidget(title: "Burn Area", isRequired: true),
        const SizedBox(height: 8),
        FormTextArea(
            name: "burnArea", labelName: "e.g. Left Leg, Right Hand, etc.")
      ]),
    );
  }

  Padding condCrushingInjury() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "What crushed the patient?", isRequired: true),
        const SizedBox(height: 8),
        FormTextField(
            name: "crushingInjuryType", labelName: "e.g. Tree, Rock, etc.")
      ]),
    );
  }

  Padding mechanismOfInjury() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TitleWidget(title: "Mechanism of Injury", isRequired: true),
              const SizedBox(height: 8),
              FormDropdown(
                name: 'mechanismOfInjury',
                initialValue: ddMechanismOfInjury,
                items: [...mechanismOfInjuryList],
                onChange: (value) {
                  setState(() {
                    ddMechanismOfInjury = value.toString();
                  });
                },
              ),
              Visibility(
                visible: ddMechanismOfInjury == 'Other',
                child: FormTextField(
                    name: 'otherMechanismOfInjury',
                    labelName: "Specify Mechanism"),
              ),
              const SizedBox(height: 16),
              Visibility(
                visible: ddMechanismOfInjury == 'Vehicular Crash',
                child: CustomCard(
                  child: condVehicularAccident(),
                ),
              ),
              Visibility(
                visible: ddMechanismOfInjury == 'Fall',
                child: CustomCard(
                  child: condFall(),
                ),
              ),
              Visibility(
                visible: ddMechanismOfInjury == 'Stab',
                child: CustomCard(
                  child: condStab(),
                ),
              ),
              Visibility(
                visible: ddMechanismOfInjury == 'Gunshot',
                child: CustomCard(
                  child: condGunshot(),
                ),
              ),
              Visibility(
                visible: ddMechanismOfInjury == 'Burn',
                child: CustomCard(
                  child: condBurn(),
                ),
              ),
              Visibility(
                visible: ddMechanismOfInjury == 'Crushing Injury',
                child: CustomCard(
                  child: condCrushingInjury(),
                ),
              ),
            ]));
  }

  Padding injuryDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TitleWidget(title: "Date & Time of Injury", isRequired: true),
        const SizedBox(height: 8),
        FormDateTimePicker(
          name: 'dateTimeInjury',
          lastDate: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            DateTime.now().hour,
            DateTime.now().minute,
          ),
          isRequired: true,
          onChanged: (DateTime? value) {},
        ),
        const SizedBox(height: 16),
        TitleWidget(title: "Place of Injury", isRequired: true),
        const SizedBox(height: 8),
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
      ]),
    );
  }

  Padding exsanguination() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Actively Bleeding", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'activelyBleeding',
            values: yesNoList,
            texts: yesNoList,
          ),
          const SizedBox(height: 8),
          TitleWidget(title: "With blood on the scene", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'withBloodOnScene',
            values: yesNoList,
            texts: yesNoList,
          ),
        ],
      ),
    );
  }

  Padding airway() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Patient Airway", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'patientAirway',
            values: yesNoList,
            texts: yesNoList,
          ),
          const SizedBox(height: 8),
          TitleWidget(title: "Spontaneous Speech", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'spontaneousSpeech',
            values: yesNoList,
            texts: yesNoList,
          ),
          const SizedBox(height: 8),
          TitleWidget(title: "Cervical Tenderness", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'cervicalTenderness',
            values: yesNoList,
            texts: yesNoList,
          ),
        ],
      ),
    );
  }

  Padding breathing() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "In respiratory distress", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'inRespiratoryDistress',
            values: yesNoList,
            texts: yesNoList,
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.primary.withOpacity(0.1)),
          Text(
            "Breath Sounds",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(title: "Clear Breath Sounds", isRequired: true),
                const SizedBox(height: 8),
                FormRadio(
                  enabled: true,
                  name: 'clearBreathSounds',
                  values: yesNoList,
                  texts: yesNoList,
                ),
                const SizedBox(height: 8),
                TitleWidget(title: "Decreased Breath Sounds", isRequired: true),
                const SizedBox(height: 8),
                FormRadio(
                  enabled: true,
                  name: 'decreasedBreathSounds',
                  values: ['Left', 'Right', 'Both', 'None'],
                  texts: ['Left', 'Right', 'Both', 'None'],
                ),
                const SizedBox(height: 8),
                TitleWidget(title: "RR", isRequired: true),
                const SizedBox(height: 8),
                FormTextArea(
                  enabled: true,
                  name: 'rr',
                  labelName: '',
                ),
                const SizedBox(height: 8),
                TitleWidget(title: "O2 Support", isRequired: true),
                const SizedBox(height: 8),
                FormTextArea(
                  enabled: true,
                  name: 'o2Support',
                  labelName: '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding circulation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Blood Pressure", isRequired: true),
          const SizedBox(height: 8),
          FormTextField(
            enabled: true,
            name: 'bloodPressure',
            labelName: 'e.g. 120/80, 110/70, etc.',
          ),
          const SizedBox(height: 8),
          TitleWidget(title: "Heart Rate", isRequired: true),
          const SizedBox(height: 8),
          FormTextField(
            enabled: true,
            name: 'heartRate',
            labelName: 'e.g. 120, 110, etc.',
          ),
          const SizedBox(height: 8),
          TitleWidget(title: "Heart Sounds", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'heartSounds',
            values: ['Normal', 'Distinct', 'Muffled'],
            texts: ['Normal', 'Distinct', 'Muffled'],
          ),
          const SizedBox(height: 8),
          TitleWidget(title: "Pulses", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'pulses',
            values: ['Full and Equal', 'Thready', 'Absent Pulses'],
            texts: ['Full and Equal', 'Thready', 'Absent Pulses'],
          ),
        ],
      ),
    );
  }

  Padding disability() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "GCS - Equal to the score of each component",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(title: "Eye opening (Grade 1-4)", isRequired: true),
                const SizedBox(height: 8),
                FormRadio(
                  enabled: true,
                  name: 'eyeOpening',
                  values: ['1', '2', '3', '4'],
                  texts: ['1', '2', '3', '4'],
                ),
                const SizedBox(height: 8),
                TitleWidget(
                    title: "Verbal Response (Grade 1-5)", isRequired: true),
                const SizedBox(height: 8),
                FormRadio(
                  enabled: true,
                  name: 'verbalResponse',
                  values: ['1', '2', '3', '4', '5'],
                  texts: ['1', '2', '3', '4', '5'],
                ),
                const SizedBox(height: 8),
                TitleWidget(
                    title: "Motor Response (Grade 1-6)", isRequired: true),
                const SizedBox(height: 8),
                FormRadio(
                  enabled: true,
                  name: 'motorResponse',
                  values: ['1', '2', '3', '4', '5', '6'],
                  texts: ['1', '2', '3', '4', '5', '6'],
                ),
              ],
            ),
          ),
          Divider(color: AppColors.primary.withOpacity(0.1)),
          const SizedBox(height: 8),
          TitleWidget(title: "Pupils", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'pupils',
            values: [
              'Reactive to light',
              'Dilated',
              'Anisocoric',
              'Non-reactive'
            ],
            texts: [
              'Reactive to light',
              'Dilated',
              'Anisocoric',
              'Non-reactive'
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Padding exposure() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Body Injury", isRequired: true),
          const SizedBox(height: 8),
          FormDropdown(
            name: 'bodyInjury',
            items: [
              'Laceration',
              'Abrasion',
              'Contusion',
              'Hematoma',
              'Avulsed wound',
              'Punctured wound',
              'Fracture deformity',
              'Mangled extremity',
              'Burn',
            ],
            onChange: (dynamic value) {
              setState(() {
                ddBodyInjury = value ?? '';
              });
            },
          ),
          Visibility(
            visible: ddBodyInjury == 'Burn',
            child: CustomCard(
              child: condBurnPrimaryInjury(),
            ),
          ),
          const SizedBox(height: 8),
          Visibility(
            visible: ddBodyInjury == 'Mangled extremity',
            child: CustomCard(
              child: condMangledExtremity(),
            ),
          ),
        ],
      ),
    );
  }

  Padding otherFactors() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Obstetrics",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWidget(title: "Age of Gestation", isRequired: true),
                const SizedBox(height: 8),
                FormTextField(
                  enabled: true,
                  name: 'ageOfGestationalAge',
                  labelName: '',
                ),
                const SizedBox(height: 8),
                TitleWidget(title: "With Vaginal Bleeding", isRequired: true),
                const SizedBox(height: 8),
                FormRadio(
                  enabled: true,
                  name: 'withVaginalBleeding',
                  values: ['yes', 'no'],
                  texts: ['Yes', 'No'],
                ),
              ],
            ),
          ),
          Divider(color: AppColors.primary.withOpacity(0.1)),
          const SizedBox(height: 8),
          TitleWidget(title: "Pediatrics", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'pediatrics',
            values: ['yes', 'no'],
            texts: ['Yes', 'No'],
          ),
          const SizedBox(height: 8),
          TitleWidget(title: "Geriatrics", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'geriatrics',
            values: ['yes', 'no'],
            texts: ['Yes', 'No'],
          ),
        ],
      ),
    );
  }

  Padding condMangledExtremity() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Mangled Extremity", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'mangledExtremity',
            values: ['Laterality', 'Upper or Lower Extremity'],
            texts: ['Laterality', 'Upper or Lower Extremity'],
          ),
        ],
      ),
    );
  }

  Padding condBurnPrimaryInjury() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Burn Thickness",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'burnThickness',
            values: ['Superficial', 'Partial Thickness', 'Full Thickness'],
            texts: ['Superficial', 'Partial Thickness', 'Full Thickness'],
          ),
        ],
      ),
    );
  }

  Padding ample() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "Allergies", isRequired: true),
          const SizedBox(height: 8),
          FormTextArea(
            enabled: true,
            name: 'allergies',
            labelName: '',
          ),
          const SizedBox(height: 16),
          TitleWidget(title: "Medications", isRequired: true),
          const SizedBox(height: 8),
          FormTextArea(
            enabled: true,
            name: 'medications',
            labelName: '',
          ),
          const SizedBox(height: 16),
          TitleWidget(title: "Past Medical History", isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'pastMedicalHistory',
            values: [
              'Hypertension',
              'Diabetes',
              'Bronchial asthma',
              'Blood dyscrasia',
              'CKD',
              'CHF',
              'Cancer',
              'Others'
            ],
            texts: [
              'Hypertension',
              'Diabetes',
              'Bronchial asthma',
              'Blood dyscrasia',
              'CKD',
              'CHF',
              'Cancer',
              'Others'
            ],
            onChanged: (dynamic value) {
              setState(() {
                ddPastMedicalHistory = value ?? '';
              });
            },
          ),
          if (ddPastMedicalHistory.contains('Others')) ...[
            const SizedBox(height: 16),
            TitleWidget(title: "Others", isRequired: true),
            const SizedBox(height: 8),
            FormTextArea(
              enabled: true,
              name: 'others',
              labelName: '',
            ),
          ],
          const SizedBox(height: 16),
          TitleWidget(title: "Last Meal (date and time)", isRequired: true),
          const SizedBox(height: 8),
          FormDateTimePicker(
            name: 'lastMeal',
            enabled: true,
            lastDate: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
              DateTime.now().hour,
              DateTime.now().minute,
            ),
            isRequired: true,
            onChanged: (DateTime? value) {},
          ),
          const SizedBox(height: 16),
          TitleWidget(
              title: "Event leading to the incident", isRequired: false),
          const SizedBox(height: 8),
          FormTextArea(
            enabled: true,
            name: 'eventLeadingToIncident',
            labelName: '',
          ),
          const SizedBox(height: 16),
          TitleWidget(
              title: "Under the influence of alcohol/restricted drugs?",
              isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'underInfluenceOfAlcoholOrRestrictedDrugs',
            values: yesNoList,
            texts: yesNoList,
          ),
          const SizedBox(height: 16),
          TitleWidget(
              title: "Is the mechanism of injury self-inflicted?",
              isRequired: true),
          const SizedBox(height: 8),
          FormRadio(
            enabled: true,
            name: 'injuryDateTime',
            values: yesNoList,
            texts: yesNoList,
          ),
        ],
      ),
    );
  }

  //Start of Layout Widgets
  Future<void> _showMissingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomModal(
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Please fill the missing details.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200.0,
                child: ListView.builder(
                  itemCount: errorFields.length,
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                  itemBuilder: (context, index) {
                    return Text(
                      errorFields[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> submit() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SubmitModal(
          patientStatus: patientStatus,
          statusOptions: phase,
          onStatusChange: (newValue) {
            setState(() {
              patientStatus = newValue;
            });
          },
          onSubmit: () async {
            Navigator.of(context).pop();
            _formKey.currentState!.save();
            if (patientStatus != "") {
              var result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const PinCodeScreen(),
                  fullscreenDialog: true,
                ),
              );

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
          },
        );
      },
    );
  }

  //Start of ER Widgets

  //End of ER Widget

  //End of Layout Widgets

  Future<bool> _insertData(Map<String, dynamic> formValues) async {
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
          "permanentAddress": {
            "cityMun": nullChecker(citiesDesc),
            "province": nullChecker(provincesDesc),
            "region": nullChecker(regionDesc),
          },
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
          "permanentAddress": {
            "cityMun": nullChecker(permanentCitiesDesc),
            "province": nullChecker(permanentProvincesDesc),
            "region": nullChecker(permanentRegionDesc),
          },
        };
      }
    }

    final recordDesc = await generateRecordID();
    final encryptedRecordID = encryp(recordDesc);

    var createHistory = {
      "userID": userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    Map<String, dynamic> prehospital = {};

    Map<String, dynamic> er = {};

    Map<String, dynamic> newRecord = {};

    try {
      if (!ifPatientExist) {
        Map<String, dynamic> newPatient = {
          "patientID": encryptedPatientID,
          "general": general,
          "lastHospital": null,
          "lastStatus": null,
          "patientHistory": []
        };
        await addNewPatient(newPatient, bearerToken);
      }
      await addNewRecord(newRecord, bearerToken);
      return true;
    } catch (e) {
      showErrorModal(context, e.toString());
      return false;
    }
  }

  void showErrorModal(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return ErrorModal(
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bearerToken = userProvider.bearerToken;
    userID = userProvider.userID;
    _controller = TabController(length: 4, vsync: this);
    _loadLocationData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: 4,
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Text("Adding Pre-Hospital Data",
                        style: Theme.of(context).textTheme.titleLarge),
                    leading: IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(LucideIcons.chevronLeft,
                          color: AppColors.textPrimary),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return ResetModal(
                                onReset: () {
                                  // Close the modal
                                  Navigator.of(context).pop();

                                  // Form reset logic
                                  ifPatientExist = false;
                                  _formKey.currentState!.save();
                                  _formKey.currentState!.reset();

                                  // Update state
                                  setState(() {
                                    // Permanent Address
                                    permanentRegionId = "";
                                    permanentProvincesId = "";
                                    permanentCitiesId = "";
                                    permanentRegionDesc = "";
                                    permanentProvincesDesc = "";
                                    permanentCitiesDesc = "";
                                  });
                                },
                              );
                            },
                          );
                        },
                        icon: const Icon(LucideIcons.rotateCcw,
                            color: AppColors.textPrimary),
                      ),
                    ],
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
                          text: "I", //General
                        ),
                        Tab(
                          text: "II", //Details of the Injury
                        ),
                        Tab(
                          text: "III", //Primary Survey
                        ),
                        Tab(
                          text: "IV", //Ample
                        ),
                      ],
                    ),
                  ),
                  body: FormBuilder(
                    key: _formKey,
                    child: TabBarView(
                      controller: _controller,
                      children: [
                        // I. General Data
                        Scaffold(
                          body: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TitleBanner(title: "I. General Data"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 8.0),
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

                        // II. Details of the Injury
                        Scaffold(
                          body: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TitleBanner(
                                      title: "II. Details of the Injury"),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 8.0),
                                    child: Column(
                                      children: [
                                        injuryDetails(),
                                        mechanismOfInjury(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // III. Primary Survey
                        Scaffold(
                          body: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  TitleBanner(title: "(X) Exsanguination"),
                                  exsanguination(),
                                  const SizedBox(height: 8),
                                  TitleBanner(title: "(A) Airway"),
                                  airway(),
                                  const SizedBox(height: 8),
                                  TitleBanner(title: "(B) Breathing"),
                                  breathing(),
                                  const SizedBox(height: 8),
                                  TitleBanner(title: "(C) Circulation"),
                                  circulation(),
                                  const SizedBox(height: 8),
                                  TitleBanner(title: "(D) Disability"),
                                  disability(),
                                  const SizedBox(height: 8),
                                  TitleBanner(title: "(E) Exposure"),
                                  exposure(),
                                  const SizedBox(height: 8),
                                  TitleBanner(title: "(F) Other Factors"),
                                  otherFactors(),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // IV. Ample
                        Scaffold(
                          body: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                            child: SingleChildScrollView(
                                child: Column(
                              children: [
                                TitleBanner(title: "IV. Ample"),
                                ample()
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
                                      permanentCitiesId, 'permanent address');
                                }

                                if (regionId == "" &&
                                    provincesId == "" &&
                                    citiesId == "") {
                                  errorFields.add('place of injury');
                                }

                                // Vehicular accident-specific checks
                                if (value['vehicularAccidentBool'] == "yes") {
                                  //Add Vehicular Accident
                                }

                                // Show confirmation or missing fields dialog
                                if (errorFields.isEmpty) {
                                  submit();
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
