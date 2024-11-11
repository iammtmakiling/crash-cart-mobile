import 'package:dashboard/main/main_navigation.dart';
import 'package:dashboard/screens/pincode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// import '../../pin.dart';
// import '../../globals.dart' as globals;

import 'dart:convert';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';
import '../../widgets/formWidgets/formWidgets.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

var uuid = const Uuid();
DateTime current = DateTime.now();

// ignore: camel_case_types
class editGeneral extends StatelessWidget {
  final Map<String, dynamic> generalData;

  const editGeneral({super.key, required this.generalData});

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
      // title: 'Add Patient',
      theme: ThemeData(
          primarySwatch: Colors.cyan,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: Colors.black,
            fontSizeFactor: 1.0,
            decoration: TextDecoration.none,
          )),
      home: EditGeneral(generalData: generalData),
    );
  }
}

// ignore: camel_case_types
class EditGeneral extends StatefulWidget {
  final Map<String, dynamic> generalData;
  const EditGeneral({super.key, required this.generalData});

  @override
  // ignore: library_private_types_in_public_api
  EditGeneralState createState() => EditGeneralState();
}

// ignore: camel_case_types
class EditGeneralState extends State<EditGeneral>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  //General Data
  late Map<String, dynamic> generalData;
  int age = 0;

  String presentRegionId = "";
  String presentProvincesId = "";
  String presentCitiesId = "";
  String permanentRegionId = "";
  String permanentProvincesId = "";
  String permanentCitiesId = "";
  String presentRegionDesc = "";
  String presentProvincesDesc = "";
  String presentCitiesDesc = "";
  String permanentRegionDesc = "";
  String permanentProvincesDesc = "";
  String permanentCitiesDesc = "";

  List<dynamic> regions = [];
  List<dynamic> provincesMaster = [];

  List<dynamic> provinces = [];
  List<dynamic> citiesMaster = [];

  List<dynamic> cities = [];
  bool? isSameAddress = false;

  //Screens
  bool isSending = false;
  bool isSentSuccessfully = false;
  bool isLoading = true;

  //start of arrays to transfer to centralized data file
  List naturesOfInjury = [
    'Blunt Trauma',
    'Abrasion',
    'Avulsion',
    'Concussion',
    'Burn',
    'Fracture (Closed Type)',
    'Fracture (Open Type)',
    'Amputation',
    'Others'
  ];
  List externalCausesInjury = [
    'Bites',
    'Strangulation',
    'Fall',
    'Drowning',
    'Firecrackers',
    'Mauling',
    'Assault'
  ];
  List safetyIssues = [
    'Sleepy',
    'Alcohol',
    'Drugs',
    'Smoking',
    'Seatbelt',
    'Airbag',
    'Helmet',
    'Life Jacket'
  ];
  List modeOfTranspo = [
    'Private Vehicle',
    'Police Vehicle',
    'Ambulance',
    'Public Transportation',
    'Others'
  ];
  List cavitiesForSurgery = [
    'Head',
    'Neck',
    'Chest',
    'Abdomen',
    'Extremity',
    'Superficial'
  ];
  List servicesOnboard = [
    'General Surgery',
    'Ortho',
    'OB',
    'Neurosurgery',
    'Plastics',
    'TCVS',
    'Optha',
    'ENT'
  ];
  List disposition = [
    'Admit (Surgery)',
    'Admit (In-Hospital)',
    'Treated and for Discharge',
    'No intervention and for Discharge',
    'HAMA/Refused Admission',
    'Absconded',
    'Died',
    'Transferred'
  ];
  //end of arrays to transfer to centralized data file

  final newKey =
      encrypt.Key.fromUtf8('9ka3Ht7RbNcG5FJe1L0pAxvzIBy6USwD'); //32 chars
  final newIv = IV.fromUtf8('Kt7RbcG5FJe1L0pA'); //16 chars

