import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  final VoidCallback onReset;

  const ResetButton({super.key, required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 8.0),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
          ),
          side: WidgetStateProperty.all(
            BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        child: Text(
          "Reset",
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
        onPressed: () async {
          bool shouldReset = await _showResetConfirmationDialog(context);
          if (shouldReset) {
            onReset();
          }
        },
      ),
    );
  }

  Future<bool> _showResetConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false, // user must tap a button to dismiss
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Are you sure you want to reset the form?',
                    textAlign: TextAlign.center,
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
                          Navigator.of(context).pop(false); // Cancel
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MaterialButton(
                        color: Colors.cyan,
                        onPressed: () {
                          Navigator.of(context).pop(true); // Confirm reset
                        },
                        child: const Text(
                          "Confirm",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
        false; // Default to false if dismissed
  }
}
