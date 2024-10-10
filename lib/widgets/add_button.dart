import 'package:dashboard/features/addFeature/addDischarge.dart';
import 'package:dashboard/features/addFeature/add_er.dart';
import 'package:dashboard/features/addFeature/addInHospital.dart';
import 'package:dashboard/screens/home_page.dart';
import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String role;
  final String text;
  final Map<String, dynamic>? patient;
  final Map<String, dynamic> record;
  final Map<String, dynamic> unparsedRecord;

  // const AddButton({super.key, required this.role});
  const AddButton(
      {super.key,
      required this.text,
      required this.role,
      this.patient,
      required this.record,
      required this.unparsedRecord});

  @override
  Widget build(BuildContext context) {
    VoidCallback? onPressedAction;

    // Determine onPressed action based on the role
    switch (role) {
      case 'ER Staff':
        onPressedAction = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => addER(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                patientData: patient!,
                fullRecord: record,
                record: unparsedRecord,
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
              builder: (context) => addInHospital(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                patientData: patient!,
                fullRecord: record,
                record: unparsedRecord,
              ),
            ),
          );
          // Get.to(
          //   addInHospital(
          //     onBack: () {
          //       Navigator.pop(context);
          //     },
          //     patientData: patient!,
          //     fullRecord: record,
          //     record: unparsedRecord,
          //   ),
          // );
        };
        break;
      case 'Discharge Staff':
        onPressedAction = () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => addDischarge(
                onBack: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                patientData: patient!,
                fullRecord: record,
                record: unparsedRecord,
              ),
            ),
          );
          // Get.to(
          //   addDischarge(
          //     onBack: () {
          //       Navigator.pop(context);
          //     },
          //     patientData: patient!,
          //     fullRecord: record,
          //     record: unparsedRecord,
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
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
          backgroundColor: WidgetStateProperty.all(Colors.cyan),
        ),
        onPressed: onPressedAction,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
