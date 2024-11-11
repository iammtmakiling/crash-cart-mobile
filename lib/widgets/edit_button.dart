import 'package:dashboard/features/editFeature/edit_discharge.dart';
import 'package:dashboard/features/editFeature/edit_er.dart';
import 'package:dashboard/features/editFeature/editInHospital.dart';
import 'package:dashboard/features/editFeature/edit_prehospital.dart';
import 'package:dashboard/features/editFeature/edit_surgery.dart';
import 'package:dashboard/main/main_navigation.dart';
import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final String role;
  final String text;
  final Map<String, dynamic>? patient;
  final Map<String, dynamic> record;
  final Map<String, dynamic> unparsedRecord;

  const EditButton(
      {super.key,
      required this.role,
      this.patient,
      required this.text,
      required this.record,
      required this.unparsedRecord});

  @override
  Widget build(BuildContext context) {
    VoidCallback? onPressedAction;

    // Determine onPressed action based on the role
    switch (role) {
      case 'Pre-Hospital Staff':
        onPressedAction = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => editPreHospital(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                  );
                },
                patientData: patient!,
                record: unparsedRecord,
                preHospitalData: record['preHospital'].cast<String, dynamic>(),
                fullRecord: record,
              ),
            ),
          );
          // Get.to(
          //   editPreHospital(
          //     patientData: patient!,
          //     onBack: () {
          //       Navigator.pop(context);
          //     },
          //     record: unparsedRecord,
          //     preHospitalData: record['preHospital'].cast<String, dynamic>(),
          //     fullRecord: record,
          //   ),
          // );
        };
        break;
      case 'ER Staff':
        onPressedAction = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => editER(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                  );
                },
                patientData: patient!,
                record: unparsedRecord,
                fullRecord: record,
                erData: record['er'].cast<String, dynamic>(),
              ),
            ),
          );
          // Get.to(
          //   editER(
          //     onBack: () {
          //       Navigator.pop(context);
          //     },
          //     patientData: patient!,
          //     record: unparsedRecord,
          //     fullRecord: record,
          //     erData: record['er'].cast<String, dynamic>(),
          //   ),
          // );
        };
        break;
      case 'Surgery Staff':
        onPressedAction = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => editSurgery(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                  );
                },
                patientData: patient!,
                fullRecord: record,
                record: unparsedRecord,
                surgeryData: record['surgery'].cast<String, dynamic>(),
              ),
            ),
          );
        };
        break;
      case 'In-Hospital Staff':
        onPressedAction = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => editInHospital(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                  );
                },
                record: unparsedRecord,
                patientData: patient!,
                fullRecord: record,
                inHospitalData: record['inHospital'].cast<String, dynamic>(),
              ),
            ),
          );
          // Get.to(
          //   editInHospital(
          //     onBack: () {
          //       Navigator.pop(context);
          //     },
          //     record: unparsedRecord,
          //     patientData: patient!,
          //     fullRecord: record,
          //     inHospitalData: record['inHospital'].cast<String, dynamic>(),
          //   ),
          // );
        };
        break;
      case 'Discharge Staff':
        onPressedAction = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => editDischarge(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainNavigation(),
                    ),
                  );
                },
                record: unparsedRecord,
                patientData: patient!,
                fullRecord: record,
                dischargeData: record['discharge'].cast<String, dynamic>(),
              ),
            ),
          );
          // Get.to(
          //   editDischarge(
          //     onBack: () {
          //       Navigator.pop(context);
          //     },
          //     record: unparsedRecord,
          //     patientData: patient!,
          //     fullRecord: record,
          //     dischargeData: record['discharge'].cast<String, dynamic>(),
          //   ),
          // );
        };
        break;
      default:
        onPressedAction = null;
    }

    return Expanded(
      child: OutlinedButton(
        style: ButtonStyle(
          side: WidgetStateProperty.all(
            const BorderSide(color: Colors.cyan),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
          ),
        ),
        onPressed: onPressedAction,
        child: Text(
          text,
          style: const TextStyle(color: Colors.cyan),
        ),
      ),
    );
  }
}
