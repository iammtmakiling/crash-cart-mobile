import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormChipField extends StatefulWidget {
  final String name;
  final String labelName;
  // final List<String> options;

  const FormChipField({
    super.key,
    required this.name,
    required this.labelName,
    // required this.options,
  });

  @override
  _FormChipFieldState createState() => _FormChipFieldState();
}

class _FormChipFieldState extends State<FormChipField> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormBuilderTextField(
            name: 'newChip',
            controller: _textEditingController,
            onSubmitted: (value) {
              if (value!.isNotEmpty) {
                setState(() {
                  selectedOptions.add(value);
                  _textEditingController.clear();
                });
              }
            },
            decoration: const InputDecoration(
              labelText: 'Add new',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "List of ${widget.labelName}",
                      style: const TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: selectedOptions.map((option) {
                        return InputChip(
                          label: Text(option),
                          onDeleted: () {
                            setState(() {
                              selectedOptions.remove(option);
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
