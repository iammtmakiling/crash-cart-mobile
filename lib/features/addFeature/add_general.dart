import 'package:dashboard/core/utils/helper_utils.dart';

import '../../core/api_requests/_api.dart';
import 'package:dashboard/features/addFeature/add_prehospital.dart';

import 'package:dashboard/globals.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:dashboard/screens/pincode.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../widgets/formWidgets/formWidgets.dart';
import '../../globals.dart' as globals;
import '../../widgets/widgets.dart';
import '../../initializedList.dart';

DateTime current = DateTime.now();

// ignore: camel_case_types
class addGeneral extends StatelessWidget {
  final VoidCallback onBack;
  // const addInfo({super.key, required this.onBack});
  final Map<String, dynamic> patient;

  const addGeneral({super.key, required this.patient, required this.onBack});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('az');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('de'),
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('it'),
      ],
      localizationsDelegates: const [
        FormBuilderLocalizations.delegate,
      ],
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: Colors.black,
            fontSizeFactor: 1.0,
            decoration: TextDecoration.none,
          )),
      // home: addPatient(onBack: onBack),
      home: AddGeneral(patient: patient, onBack: onBack),
    );
  }
}

// ignore: camel_case_types
class AddGeneral extends StatefulWidget {
  final Map<String, dynamic> patient;
  final VoidCallback onBack;
  const AddGeneral({super.key, required this.patient, required this.onBack});

  @override
  // ignore: library_private_types_in_public_api
  AddGeneralState createState() => AddGeneralState();
}

