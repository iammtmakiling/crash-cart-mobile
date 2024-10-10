import 'package:flutter/material.dart';

class ErrorModal extends StatelessWidget {
  final List<String> errorFields;
  final VoidCallback onClose;

  const ErrorModal(
      {super.key, required this.errorFields, required this.onClose});

  @override
  Widget build(BuildContext context) {
    var widthScreen = MediaQuery.of(context).size.width;

    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "An error occurred while processing your request.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 90.0,
              width: widthScreen * 0.9,
              child: ListView.builder(
                itemCount: errorFields.length,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                itemBuilder: (context, index) {
                  return Text(
                    errorFields[index],
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: OutlinedButton(
                style: ButtonStyle(
                  side: WidgetStateProperty.all(
                    const BorderSide(color: Colors.cyan),
                  ),
                ),
                onPressed: onClose,
                child: const Text(
                  "Close",
                  style: TextStyle(color: Colors.cyan),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
