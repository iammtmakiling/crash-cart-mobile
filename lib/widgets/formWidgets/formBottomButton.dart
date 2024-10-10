import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormBottomButton extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final VoidCallback? onSubmitPressed;

  const FormBottomButton({
    super.key,
    required this.formKey,
    this.onSubmitPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Expanded(
          //   child: OutlinedButton(
          //     style: ButtonStyle(
          //       side: WidgetStateProperty.all(
          //         const BorderSide(color: Colors.cyan),
          //       ),
          //     ),
          //     onPressed: () {
          //       formKey.currentState!.save();
          //       formKey.currentState!.reset();
          //     },
          //     child: const Text(
          //       "Reset",
          //       style: TextStyle(color: Colors.cyan),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: 20),
          Expanded(
            child: MaterialButton(
              color: Colors.cyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              onPressed: onSubmitPressed,
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
