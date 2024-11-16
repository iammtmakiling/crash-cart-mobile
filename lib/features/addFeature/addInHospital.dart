import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/core/theme/app_input_decoration.dart';
import 'package:dashboard/core/theme/app_text_theme.dart';
import 'package:dashboard/core/theme/app_theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/api_requests/_api.dart';
import 'package:dashboard/features/viewFeature/viewSummary.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/initializedList.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:dashboard/screens/pincode.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../globals.dart' as globals;

import 'dart:convert';

import '../../widgets/widgets.dart';
import '../../widgets/formWidgets/formWidgets.dart';

DateTime current = DateTime.now();

// ignore: camel_case_types
class addInHospital extends StatelessWidget {
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;
  final Map<String, dynamic> record;

  // ignore: use_super_parameters

  const addInHospital(
      {super.key,
      required this.patientData,
      required this.fullRecord,
      required this.record,
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
      home: AddInHospital(
          record: record,
          onBack: onBack,
          patientData: patientData,
          fullRecord: fullRecord),
    );
  }
}

// ignore: camel_case_types
class AddInHospital extends StatefulWidget {
  final Map<String, dynamic> record;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;
  const AddInHospital({
    super.key,
    required this.record,
    required this.onBack,
    required this.patientData,
    required this.fullRecord,
  });

  @override
  // ignore: library_private_types_in_public_api
  AddInHospitalState createState() => AddInHospitalState();
}

