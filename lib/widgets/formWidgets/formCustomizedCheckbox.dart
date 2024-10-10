import 'package:dashboard/widgets/formWidgets/formTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormCustomizedCheckbox extends StatefulWidget {
  final String name;
  final List<dynamic> options;

  const FormCustomizedCheckbox({
    super.key,
    required this.name,
    required this.options,
  });

  @override
  _FormCheckboxState createState() => _FormCheckboxState();
}

class _FormCheckboxState extends State<FormCustomizedCheckbox> {
  List<bool> checkboxStates = [];

  @override
  void initState() {
    super.initState();
    checkboxStates = List<bool>.filled(widget.options.length, false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.options.length, (index) {
        return Column(
          children: [
            FormBuilderCheckbox(
              name: widget.name,
              title: Text(widget.options[index].toString()),
              onChanged: (value) {
                setState(() {
                  checkboxStates[index] = value ?? false;
                });
              },
            ),
            if (checkboxStates[index])
              FormTextField(
                name: widget.options[index].toString(),
                labelName:
                    "Add details for ${widget.options[index].toString()}",
              ),
          ],
        );
      }),
    );
  }
}
