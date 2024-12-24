import 'dart:async';

import 'package:dashboard/core/provider/user_provider.dart';
import 'package:dashboard/features/viewFeature/components/view_expand.dart';
import 'package:dashboard/features/viewFeature/components/view_row.dart';
import 'package:dashboard/screens/RecordsScreen/widgets/patient_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '_view.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ViewMain extends StatefulWidget {
  final VoidCallback onBack;
  final Map<String, dynamic> patient;
  final Map<String, dynamic> unparsedPatient;

  const ViewMain({
    super.key,
    required this.patient,
    required this.onBack,
    required this.unparsedPatient,
  });

  @override
  ViewMainState createState() => ViewMainState();
}

class ViewMainState extends State<ViewMain> {
  Timer? _scrollDebounce;

  String _currentVisibleSection = 'General Data';
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _sectionKeys = {
    'General Data': GlobalKey(),
    'Preadmission Data': GlobalKey(),
    'ER Data': GlobalKey(),
    'Hospital Data': GlobalKey(),
    'Surgery Data': GlobalKey(),
    'Discharge Data': GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_updateCurrentSection);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateCurrentSection);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateCurrentSection() {
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();
    _scrollDebounce = Timer(const Duration(milliseconds: 200), () {
      if (!_scrollController.hasClients) return;

      String visibleSection = "General Data";
      double minDistance = double.infinity;

      _sectionKeys.forEach((section, key) {
        if (key.currentContext != null) {
          final RenderBox box =
              key.currentContext!.findRenderObject() as RenderBox;
          final position = box.localToGlobal(Offset.zero);
          final double appBarHeight =
              MediaQuery.of(context).padding.top + kToolbarHeight;
          final double distance = (position.dy - appBarHeight).abs();

          if (distance < minDistance) {
            minDistance = distance;
            visibleSection = section;
          }
        }
      });

      if (_currentVisibleSection != visibleSection) {
        setState(() {
          _currentVisibleSection = visibleSection;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    final List<String> availableSections = [
      'General Data',
      'Preadmission Data',
      if (widget.patient['record']['er'].isNotEmpty) 'ER Data',
      if (widget.patient['record']['inHospital'].isNotEmpty) 'Hospital Data',
      if (widget.patient['record']['surgery'].isNotEmpty) 'Surgery Data',
      if (widget.patient['record']['discharge'].isNotEmpty) 'Discharge Data',
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title:
            Text("View Patient", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            widget.onBack();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  PatientBox(
                    viewMoreStatus: true,
                    patient: widget.patient,
                    isTile: false,
                  ),
                  ..._buildExpandButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: availableSections.map((section) {
            IconData icon;
            switch (section) {
              case "General Data":
                icon = LucideIcons.userCircle2;
                break;
              case "Preadmission Data":
                icon = LucideIcons.clipboardList;
                break;
              case "ER Data":
                icon = LucideIcons.stethoscope;
                break;
              case "Hospital Data":
                icon = LucideIcons.building2;
                break;
              case "Surgery Data":
                icon = LucideIcons.scissors;
                break;
              case "Discharge Data":
                icon = LucideIcons.logOut;
                break;
              default:
                icon = LucideIcons.circle;
            }
            return _buildNavButton(section, icon);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNavButton(String section, IconData icon) {
    final isActive = _currentVisibleSection == section;
    return Tooltip(
      message: section,
      child: IconButton(
        icon: Icon(
          icon,
          color: isActive ? Theme.of(context).primaryColor : Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _currentVisibleSection = section;
          });

          if (_sectionKeys[section]?.currentContext != null) {
            Scrollable.ensureVisible(
              _sectionKeys[section]!.currentContext!,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: 0.0,
            );
          }
        },
      ),
    );
  }

  List<Widget> _buildExpandButtons() {
    return [
      _createExpandButton(
          "General Data", widget.patient['general'], widget.patient['record']),
      _createExpandButton(
          "Preadmission Data", widget.patient['record']['preHospital']),
      if (widget.patient['record']['er'].isNotEmpty)
        _createExpandButton("ER Data", widget.patient['record']['er']),
      if (widget.patient['record']['inHospital'].isNotEmpty)
        _createExpandButton(
            "Hospital Data", widget.patient['record']['inHospital']),
      if (widget.patient['record']['surgery'].isNotEmpty)
        _createExpandButton(
            "Surgery Data", widget.patient['record']['surgery']),
      if (widget.patient['record']['discharge'].isNotEmpty)
        _createExpandButton(
            "Discharge Data", widget.patient['record']['discharge']),
    ];
  }

  Widget _createExpandButton(String title, dynamic patientRecord,
      [Map<String, dynamic>? additionalRecord]) {
    return ExpandButton(
      key: _sectionKeys[title],
      text: title,
      onTap: () {
        // Handle edit action here
      },
      widget: _getViewWidget(title, patientRecord, additionalRecord),
    );
  }

  Widget _getViewWidget(String title, dynamic patientRecord,
      [Map<String, dynamic>? additionalRecord]) {
    switch (title) {
      case "General Data":
        return ViewGeneral(
          patientDetail: patientRecord,
          patientRecord: additionalRecord!,
        );
      case "Preadmission Data":
        return ViewPreHospital(
            patientRecord: patientRecord.cast<String, dynamic>());
      case "ER Data":
        return ViewER(patientRecord: patientRecord.cast<String, dynamic>());
      case "Hospital Data":
        return ViewInHospital(
            patientRecord: patientRecord.cast<String, dynamic>());
      case "Surgery Data":
        return ViewSurgery(
            patientRecord: patientRecord.cast<String, dynamic>());
      case "Discharge Data":
        return ViewDischarge(
            patientRecord: patientRecord.cast<String, dynamic>());
      default:
        return SizedBox.shrink();
    }
  }
}