// ignore: camel_case_types
class AddInHospitalState extends State<AddInHospital>
    with SingleTickerProviderStateMixin {
// Form Key
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  // Screens
  bool isLoading = false;
  bool isSending = false;
  bool isSentSuccessfully = false;

  // ICU Visibility
  bool visibleVTE = false;
  bool visibleLSW = false;
  bool visibleICU = false;

  // General Data
  var patientStatus = "In-Hospital";
  late Map<String, dynamic> record;

  // List Variables
  // In-Hospital Data
  List<Widget> inreferralsList = [];
  List<dynamic> comorbidities = [];
  List<dynamic> complications = [];
  DateTime? icuArrivalDate;
  DateTime? icuExitDate;
  int icuLengthOfStay = 0;

  // Disposition List
  List<String> disposition = [
    'Pending Surgery',
    'Pending Discharge',
    'Deceased',
    'In-Hospital',
  ];

  late TabController _tabController;

  Future<void> _insertData(Map<String, dynamic> formValues) async {
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

    var createHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    Map<String, dynamic> inHospital = {
      "createHistory": createHistory,
      "editHistory": [],
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

    record['patientStatus'] = encryp(patientStatus);
    record['inHospital'] = inHospital;

    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));
    await updateRecord(encodedpatientID, record, bearerToken);

    setState(() {
      isSending = false;
      isSentSuccessfully = true;
    });
  }

  // Padding condVTE() {
  //   // need validators for ID format
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [

  //       ],
  //     ),
  //   );
  // }

  // Padding condLSW() {
  //   // need validators for ID format
  //   return Padding(
  //     padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [

  //       ],
  //     ),
  //   );
  // }

  Padding condICU() {
    // need validators for ID format
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("ICU Arrival", style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          FormBuilderDateTimePicker(
            inputType: InputType.date,
            format: DateFormat('yyyy-MM-dd'),
            name: "icuArrival",
            firstDate: DateTime(2000),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            decoration: AppInputDecoration.standard,
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
          ),
          const SizedBox(height: 8),
          Text(
            "ICU Exit",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormBuilderDateTimePicker(
            inputType: InputType.date,
            format: DateFormat('yyyy-MM-dd'),
            name: "icuExit",
            firstDate: DateTime(2000),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, DateTime.now().hour, DateTime.now().minute),
            decoration: AppInputDecoration.standard,
            onChanged: (DateTime? value) {
              setState(() {
                if (icuArrivalDate != null) {
                  Duration lengthOfStay = value!.difference(icuArrivalDate!);
                  icuLengthOfStay = lengthOfStay.inDays;
                  _formKey.currentState!.fields['icuLengthStay']!
                      .didChange("${icuLengthOfStay.toString()} day/s");
                }
                icuExitDate = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Text(
            "ICU Length of Stay",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormTextField(
            name: 'icuLengthStay',
            enabled: false,
            labelName: "",
          ),
        ],
      ),
    );
  }

  // In-Hospital Data Widgets

  int getInreferralsNumber() {
    return inreferralsList.length;
  }

  Widget hospitalEventTemplate(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width * 0.9;

    return Card(
      // elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                  buttonIcon: const Icon(LucideIcons.chevronDown),
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

  // Add this controller at class level
  final ScrollController _scrollController = ScrollController();

  void addInreferralsWidget(BuildContext context) {
    setState(() {
      int newIndex = inreferralsList.length;
      inreferralsList.add(inreferralsTemplate(index: newIndex));
    });

    // Scroll to bottom after widget is added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget inreferralsTemplate({required int index}) {
    return Card(
      // elevation: 5,
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              FormBuilderSearchableDropdown(
                name: "consultationService${index + 1}",
                decoration: AppInputDecoration.standard,
                dropdownSearchTextStyle: Theme.of(context).textTheme.bodySmall,
                items: consultationServices,
              ),
              const SizedBox(height: 8),
              Text(
                "Physician",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              FormTextField(
                initialValue: name,
                name: "consultationPhysician${index + 1}",
                labelName: "",
              ),
              const SizedBox(height: 8),
              Text(
                "Consultation Date and Time",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              FormBuilderDateTimePicker(
                lastDate: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    DateTime.now().hour,
                    DateTime.now().minute),
                format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                initialDate: DateTime.now(),
                initialValue: DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day,
                    DateTime.now().hour,
                    DateTime.now().minute),
                name: "consultationDate${index + 1}",
                firstDate: DateTime(2000),
                style: Theme.of(context).textTheme.bodySmall,
                decoration: AppInputDecoration.standard,
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
        // elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                    buttonIcon: const Icon(LucideIcons.chevronDown),
                    initialValue: comorbidities,
                    chipDisplay: MultiSelectChipDisplay(
                      height: 50,
                      scroll: true,
                    ),
                    listType: MultiSelectListType.LIST,
                    title: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Add",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    searchHint: "Add Comorbidity",
                    searchable: true,
                    searchIcon: const Icon(Icons.search),
                    items: comorbiditiesList
                        .map((e) => MultiSelectItem(e, e))
                        .toList(),
                    onConfirm: (selectedItems) {
                      setState(
                        () {
                          comorbidities = selectedItems;
                        },
                      );
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

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Next Phase'),
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
          // FormDropdown(
          //   name: "patientStatus",
          //   initialValue: "In-Hospital",
          //   items: disposition,
          //   labelName: "",
          //   onChange: (value) {
          //     patientStatus = value.toString();
          //   },
          // ),
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
            // TextButton(
            //   child: const Text('Cancel'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            // TextButton(
            //   child: const Text('Confirm'),
            //   onPressed: () async {
            //     Navigator.of(context).pop();
            //     if (patientStatus != "") {
            //       var result = await Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (BuildContext context) =>
            //                 const PinCodeScreen(),
            //             fullscreenDialog: true,
            //           ));

            //       if (result == true) {
            //         setState(() {
            //           isSending = true;
            //         });

            //         await _insertData(_formKey.currentState!.value);
            //       }
            //     }
            //   },
            // ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    record = widget.record;
    // readJsonICDCodes();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: 2, // Number of tabs
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  toolbarHeight: 10,
                  bottom: TabBar(
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
                    controller: _tabController,
                    tabs: [
                      Tab(
                        text: "Adding",
                      ),
                      Tab(
                        text: 'View Docs',
                      ),
                    ],
                  ),
                ),
                body: FormBuilder(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
          ),
        ],
      ),
    );
  }

  Widget firstPage(BuildContext context) {
    // var widthScreen = MediaQuery.of(context).size.width;

    return Scaffold(
      persistentFooterButtons: [
        FormBottomButton(
          formKey: _formKey,
          onSubmitPressed: () async {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              _showConfirmationDialog();
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
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Caprini Score",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      const FormTextField(name: "capriniScore", labelName: ""),
                      const SizedBox(height: 8),
                      Text(
                        "VTE Prophylaxis",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      FormRadio(
                        enabled: true,
                        name: 'vteInclusion',
                        onChanged: (inclusionValue) {
                          setState(() {
                            visibleVTE = inclusionValue == "yes";
                          });
                        },
                        values: const ['yes', 'no'],
                        texts: const ['Yes', 'No'],
                      ),
                      Text(
                        "VTE Type",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      FormTextField(
                          name: "vteType", labelName: "", enabled: visibleVTE),
                      const SizedBox(height: 8),
                      Text(
                        "Life Support Withdrawal",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      FormRadio(
                        enabled: true,
                        name: 'lswBoolean',
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
                        texts: const ['Yes', 'No'],
                      ),
                      const SizedBox(height: 8),
                      Text("LSW Date and Time",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      FormBuilderDateTimePicker(
                        name: 'lswTimestamp',
                        firstDate: DateTime(1900),
                        lastDate: DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                            DateTime.now().hour,
                            DateTime.now().minute),
                        format: DateFormat('yyyy-MM-dd HH:mm:ss'),
                        onChanged: (DateTime? value) {},
                        decoration: AppInputDecoration.withCustomColor(
                          fillColor: visibleLSW
                              ? AppColors.primaryVariant.withOpacity(0.1)
                              : AppColors.textTertiary.withOpacity(0.05),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Is in ICU",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      FormRadio(
                        enabled: true,
                        name: 'inICU',
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
                        texts: const ['Yes', 'No'],
                      ),
                      Visibility(
                        visible: visibleICU,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.white,
                            child: condICU()),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Comorbidities",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      comorbidityTemplate(context),
                      const SizedBox(height: 16),
                      Text(
                        "Complications",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      hospitalEventTemplate(context),
                      const SizedBox(height: 8),
                      Divider(
                        color: AppColors.textPrimary,
                      ),
                      Row(
                        children: [
                          Text(
                            "Consultations",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              addInreferralsWidget(context);
                            },
                            icon: const Icon(LucideIcons.plusCircle, size: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (inreferralsList.isEmpty)
                        Center(
                          child: Text(
                            "No Consultations yet",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      if (inreferralsList.isNotEmpty) ...inreferralsList,
                      const SizedBox(height: 16)
                    ],
                  ),
                ),
              ),
            ),
          ),
          // ),
        ],
      ),
    );
  }
}
