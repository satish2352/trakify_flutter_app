import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget{

  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Icon? ic;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;

  const MyTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.ic,
    this.controller,
    this.keyboardType,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      onChanged: onChanged,
      inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
      style: TextStyle(fontFamily: 'OpenSans', color: Theme.of(context).primaryColorLight,),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: ic,
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorStyle: const TextStyle(fontFamily: 'OpenSans', color: Colors.red, fontSize: 16),
      ),
      validator: validator,
    );
  }
}

/*
class MyIconTextField extends StatelessWidget{

  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Icon ic;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;

  const MyIconTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.validator,
    required this.ic,
    this.controller,
    this.keyboardType,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Material(elevation: 4, borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
        style: TextStyle(fontFamily: 'OpenSans', color: Theme.of(context).primaryColorLight,),
        decoration: InputDecoration(hintText: hintText,
          prefixIcon: Padding(padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(30),
              ),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white), child: ic,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(35),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(35),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35),
          ),
          errorStyle: const TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
*/

class MyIconTextField extends StatelessWidget {
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final Icon ic;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;

  const MyIconTextField({
    super.key,
    required this.hintText,
    this.onChanged,
    this.validator,
    required this.ic,
    this.controller,
    this.keyboardType,
    this.inputFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(30),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
        style: TextStyle(
          fontFamily: 'OpenSans',
          color: Theme.of(context).primaryColorLight,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconTheme(
                data: const IconThemeData(color: Colors.white),
                child: ic,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(35),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(35),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(35),
          ),
          errorStyle: const TextStyle(
            fontFamily: 'OpenSans',
            color: Colors.red,
            fontSize: 16,
          ),
        ),
        validator: validator,
      ),
    );
  }
}