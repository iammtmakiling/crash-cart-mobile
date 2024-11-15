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
          Expanded(
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
              onPressed: () {
                formKey.currentState!.save();
                formKey.currentState!.reset();
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: MaterialButton(
              color: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              onPressed: onSubmitPressed,
              child: Text(
                "Submit",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