//Encryption
  String encryp(String text) {
    final encrypter = Encrypter(AES(newKey, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: newIv);

    return encrypted.base64;
  }

  List<dynamic> encryptList(List<dynamic> inputList) {
    List<dynamic> encryptedList = [];

    for (String text in inputList) {
      encryptedList.add(encryp(text));
    }

    return encryptedList;
  }

  Future<void> readJsonRegions() async {
    final String response =
        await rootBundle.loadString('assets/json/refregion.json');
    final data = await json.decode(response);
    setState(() {
      regions = data["RECORDS"];
      // for (var region in regions) {
      //   if (region["regDesc"].toString() == POIRegionId) {
      //     POIRegionId = region["regCode"].toString();
      //     break;
      //   }
      // }
    });
  }

  Future<void> readJsonProvinces() async {
    final String response =
        await rootBundle.loadString('assets/json/refprovince.json');
    final data = await json.decode(response);
    setState(() {
      provincesMaster = data["RECORDS"];
      // for (var province in provincesMaster) {
      //   if (province["provDesc"].toString() == POIProvincesId) {
      //     POIProvincesId = province["provCode"].toString();
      //     break;
      //   }
      // }
    });
  }

  Future<void> readJsonCities() async {
    final String response =
        await rootBundle.loadString('assets/json/refcitymun.json');
    final data = await json.decode(response);
    setState(() {
      citiesMaster = data["RECORDS"];
    });
  }

  // helper functions
  String currentDate() {
    var date = DateTime.now();
    var formattedDate = DateFormat('').format(date);

    return formattedDate;
  }

  String formatDate(DateTime date) {
    String init = " ";

    return init;
  }

  Future<void> _insertData(
    Map<String, dynamic> formValues,
  ) async {}

  //Helper Function
  int calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

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
                          initialValue: generalData['lastName'],
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
                          initialValue: generalData['firstName'],
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
                            initialValue: generalData['middleName'],
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
                            initialValue: generalData['suffix'],
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
              initialValue: generalData['sex'],
              name: 'gender',
              values: const ['Male', 'Female', 'Nonbinary'],
              texts: const ['Male', 'Female', 'Nonbinary'],
            ),
          ],
        ));
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
                        FractionallySizedBox(
                          // widthFactor: 0.95,
                          child: FormBuilderDateTimePicker(
                            initialValue:
                                DateTime.parse(generalData['birthday']),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FractionallySizedBox(
                          // widthFactor: 0.95,
                          child: FormBuilderTextField(
                            enabled: false,
                            initialValue: age.toString(),
                            name: 'age',
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
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
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            // FormAddress(
            //   regionId: presentRegionId,
            //   provincesId: presentProvincesId,
            //   citiesId: presentCitiesId,
            //   onRegionChanged: (String? newValue) {
            //     setState(() {
            //       presentRegionId = newValue!;
            //       print("updated: $presentRegionId");
            //     });
            //   },
            //   onProvincesChanged: (String? newValue) {
            //     setState(() {
            //       presentProvincesId = newValue!;
            //       print("updated: $presentProvincesId");
            //     });
            //   },
            //   onCitiesChanged: (String? newValue) {
            //     setState(() {
            //       presentCitiesId = newValue!;
            //       print("updated: $presentCitiesId");
            //     });
            //   },
            // ),
            const SizedBox(height: 5),
            const Text(
              "Permanent Address",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
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
                      } else {
                        permanentCitiesId = "";
                        permanentProvincesId = "";
                        permanentRegionId = "";
                      }
                    });
                  },
                ),
                const Text('Same as Present Address'),
              ],
            ),
            const SizedBox(height: 5),
            // if (isSameAddress != null && isSameAddress == false)
            //   FormAddress(
            //     regionId: permanentRegionId,
            //     provincesId: permanentProvincesId,
            //     citiesId: permanentCitiesId,
            //     onRegionChanged: (String? newValue) {
            //       setState(() {
            //         permanentRegionId = newValue!;
            //       });
            //     },
            //     onProvincesChanged: (String? newValue) {
            //       setState(() {
            //         permanentProvincesId = newValue!;
            //       });
            //     },
            //     onCitiesChanged: (String? newValue) {
            //       setState(() {
            //         permanentCitiesId = newValue!;
            //       });
            //     },
            //   ),
          ],
        ));
  }

  Padding philhealthID() {
    // need validators for ID format
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "PhilHealth ID",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
              child: FractionallySizedBox(
                widthFactor: 0.95,
                child: FormTextField(
                    initialValue: generalData['philHealthID'],
                    name: "philhealthID",
                    labelName: ""),
              ),
            ),
          ],
        ));
  }
  //End of Widgets

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: const Text(
            'Are you sure you want to change the Patient\'s Generla Data?',
            textAlign: TextAlign.center,
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
                      "No",
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
                      if (_formKey.currentState!.validate()) {
                        var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const PinCodeScreen(),
                              fullscreenDialog: true,
                            ));

                        // print(result);
                        if (result == true) {
                          setState(() {
                            isSending = true;
                          });

                          // Simulate sending data with a delay of 2 seconds
                          Future.delayed(const Duration(seconds: 2), () {
                            // Set isSending back to false when done
                            setState(() {
                              isSending = false;
                              isSentSuccessfully = true;
                            });
                          });

                          await _insertData(_formKey.currentState!.value);
                        }
                      }
                    },
                    child: const Text(
                      "Yes",
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

  bool addressesAreSame(Map<String, dynamic> generalData) {
    Map<String, dynamic> permanentAddress =
        generalData['permanentAddress'] ?? {};
    Map<String, dynamic> presentAddress = generalData['presentAddress'] ?? {};

    // Check if all address fields are the same
    bool regionSame = permanentAddress['region'] == presentAddress['region'];
    bool provinceSame =
        permanentAddress['province'] == presentAddress['province'];
    bool cityMunSame = permanentAddress['cityMun'] == presentAddress['cityMun'];

    // Return true if all fields are the same, otherwise false
    return regionSame && provinceSame && cityMunSame;
  }

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future<void> initializeData() async {
    generalData = widget.generalData;
    // print(generalData);

    isSameAddress = addressesAreSame(generalData);

    DateTime birthDate = DateTime.parse(generalData['birthday']);
    // print(birthDate);
    // Calculate the age
    age = calculateAge(birthDate);
    // _formKey.currentState!.fields['age']!.didChange(age.toString());

    List<Future> asyncTasks = [
      readJsonRegions(),
      readJsonProvinces(),
      readJsonCities(),
    ];

    await Future.wait(asyncTasks);

    // Once all async tasks are completed, set isLoading to false
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (!isSending && !isSentSuccessfully && !isLoading)
            const MiniAppBar(),
          isLoading
              ? const LoadingWidget()
              : isSending
                  ? const SendingWidget()
                  : isSentSuccessfully
                      ? SuccessfulWidget(
                          message: "Successful!",
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const MainNavigation(),
                              ),
                            );
                          },
                        )
                      : Expanded(
                          child: DefaultTabController(
                            initialIndex: 0,
                            length: 3,
                            child: Scaffold(
                              persistentFooterButtons: [
                                FormBottomButton(
                                  formKey: _formKey,
                                  onSubmitPressed: () async {
                                    _formKey.currentState!.save();
                                    if (_formKey.currentState!.validate()) {
                                      _showConfirmationDialog();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text("Fill all required fields"),
                                          duration: Duration(seconds: 5),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                              appBar: AppBar(
                                centerTitle: true,
                                title: const Text(
                                  "Editing General Data",
                                  style: TextStyle(
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              body: FormBuilder(
                                key: _formKey,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4.0, horizontal: 8.0),
                                          child: Column(
                                            children: [
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
                        ),
        ],
      ),
    );
  }
}
