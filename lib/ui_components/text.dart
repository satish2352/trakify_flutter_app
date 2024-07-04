import 'package:flutter/material.dart';

class MyHeadingText extends StatelessWidget {
  final String text;
  final Color? color;
  const MyHeadingText({
    super.key,
    required this.text,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: color ?? Theme.of(context).primaryColorDark,
      ),
    );
  }
}

class MySubHeadingText extends StatelessWidget {
  final String text;
  final bool? light;
  final Color? color;
  const MySubHeadingText(
      {super.key, required this.text, this.light, this.color});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: color ?? Theme.of(context).primaryColorLight,
      ),
    );
  }
}

class MySimpleText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color;
  final bool bold;
  final bool center;

  const MySimpleText({
    super.key,
    required this.text,
    required this.size,
    this.color,
    this.bold = false,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color ?? Theme.of(context).primaryColorLight,
      ),
      textAlign: center ? TextAlign.center : TextAlign.left,
    );
  }
}

class MyLinkText extends StatelessWidget {
  final String text;
  final Color? textColor;
  const MyLinkText({super.key, required this.text, this.textColor});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'OpenSans',
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: textColor ?? Theme.of(context).primaryColorLight,
      ),
    );
  }
}
