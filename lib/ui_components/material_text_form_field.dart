import'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaterialTextFormField extends StatefulWidget {
  final String hintText;
  final IconData suffixIcon;
  final TextEditingController controller;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const MaterialTextFormField({
    super.key,
    required this.hintText,
    required this.suffixIcon,
    required this.controller,
    this.inputFormatters,
    this.keyboardType,
    this.onChanged,
  });

  @override
  MaterialTextFormFieldState createState() => MaterialTextFormFieldState();
}

class MaterialTextFormFieldState extends State<MaterialTextFormField> {
  bool manuallyTapped = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextField(
          controller: widget.controller,
          autofocus: manuallyTapped,
          onTap: () {
            setState(() {
              manuallyTapped = true;
            });
          },
          onChanged: widget.onChanged,
          onSubmitted: (_) {
            setState(() {
              manuallyTapped = false;
            });
          },
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: 'OpenSans',
              color: Colors.grey,
            ),
            suffixIcon: Icon(widget.suffixIcon),
            border: InputBorder.none,
          ),
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.keyboardType,
        ),
      ),
    );
  }
}
