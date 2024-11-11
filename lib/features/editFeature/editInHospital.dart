import 'package:dashboard/core/api_requests/updateRecord.dart';
import 'package:dashboard/features/viewFeature/viewSummary.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/initializedList.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:dashboard/screens/pincode.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

// import '../../pin.dart';
import '../../core/models/_models.dart';
import '../../globals.dart' as globals;

import 'dart:convert';
import 'package:flutter/services.dart';

import '../../widgets/widgets.dart';
import '../../widgets/formWidgets/formWidgets.dart';

var uuid = const Uuid();
DateTime current = DateTime.now();

// ignore: camel_case_types
class editInHospital extends StatelessWidget {
  final Map<String, dynamic> inHospitalData;
  final Map<String, dynamic> record;
  final VoidCallback onBack;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  const editInHospital(
      {super.key,
      required this.inHospitalData,
      required this.record,
      required this.patientData,
      required this.fullRecord,
      required this.onBack});

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
      home: EditInHospital(
          inHospitalData: inHospitalData,
          record: record,
          onBack: onBack,
          patientData: patientData,
          fullRecord: fullRecord),
    );
  }
}

// ignore: camel_case_types
class EditInHospital extends StatefulWidget {
  final Map<String, dynamic> inHospitalData;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final Map<String, dynamic> record;
  final VoidCallback onBack;
  const EditInHospital(
      {super.key,
      required this.inHospitalData,
      required this.record,
      required this.patientData,
      required this.fullRecord,
      required this.onBack});

  @override
  // ignore: library_private_types_in_public_api
  EditInHospitalState createState() => EditInHospitalState();
}

