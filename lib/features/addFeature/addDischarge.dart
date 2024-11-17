import 'package:dashboard/core/theme/app_colors.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/api_requests/_api.dart';
import 'package:dashboard/features/viewFeature/viewSummary.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/widgets/formWidgets/formTextArea.dart';
import 'package:dashboard/widgets/miniAppBarBack.dart';
import 'package:flutter/material.dart';
// import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../globals.dart' as globals;

import 'dart:convert';
import '../../screens/screens.dart';
import '../../widgets/formWidgets/formWidgets.dart';

// import 'package:dashboard/globals.dart';

DateTime current = DateTime.now();

// ignore: camel_case_types
class addDischarge extends StatelessWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final Map<String, dynamic> record;
  const addDischarge({
    super.key,
    required this.patientData,
    required this.record,
    required this.onBack,
    required this.fullRecord,
  });

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
      home: AddDischarge(
          record: record,
          onBack: onBack,
          patientData: patientData,
          fullRecord: fullRecord),
    );
  }
}

// ignore: camel_case_types
class AddDischarge extends StatefulWidget {
  final Map<String, dynamic> record;
  final Map<String, dynamic> patientData;
  final Map<String, dynamic> fullRecord;
  final VoidCallback onBack;
  const AddDischarge({
    super.key,
    required this.record,
    required this.onBack,
    required this.patientData,
    required this.fullRecord,
  });

  @override
  // ignore: library_private_types_in_public_api
  AddDischargeState createState() => AddDischargeState();
}

// ignore: camel_case_types
class AddDischargeState extends State<AddDischarge>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  bool isAtBottom = false;
  final ScrollController _scrollController = ScrollController();

  // Record Related
  late Map<String, dynamic> record;

  // Screen State
  bool isSending = false;
  bool isSentSuccessfully = false;

  // Patient Status
  String patientStatus = 'Discharged';

  // ICD Codes
  List<String> ICDCodesArray = [];

  // Discharge Disposition
  List<String> dischargeDispositionArray = [
    'Home Discharge',
    'Discharge Against Medical Advice (DAMA)',
    'Transfer to Another Facility',
    'Hospice Care',
    'Rehabilitation Facility',
    'Long-Term Care Facility',
    'Observation Status',
    'Transferred to Psychiatric Facility',
    'Left Against Medical Advice (LAMA)',
    'Deceased'
  ];

  late TabController _tabController;

  Future<void> _insertData(Map<String, dynamic> formValues) async {
    var createHistory = {
      "userID": globals.userID,
      "timestamp": DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
    };

    Map<String, dynamic> discharge = {
      "createHistory": createHistory,
      "editHistory": [],
      "isTreatmentComplete":
          nullChecker(formValues["treatmentCompletedDischarge"]),
      "finalDiagnosis": nullChecker(formValues["icdCodeDischarge"]),
      "dispositionDischarge": nullChecker(formValues["dispositionDischarge"])
    };

    record['patientStatus'] = encryp(patientStatus);
    record['discharge'] = discharge;

    String encodedpatientID = base64.encode(utf8.encode(record['recordID']));
    await updateRecord(encodedpatientID, record, bearerToken);
  }

  Widget treatmentCompleted(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: widthScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Treatment Completed?",
                style: Theme.of(context).textTheme.bodyMedium),
            FormRadio(
              enabled: true,
              name: "treatmentCompletedDischarge",
              values: const ["yes", "no"],
              texts: const ["yes", "no"],
              validator: FormBuilderValidators.required(),
            ),
          ],
        ),
      ),
    );
  }

  Widget icdCodeAndDiagnosis(BuildContext context) {
    // var widthScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Final Diagnosis",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FormTextArea(name: "icdCodeDischarge", labelName: "Description")
          // FormTextField(name: "icdCodeDischarge", labelName: "")
        ],
      ),
    );
  }

  Widget dischargeDisposition(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: widthScreen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Disposition on Discharge?",
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            FormBuilderRadioGroup(
              enabled: true,
              name: "dispositionDischarge",
              validator: FormBuilderValidators.required(),
              decoration: const InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                labelStyle: TextStyle(fontSize: 18),
              ),
              options: dischargeDispositionArray
                  .map((dispoItem) => FormBuilderFieldOption(
                        value: dispoItem,
                        child: Text(dispoItem),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value == 'Deceased') {
                  setState(() {
                    patientStatus = 'Discharged';
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // End of Discharge Data Widgets

  void _onScroll() {
    if (_scrollController.hasClients) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 50.0; // Threshold of 50 pixels from bottom

      setState(() {
        isAtBottom = maxScroll - currentScroll <= delta;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    record = widget.record;
    _tabController = TabController(length: 2, vsync: this);

    // Replace the old scroll listener with the new one
    _scrollController.addListener(_onScroll);
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
          // if (!isSending && !isSentSuccessfully)
          //   MiniAppBarBack(
          //     onBack: widget.onBack,
          //   ),
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
          // :
          Expanded(
            child: DefaultTabController(
                length: 2, // Number of tabs
                child: Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Text("Adding Discharge Data",
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppColors.primary)),
                    centerTitle: true,
                    leading: IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(LucideIcons.chevronLeft,
                          size: 24, color: AppColors.textPrimary),
                    ),
                    actions: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            // Refresh logic here
                            _formKey.currentState?.reset();
                          });
                        },
                        icon: const Icon(LucideIcons.listRestart,
                            size: 24, color: AppColors.textPrimary),
                      ),
                    ],
                    bottom: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Text(
                            "Adding",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Tab(
                          child: Text(
                            'View Docs',
                            style: Theme.of(context).textTheme.bodyMedium,
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
                )),
          ),
        ],
      ),
    );
  }

  Widget firstPage(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: isAtBottom
          ? [
              FormBottomButton(
                formKey: _formKey,
                onSubmitPressed: () async {
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

                      await _insertData(
                        _formKey.currentState!.value,
                      );
                      setState(() {
                        isSending = false;
                        isSentSuccessfully = true;
                      });
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
            ]
          : null,
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    treatmentCompleted(context),
                    icdCodeAndDiagnosis(context),
                    dischargeDisposition(context)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
