import 'package:flutter/material.dart';

class MyTextPasswordField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;

  const MyTextPasswordField({super.key, required this.hintText, required this.obscureText, this.onChanged, this.validator});

  @override
  MyTextPasswordFieldState createState() => MyTextPasswordFieldState();
}

class MyTextPasswordFieldState extends State<MyTextPasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      obscureText: _obscureText,
      style: TextStyle(fontFamily: 'OpenSans', color: Theme.of(context).primaryColorLight,),
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
        errorStyle: const TextStyle(fontFamily: 'OpenSans', color: Colors.red, fontSize: 16),
      ),
      validator: widget.validator,
    );
  }
}