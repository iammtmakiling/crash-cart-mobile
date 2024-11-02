// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/api_requests/_api.dart';
import 'package:dashboard/features/addFeature/add_surgery.dart';
import 'package:dashboard/globals.dart';
import 'package:dashboard/core/utils/helper_utils.dart';
import 'package:dashboard/screens/home_page.dart';

class AcceptButton extends StatefulWidget {
  final String role;
  final Map<String, dynamic>? patient;
  final Map<String, dynamic> record;
  final Map<String, dynamic> unparsedRecord;

  const AcceptButton({
    super.key,
    required this.role,
    this.patient,
    required this.record,
    required this.unparsedRecord,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AcceptButtonState createState() => _AcceptButtonState();
}

class _AcceptButtonState extends State<AcceptButton> {
  bool _isLoading = false;

  void _handlePress() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.role == 'Surgery Staff') {
        if (widget.record['patientStatus'] == "Pending Surgery") {
          widget.unparsedRecord['patientStatus'] = encryp("In-Surgery");

          String encodedpatientID =
              base64.encode(utf8.encode(widget.unparsedRecord['recordID']));

          await updateRecord(
              encodedpatientID, widget.unparsedRecord, bearerToken);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => addSurgery(
              record: widget.unparsedRecord,
              patientData: widget.patient!,
              fullRecord: widget.record,
              onBack: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          // _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEnabled = widget.role == 'Surgery Staff';

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
        ),
        onPressed: isEnabled && !_isLoading ? _handlePress : null,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                ),
              )
            : Text(
                (widget.record['patientStatus'] == "Pending Surgery")
                    ? "Accept Patient"
                    : "Edit",
                style: const TextStyle(color: Colors.cyan),
              ),
      ),
    );
  }
}
