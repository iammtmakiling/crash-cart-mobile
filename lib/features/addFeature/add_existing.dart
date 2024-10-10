import 'package:dashboard/api_requests/checkPatient.dart';
import 'package:dashboard/features/addFeature/add_prehospital.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/helperFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../widgets/formWidgets/formWidgets.dart';

class addExisting extends StatelessWidget {
  final BuildContext context;

  const addExisting({super.key, required this.context});

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
      home: AddExisting(context: context),
    );
  }
}

class AddExisting extends StatefulWidget {
  final BuildContext context;

  const AddExisting({super.key, required this.context});

  @override
  AddExistingState createState() => AddExistingState();
}

class AddExistingState extends State<AddExisting> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  bool isSending = false;
  bool isSentSuccessfully = false;
  String isExisting = "";
  bool ifExist = false;
  Map<String, dynamic> currentPatient = {};
  Map<String, dynamic> existingPatient = {};

  //Encryption

  calculateAge(DateTime birthDate) {
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

  Future<bool> _insertData(
    Map<String, dynamic> formValues,
  ) async {
    Map<String, dynamic> encryptedPatient = {
      "firstName": encryp(formValues['fname']),
      "lastName": encryp(formValues['lname']),
      "middleName":
          formValues['mname'] != null ? encryp(formValues['mname']) : null,
      "suffix":
          formValues['suffix'] != null ? encryp(formValues['suffix']) : null,
      "birthday": encryp(formValues["birthday"].toString().split(" ")[0]),
    };

    currentPatient = {
      "firstName": formValues['fname'],
      "lastName": formValues['lname'],
      "middleName": formValues['mname'],
      "suffix": formValues['suffix'],
      "birthday": formValues["birthday"].toString().split(" ")[0],
    };

    Map<String, dynamic> patientFound =
        await checkPatientExist(encryptedPatient, bearerToken);
    if (patientFound['ifExist'] == true) {
      existingPatient = patientFound['patient'];
    }
    setState(() {
      isSending = false;
      isSentSuccessfully = true;
      isExisting =
          patientFound['ifExist'] ? "Patient Found" : "Patient not Found";
    });
    return patientFound['ifExist'];
  }

  // General Indo Widgets
  Column patientName() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Patient Full Name",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormTextField(
              name: "fname",
              labelName: "Firstname",
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 8),
            FormTextField(
              name: "lname",
              labelName: "Last Name",
              validator: FormBuilderValidators.required(),
            ),
            const SizedBox(height: 8),
            const FormTextField(name: "mname", labelName: "Middle Name"),
            const SizedBox(height: 8),
            const FormTextField(name: "suffix", labelName: "Suffix"),
          ],
        ),
      ],
    );
  }

  Column bdayAge() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Birthday & Age",
          style: TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormBuilderDateTimePicker(
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
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            FormBuilderTextField(
              enabled: false,
              name: 'age',
              decoration: const InputDecoration(
                labelText: 'Age',
                // hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Column patientType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Type of Patient",
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        FormDropdown(
          name: 'patientType',
          items: const ['ER', 'OPD', 'In-Patient', 'BHS', 'RHU'],
          validator: FormBuilderValidators.required(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        decoration: const BoxDecoration(
          color: Colors.cyan,
        ),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Checking if patient exists...',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ),
        ),
      ),
      content: FormBuilder(
        key: _formKey,
        // autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: (!isSending && !isSentSuccessfully)
                ? Column(
                    children: [
                      patientName(),
                      const SizedBox(height: 16),
                      bdayAge(),
                    ],
                  )
                : !isSentSuccessfully
                    ? const Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.cyan),
                            strokeWidth: 5,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Center(
                            child: Text(
                              isExisting,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          if (ifExist) const SizedBox(height: 8),
                          if (ifExist) patientType()
                        ],
                      ),
          ),
        ),
      ),
      actions: <Widget>[
        !isSentSuccessfully
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isSending)
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.cyan),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                bottomLeft: Radius.circular(20.0),
                              ),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(widget.context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                    ),
                  if (!isSending)
                    Expanded(
                      child: OutlinedButton(
                        style: ButtonStyle(
                          side: WidgetStateProperty.all(
                            const BorderSide(color: Colors.cyan),
                          ),
                          shape:
                              WidgetStateProperty.all<RoundedRectangleBorder>(
                            const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.0),
                                bottomRight: Radius.circular(20.0),
                              ),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                              Colors.cyan), // Set background color
                        ),
                        onPressed: () async {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            setState(
                              () {
                                isSending = true;
                              },
                            );

                            ifExist =
                                await _insertData(_formKey.currentState!.value);
                          }
                        },
                        child: const Text(
                          "Confirm",
                          style:
                              TextStyle(color: Colors.white), // Set text color
                        ),
                      ),
                    ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: Colors.cyan,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      onPressed: () async {
                        _formKey.currentState!.save();
                        if (_formKey.currentState!.validate()) {
                          if (ifExist) {
                            Get.to(
                              addPreHospital(
                                patientType:
                                    _formKey.currentState!.value['patientType'],
                                patient: existingPatient,
                                onBack: () {
                                  Navigator.pop(widget.context);
                                  Navigator.pop(widget.context);
                                },
                              ),
                            );
                          } else {
                            // Get.to(
                            //   addGeneral(
                            //     onBack: () {
                            //       Navigator.pop(widget.context);
                            //       Navigator.pop(widget.context);
                            //     },
                            //     patient: currentPatient,
                            //   ),
                            // );
                          }
                        }
                      },
                      child: const Text(
                        "Proceed",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
      ],
    );
  }
}