// ignore: camel_case_types
class AddGeneralState extends State<AddGeneral>
    with SingleTickerProviderStateMixin {
  String address = "";
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  late Map<String, dynamic> patient;

  //Screens
  bool isSending = false;
  bool isSentSuccessfully = false;
  String screenMessage = "Success!";

  //General Data
  var patientStatus = "";
  String patientTypeDesc = "";
  late Map<String, dynamic> currentPatient;
  int age = 0;

  //Present Address
  String presentRegionId = "";
  String presentProvincesId = "";
  String presentCitiesId = "";
  String presentRegionDesc = "";
  String presentProvincesDesc = "";
  String presentCitiesDesc = "";

  //Permanent Address
  String permanentRegionId = "";
  String permanentProvincesId = "";
  String permanentCitiesId = "";
  String permanentRegionDesc = "";
  String permanentProvincesDesc = "";
  String permanentCitiesDesc = "";

  bool? isSameAddress = false;

  List<String> errorFields = [];

  // General Indo Widgets
  Padding patientName() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Patient Full Name",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        FormTextField(
                          initialValue: patient['lastName'],
                          name: 'lastName',
                          labelName: 'Last Name',
                          validator: FormBuilderValidators.required(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      children: [
                        FormTextField(
                          initialValue: patient['firstName'],
                          name: 'firstName',
                          labelName: 'First Name',
                          validator: FormBuilderValidators.required(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        FormTextField(
                            initialValue: patient['middleName'],
                            name: 'middleName',
                            labelName: 'Middle Name'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      children: [
                        FormTextField(
                            initialValue: patient['suffix'],
                            name: 'suffix',
                            labelName: 'Suffix'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Padding patientType() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Type of Patient",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          FormRadio(
            enabled: true,
            name: 'patientType',
            values: const ['ER', 'OPD', 'In-Patient', 'BHS', 'RHU'],
            texts: const ['ER', 'OPD', 'In-Patient', 'BHS', 'RHU'],
            validator: FormBuilderValidators.required(),
          ),
        ],
      ),
    );
  }

  Padding genderPick() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Sex",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          FormRadio(
            enabled: true,
            validator: FormBuilderValidators.required(),
            name: 'gender',
            values: gender,
            texts: gender,
          ),
        ],
      ),
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
            const Text(
              "Birthday & Age",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FormBuilderDateTimePicker(
                        initialValue: DateTime.parse(patient['birthday']),
                        validator: FormBuilderValidators.required(),
                        inputType: InputType.date,
                        name: 'birthday',
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        format: DateFormat('yyyy-MM-dd'),
                        onChanged: (DateTime? value) {
                          // ignore: prefer_typing_uninitialized_variables
                          var patientAge;
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
                        decoration: const InputDecoration(
                          labelText: 'Birthday',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FormBuilderTextField(
                        enabled: false,
                        name: 'age',
                        initialValue: age.toString(),
                        decoration: const InputDecoration(
                          labelText: 'Age',
                          // hintStyle: TextStyle(color: Colors.grey),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
          const Text(
            "Present Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          FormAddress(
            enabled: true,
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
          const Text(
            "Permanent Address",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Checkbox(
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
              regionId: permanentRegionId,
              enabled: true,
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
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PhilHealth ID",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            child: FractionallySizedBox(
              widthFactor: 0.95,
              child: FormBuilderTextField(
                name: "philhealthID",
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: 'PhilHealth ID',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //End of General Info Widgets

  //Start of Layout Widgets
  Future<void> _showMissingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text(
              "Please fill the missing details.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              errorFields.join(', '),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ]),
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

  //End of Layout Widgets

  Future<String> _insertData(
    Map<String, dynamic> formValues,
  ) async {
    debugPrint("inserting data---------");

    patientTypeDesc = formValues['patientType'];

    final patientDesc =
        await generatePatientID(presentCitiesId, presentCitiesDesc);
    final encryptedPatientID = encryp(patientDesc);
    // print("Patient ID: $patientDesc");
    // print("Encrypted Patient ID: $encryptedPatientID");

    Map<String, dynamic> general = {
      "firstName": formValues["firstName"] != null
          ? encryp(formValues["firstName"])
          : null,
      "middleName": formValues["middleName"] != null
          ? encryp(formValues["middleName"])
          : null,
      "lastName": formValues["lastName"] != null
          ? encryp(formValues["lastName"])
          : null,
      "suffix":
          formValues["suffix"] != null ? encryp(formValues["suffix"]) : null,
      "birthday": formValues["birthday"].toString().split(" ")[0] != ""
          ? encryp(formValues["birthday"].toString().split(" ")[0])
          : null,
      "sex": formValues["gender"] != null ? encryp(formValues["gender"]) : null,
      "presentAddress": {
        "cityMun": presentCitiesId != "" ? encryp(presentCitiesId) : null,
        "province":
            presentProvincesId != "" ? encryp(presentProvincesId) : null,
        "region": presentRegionId != "" ? encryp(presentRegionId) : null,
      },
      "permanentAddress": {
        "cityMun":
            permanentCitiesDesc != "" ? encryp(permanentCitiesDesc) : null,
        "province": permanentProvincesDesc != ""
            ? encryp(permanentProvincesDesc)
            : null,
        "region":
            permanentRegionDesc != "" ? encryp(permanentRegionDesc) : null,
      },
      "philHealthID": formValues["philhealthID"] != null
          ? encryp(formValues["philhealthID"])
          : null,
    };

    Map<String, dynamic> general2 = {
      "firstName": formValues["firstName"],
      "middleName": formValues["middleName"],
      "lastName": formValues["lastName"],
      "suffix": formValues["suffix"],
      "birthday": formValues["birthday"].toString().split(" ")[0],
      "sex": formValues["gender"],
      "presentAddress": {
        "cityMun": presentCitiesId,
        "province": presentProvincesId,
        "region": presentRegionId,
      },
      "permanentAddress": {
        "cityMun": permanentCitiesDesc,
        "province": permanentProvincesDesc,
        "region": permanentRegionDesc,
      },
      "philHealthID": formValues["philhealthID"],
    };

    Map<String, dynamic> newPatient = {
      "patientID": encryptedPatientID,
      "general": general,
      "lastHospital": null,
      "lastStatus": encryp("Pre-Hospital"),
      "patientHistory": []
    };

    currentPatient = {
      "patientID": patientID,
      "general": general2,
      "lastHospital": null,
      "lastStatus": "Pre-Hospital",
      "patientHistory": []
    };

    // debugPrint("NEW PATIENT $currentPatient");

    // firebase functions
    // print("ADDING PATIENT");
    var addingPatient = await addNewPatient(newPatient, globals.bearerToken);
    return (addingPatient['message']);
  }

  @override
  void initState() {
    super.initState();
    patient = widget.patient;
    DateTime birthDate = DateTime.parse(patient['birthday']);
    age = calculateAge(birthDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (!isSending && !isSentSuccessfully)
            MiniAppBarBack(
              onBack: widget.onBack,
            ),
          isSending
              ? const SendingWidget()
              : isSentSuccessfully
                  ? SuccessfulWidget(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => AddPreHospital(
                                onBack: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainNavigation()),
                                  );
                                },
                                patient: currentPatient,
                                patientType: patientTypeDesc),
                          ),
                        );
                      },
                      message: screenMessage,
                    )
                  : Expanded(
                      child: Scaffold(
                        appBar: AppBar(
                          centerTitle: true,
                          title: const Text(
                            "Adding Patient",
                            style: TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        persistentFooterButtons: [
                          FormBottomButton(
                            formKey: _formKey,
                            onSubmitPressed: () async {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                var value = _formKey.currentState!.value;

                                if (value['firstName'] == null) {
                                  errorFields.add('firstName');
                                }

                                if (value['lastName'] == null) {
                                  errorFields.add('lastName');
                                }

                                if (presentCitiesId == "") {
                                  errorFields.add('present address');
                                }

                                if (permanentCitiesId == "") {
                                  errorFields.add('permanent address');
                                }

                                if (errorFields.isEmpty) {
                                  var result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          const PinCodeScreen(),
                                      fullscreenDialog: true,
                                    ),
                                  );

                                  if (result == true) {
                                    setState(
                                      () {
                                        isSending = true;
                                      },
                                    );
                                    String response = await _insertData(
                                        _formKey.currentState!.value);

                                    if (response !=
                                        "Patient is added successfully.") {
                                      screenMessage = response;
                                    }

                                    setState(() {
                                      isSending = false;
                                      isSentSuccessfully = true;
                                    });
                                  }
                                } else {
                                  _showMissingDialog();
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Fill all required fields"),
                                    duration: Duration(seconds: 5),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                        body: FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Padding(
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
                                        patientName(),
                                        bdayAge(),
                                        genderPick(),
                                        presentPermanentAddress(),
                                        philhealthID()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