// ignore: camel_case_types
class EditInHospitalState extends State<EditInHospital>
    with SingleTickerProviderStateMixin {
  // Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Full Record
  late Map<String, dynamic> record;

  // ICU Visibility
  bool visibleVTE = false;
  String visibleVTEString = "";
  bool visibleLSW = false;
  String visibleLSWString = "";
  bool visibleICU = false;
  String visibleICUString = "";

  // General Data
  var patientStatus = "In-Hospital";
  late Map<String, dynamic> inHospitaldata;
  bool isSending = false;
  bool isSentSuccessfully = false;

  // Lists
  // In-Hospital Data
  List<Widget> inreferralsList = [];
  List<dynamic> comorbidities = [];
  List<dynamic> complications = [];
  List<Map<String, dynamic>> consultations = [];
  DateTime? icuArrivalDate;
  DateTime? icuExitDate;
  int icuLengthOfStay = 0;

  // Discharge Data
  // List<dynamic> ICDCodes = [];
  // List<String> ICDCodesArray = [];

  // Disposition List
  List<String> disposition = [
    "In-Hospital",
    'Pending Surgery',
    'Pending Discharge',
    'Deceased',
  ];

  late TabController _tabController;

  void addToHistory(List editHistory, Map<String, dynamic> editedItem) {
    if (editHistory.length >= 3) {
      editHistory.removeAt(0); // Remove the oldest history
    }
    editHistory.add(editedItem);
  }

  //end of arrays to transfer to centralized data file

  Future<void> _insertData(Map<String, dynamic> formValues) async {
    Map<String, dynamic> newEditHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    List editHistory = record['editHistory'] ?? [];
    addToHistory(editHistory, newEditHistory);

    var inreferralsListForEdit = [];

    for (var index = 0; index < inreferralsList.length; index++) {
      Map<String, dynamic> inreferralsElement = {
        "service": nullChecker(formValues["consultationService${index + 1}"]),
        "physician": formValues["consultationPhysician${index + 1}"],
        "consultationTimestamp":
            formValues["consultationDate${index + 1}"]?.toString(),
      };

      inreferralsListForEdit.add(inreferralsElement);
    }

    Map<String, dynamic> inHospital = {
      "createHistory": inHospitaldata['createHistory'],
      "editHistory": editHistory,
      "capriniScore": nullChecker(formValues["capriniScore"]),
      "vteProphylaxis": {
        "inclusion": nullChecker(formValues["vteInclusion"]),
        "type": nullChecker(formValues["vteType"]),
      },
      "lifeSupportWithdrawal": {
        "lswBoolean": nullChecker(formValues['lswBoolean']),
        "lswTimestamp": formValues["lswTimestamp"]?.toString(),
      },
      "icu": {
        "arrival": nullChecker(formValues["icuArrival"]?.toString()),
        "exit": nullChecker(formValues["icuExit"]?.toString()),
        "lengthOfStay": nullChecker(formValues["icuLengthStay"]),
      },
      "comorbidities": encryptList(comorbidities),
      "consultations": inreferralsListForEdit,
      "complications": encryptList(complications),
      "dispositionInHospital": nullChecker(patientStatus),
    };

    record['inHospital'] = inHospital;
    record['patientStatus'] = encryp(patientStatus);
    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));

    await updateRecord(encodedpatientID, record, bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

  Widget inreferralsTemplateForEdit(int index) {
    return Card(
      // // elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Consultation ${index + 1}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FormTextField(
                name: "consultationService${index + 1}",
                labelName: "",
                initialValue:
                    inHospitaldata["consultations"][index]["service"] ?? "",
              ),
              const SizedBox(height: 8),
              const Text(
                "Physician",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // FormBuilderSearchableDropdown(
              //   decoration: const InputDecoration(
              //     contentPadding:
              //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //     ),
              //   ),
              //   items: consultationServices,
              // ),
              FormTextField(
                initialValue:
                    inHospitaldata['consultations'][index]["physician"] ?? "",
                name: "consultationPhysician${index + 1}",
                labelName: "",
              ),
              const SizedBox(height: 8),
              const Text(
                "Consultation Date and Time",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              FormBuilderDateTimePicker(
                initialValue: inHospitaldata['consultations'][index]
                            ["consultationTimestamp"] !=
                        null
                    ? DateTime.tryParse(inHospitaldata['consultations'][index]
                        ["consultationTimestamp"])
                    : DateTime.now(),
                lastDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    DateTime.now().hour,
                    DateTime.now().minute),
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                name: "consultationDate${index + 1}",
                firstDate: DateTime(2000),
                decoration: const InputDecoration(
                  // labelText: 'Consultation Date',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void renderInHospitalWidgetsForEdit() {
    if (inHospitaldata['consultations'] != []) {
      int lengthList = inHospitaldata['consultations'].length;
      for (var index = 0; index < lengthList; index++) {
        setState(() {
          inreferralsList.add(inreferralsTemplateForEdit(index));
        });
      }
    }
  }

  Padding condVTE() {
    // need validators for ID format
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "VTE Type",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormTextField(
              initialValue: inHospitaldata['vteProphylaxis']['type'],
              name: "vteType",
              labelName: ""),
          // FormBuilderSearchableDropdown(
          //   name: "vteType",
          //   decoration: const InputDecoration(
          //     contentPadding:
          //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //     ),
          //   ),
          //   items: vteTypes,
          // ),
          // const SizedBox(height: 8),
          // const Text(
          //   "VTE Date and Time",
          //   style: TextStyle(
          //       color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          // ),
          // FormBuilderDateTimePicker(
          //   inputType: InputType.date,
          //   format: DateFormat('yyyy-MM-dd'),
          //   name: "dateTimeVte",
          //   firstDate: DateTime(2000),
          //   lastDate: DateTime(DateTime.now().year, DateTime.now().month,
          //       DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
          //   decoration: const InputDecoration(
          //     contentPadding:
          //         EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //     ),
          //   ),
          //   onChanged: (DateTime? value) {
          //     setState(() {
          //       icuArrivalDate = value!;
          //     });
          //   },
          // ),
        ],
      ),
    );
  }

  Padding condLSW() {
    // need validators for ID format
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Date and Time",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          FormBuilderDateTimePicker(
            name: 'lswTimestamp',
            initialValue:
                inHospitaldata['lifeSupportWithdrawal']["lswTimestamp"] != null
                    ? DateTime.parse(
                        inHospitaldata['lifeSupportWithdrawal']['lswTimestamp'])
                    : DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            format: DateFormat('yyyy-MM-dd HH:mm:ss'),
            onChanged: (DateTime? value) {},
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
              // labelText: "Date and Time of Life Support Withdrawal",
              hintStyle: TextStyle(color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding condICU() {
    // need validators for ID format
    return Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ICU Arrival",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              FormBuilderDateTimePicker(
                initialValue: inHospitaldata['icu']['arrival'] != null
                    ? DateTime.parse(inHospitaldata['icu']['arrival'])
                    : DateTime.now(),
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                name: "icuArrival",
                firstDate: DateTime(2000),
                lastDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    DateTime.now().hour,
                    DateTime.now().minute),
                decoration: const InputDecoration(
                  // labelText: 'Date',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                onChanged: (DateTime? value) {
                  setState(
                    () {
                      if (icuExitDate != null) {
                        Duration lengthOfStay = icuExitDate!.difference(value!);
                        icuLengthOfStay = lengthOfStay.inDays;
                        _formKey.currentState!.fields['icuLengthStay']!
                            .didChange("${icuLengthOfStay.toString()} day/s");
                      }

                      icuArrivalDate = value;
                    },
                  );
                },
                // onChanged: (DateTime? value) {
                //   setState(() {

                //   });
                // },
              ),
              const SizedBox(height: 16),
              const Text(
                "ICU Exit",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              FormBuilderDateTimePicker(
                initialValue: inHospitaldata['icu']['exit'] != null
                    ? DateTime.parse(inHospitaldata['icu']['exit'])
                    : DateTime.now(),
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                name: "icuExit",
                firstDate: DateTime(2000),
                lastDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    DateTime.now().hour,
                    DateTime.now().minute),
                decoration: const InputDecoration(
                  // labelText: 'Date',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                onChanged: (DateTime? value) {
                  setState(() {
                    if (icuArrivalDate != null) {
                      Duration lengthOfStay =
                          value!.difference(icuArrivalDate!);
                      icuLengthOfStay = lengthOfStay.inDays;
                      _formKey.currentState!.fields['icuLengthStay']!
                          .didChange("${icuLengthOfStay.toString()} day/s");

                      icuExitDate = value;
                    }
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "ICU Length of Stay",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              FormBuilderTextField(
                enabled: false,
                initialValue: inHospitaldata['icu']['lengthOfStay'].toString(),
                name: 'icuLengthStay',
                decoration: const InputDecoration(
                  // labelText: 'ICU Length of Stay',
                  // hintStyle: TextStyle(color: Colors.grey),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
            ]));
  }

  // In-Hospital Data Widgets

  int getInreferralsNumber() {
    return inreferralsList.length;
  }

  Widget hospitalEventTemplate(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width * 0.9;

    return Card(
      // // // elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: SizedBox(
        width: widthScreen,
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                // you may want to use an aspect ratio here for tablet support
                height: 100.0,
                child: MultiSelectBottomSheetField(
                  initialValue: complications,
                  chipDisplay: MultiSelectChipDisplay(
                    height: 50,
                    scroll: true,
                  ),
                  listType: MultiSelectListType.LIST,
                  title: const Text("Add"),
                  searchHint: "Add Complication",
                  searchable: true,
                  searchIcon: const Icon(Icons.search),
                  items: complicationsList
                      .map((e) => MultiSelectItem(e, e))
                      .toList(),
                  onConfirm: (selectedItems) {
                    setState(() {
                      complications = selectedItems;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addInreferralsWidget(BuildContext context) {
    setState(() {
      int newIndex = inreferralsList.length;
      inreferralsList.add(inreferralsTemplate(index: newIndex));
    });
  }

  Widget inreferralsTemplate({required int index}) {
    return Card(
      // // elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Consultation ${index + 1}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FormBuilderSearchableDropdown(
                name: "consultationService${index + 1}",
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
                items: consultationServices,
              ),
              const SizedBox(height: 8),
              const Text(
                "Physician",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FormTextField(
                initialValue: name,
                name: "consultationPhysician${index + 1}",
                labelName: "",
              ),
              const SizedBox(height: 8),
              const Text(
                "Consultation Date and Time",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              FormBuilderDateTimePicker(
                inputType: InputType.date,
                format: DateFormat('yyyy-MM-dd'),
                initialDate: DateTime.now(),
                name: "consultationDate${index + 1}",
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                decoration: const InputDecoration(
                  // labelText: 'Consultation Date',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget comorbidityTemplate(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;

    return SizedBox(
      width: widthScreen,
      child: Card(
        // // elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        child: SizedBox(
          width: widthScreen,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  // you may want to use an aspect ratio here for tablet support
                  height: 100.0,
                  child: MultiSelectBottomSheetField(
                    initialValue: comorbidities,
                    chipDisplay: MultiSelectChipDisplay(
                      height: 50,
                      scroll: true,
                    ),
                    listType: MultiSelectListType.LIST,
                    title: const Text("Add"),
                    searchHint: "Add Comorbidity",
                    searchable: true,
                    searchIcon: const Icon(Icons.search),
                    items: comorbiditiesList
                        .map((e) => MultiSelectItem(e, e))
                        .toList(),
                    onConfirm: (selectedItems) {
                      setState(() {
                        comorbidities = selectedItems;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> readJsonICDCodes() async {
  //   final String response =
  //       await rootBundle.loadString('assets/json/icd10_codes.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     ICDCodes = data["CODES"];
  //     ICDCodesArray =
  //         ICDCodes.map((icdItem) => (icdItem["code"] + ": " + icdItem["desc"]))
  //             .cast<String>()
  //             .toList();
  //   });
  // }

  // void renderInHospitalWidgetsForEdit() {
  //   if (widget.patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]
  //           ["consultations"] !=
  //       null) {
  //     int lengthList = widget
  //         .patient[0]["patientHistory"][patientDetailsIndex]["inHospital"]
  //             ["consultations"]
  //         .length;
  //     for (var index = 0; index < lengthList; index++) {
  //       setState(() {
  //         inreferralsList.add(inreferralsTemplateForEdit(index));
  //       });
  //     }
  //   }
  // }

  // End of In-Hospital Data Widgets

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Next Phase'),
          content: const Text(
            'Are you sure you want to change the InHospital Data?',
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

                        if (result == true) {
                          setState(() {
                            isSending = true;
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

  @override
  void initState() {
    super.initState();
    initializeData();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> initializeData() async {
    inHospitaldata = parseInHospitalRecord(widget.inHospitalData);
    record = widget.record;
    // await readJsonICDCodes();

    setState(() {
      comorbidities = inHospitaldata['comorbidities'];
      complications = inHospitaldata['complications'];
      consultations = inHospitaldata['consultations'];

      if (inHospitaldata["vteProphylaxis"]['inclusion'] == "yes") {
        visibleVTEString = "yes";
        visibleVTE = true;
      }

      if (inHospitaldata['lifeSupportWithdrawal']['lswBoolean'] == "yes") {
        visibleLSW = true;
        visibleLSWString = "yes";
      }

      if (inHospitaldata['icu']['arrival'] != null) {
        visibleICU = true;
        visibleICUString = "yes";
        icuArrivalDate = DateTime.parse(inHospitaldata['icu']['arrival']);
        if (inHospitaldata['icu']['exit'] != null) {
          icuExitDate = DateTime.parse(inHospitaldata['icu']['exit']);
        }
      }
    });

    renderInHospitalWidgetsForEdit();
  }

  Future<void> _showConfirmationDialog2() async {
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
                // labelName: "",
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

                          await _insertData(
                            _formKey.currentState!.value,
                          );
                          setState(() {
                            isSending = false;
                            isSentSuccessfully = true;
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
                        length: 2, // Number of tabs
                        child: Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.white,
                            toolbarHeight: 10,
                            bottom: TabBar(
                              controller: _tabController,
                              tabs: const [
                                Tab(
                                  child: Text(
                                    "Editing",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'View Docs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.cyan,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          body: FormBuilder(
                            key: _formKey,
                            child: TabBarView(
                              controller: _tabController,
                              children: [
                                firstPage(context),
                                ViewSummary(
                                    patientData: widget.patientData,
                                    patient: widget.fullRecord),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ],
      ),
    );
  }

  Widget firstPage(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      persistentFooterButtons: [
        FormBottomButton(
          formKey: _formKey,
          onSubmitPressed: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              if (decryp(record['patientStatus']) == "In-Hospital") {
                _showConfirmationDialog2();
              } else {
                patientStatus = decryp(record['patientStatus']);
                _showConfirmationDialog();
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
        )
      ],
      body: Column(
        children: [
          Expanded(
            // child: Scaffold(
            //   body: FormBuilder(
            //     key: _formKey,
            //     autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      "Caprini Score",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    FormTextField(
                        initialValue: inHospitaldata['capriniScore'] ?? "",
                        name: "capriniScore",
                        labelName: ""),
                    const SizedBox(height: 16),
                    const Text(
                      "VTE Prophylaxis",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    FormRadio(
                      enabled: true,
                      name: 'vteInclusion',
                      initialValue: !visibleVTE ? "yes" : "no",
                      onChanged: (inclusionValue) {
                        if (inclusionValue == "yes") {
                          setState(() {
                            visibleVTE = true;
                          });
                        } else {
                          setState(() {
                            visibleVTE = false;
                          });
                        }
                      },
                      values: const ['yes', 'no'],
                      texts: const ['yes', 'no'],
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: visibleVTE,
                      child: Card(
                          // // elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.white,
                          child: condVTE()),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Life Support Withdrawal",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    FormRadio(
                      enabled: true,
                      name: 'lswBoolean',
                      initialValue: visibleLSW ? "yes" : "no",
                      onChanged: (lswValue) {
                        if (lswValue == "yes") {
                          setState(() {
                            visibleLSW = true;
                          });
                        } else {
                          setState(() {
                            visibleLSW = false;
                          });
                        }
                      },
                      values: const ['yes', 'no'],
                      texts: const ['yes', 'no'],
                    ),
                    const SizedBox(height: 8),
                    Visibility(
                      visible: visibleLSW,
                      child: Card(
                          // // elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.white,
                          child: condLSW()),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Is in ICU",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    FormRadio(
                      enabled: true,
                      name: 'inICU',
                      initialValue: !visibleICU ? "yes" : "no",
                      onChanged: (icuValue) {
                        if (icuValue == "yes") {
                          setState(() {
                            visibleICU = true;
                          });
                        } else {
                          setState(() {
                            visibleICU = false;
                          });
                        }
                      },
                      values: const ['yes', 'no'],
                      texts: const ['yes', 'No'],
                    ),
                    Visibility(
                      visible: visibleICU,
                      child: Card(
                          // elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          color: Colors.white,
                          child: condICU()),
                    ),
                    const Text(
                      "Comorbidities",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    comorbidityTemplate(context),
                    const SizedBox(height: 16),
                    const Text(
                      "Complications",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    hospitalEventTemplate(context),
                    const SizedBox(height: 16),
                    const Text(
                      "Consultations",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        addInreferralsWidget(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.grey[200]!),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Add',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 66, 66, 66))),
                          SizedBox(width: 8),
                          Icon(Icons.add,
                              color: Color.fromARGB(255, 66, 66, 66)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (inreferralsList.isEmpty)
                      const Text("No Consultations yet"),
                    if (inreferralsList.isNotEmpty)
                      SizedBox(
                        // you may want to use an aspect ratio here for tablet support
                        height: 290.0,
                        width: widthScreen,
                        child: ListView.builder(
                          // store this controller in a State to save the carousel scroll position
                          // controller: PageController(viewportFraction: 0.9),
                          itemCount: inreferralsList.length,
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          itemBuilder: (context, index) {
                            return inreferralsList[index];
                          },
                        ),
                      ),
                    const SizedBox(height: 16)
                  ],
                  //   ),
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
