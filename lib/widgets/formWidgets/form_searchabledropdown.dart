import 'package:dashboard/widgets/formWidgets/formWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_searchable_dropdown/flutter_searchable_dropdown.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class FormSearchableDropdown<T> extends StatefulWidget {
  final String name;
  final List<T> items;
  final String? Function(T?)? validator;
  final void Function(T?)? onChange;
  final T? initialValue;
  final T? selectedValue;
  final String? textFieldLabel;
  final GlobalKey<FormBuilderState> formKey;

  const FormSearchableDropdown({
    super.key,
    required this.name,
    required this.items,
    required this.selectedValue,
    required this.formKey,
    this.validator,
    this.onChange,
    this.initialValue,
    this.textFieldLabel,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FormSearchableDropdownState<T> createState() =>
      _FormSearchableDropdownState<T>();
}

class _FormSearchableDropdownState<T> extends State<FormSearchableDropdown<T>> {
  late T? _selectedValue;
  bool isOption = false;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchableDropdown.single(
          items: widget.items
              .map((item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          value: _selectedValue,
          hint: "Select one",
          searchHint: "Search and select one",
          isExpanded: true,
          underline: Container(
            height: 1.0,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black54, width: 1.0),
              ),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _selectedValue = value as T?;
              if (_selectedValue == 'Others') {
                isOption = true;
              } else {
                isOption = false;
              }
            });
            if (widget.onChange != null) {
              widget.onChange!(value as T?);
            }
            if (_selectedValue.toString() != 'Others') {
              widget.formKey.currentState!.fields[widget.name]!.didChange("");
            }
          },
        ),
        if (isOption) ...[
          const SizedBox(height: 12),
          FormTextField(
            name: widget.name,
            validator: FormBuilderValidators.required(),
            labelName: widget.textFieldLabel ?? "specify",
            onChanged: (value) {
              setState(() {
                _selectedValue = value ?? '';
              });
              if (widget.onChange != null) {
                widget.onChange!(value as T?);
              }
            },
          ),
        ],
      ],
    );
  }
}
