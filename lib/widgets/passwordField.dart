import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final GlobalKey<FormState> formKey;

  const PasswordFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.formKey,
  });
  @override
  // ignore: library_private_types_in_public_api
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextFormField(
        obscureText: _obscure,
        controller: widget.controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.cyan), // Border color when focused
          ),
          labelText: widget.label,
          prefixIcon: const Icon(Icons.lock, color: Colors.blue),
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _obscure = !_obscure;
              });
            },
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          ),
        ),
        onSaved: (String? initialValue) {
          widget.formKey.currentState?.save();
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Cannot be blank';
          }
          return null;
        },
      ),
    );
  }
}
