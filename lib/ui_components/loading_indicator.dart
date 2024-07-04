import 'package:flutter/material.dart';
import 'package:trakify/ui_components/text.dart';

class LoadingIndicator {
  static Widget build() => const Scaffold(
    body: Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              strokeWidth: 2,
            ),
            SizedBox(height: 50,),
            MySimpleText(text: 'Loading your data', size: 20,),
          ],
        ),
      ),
    ),
  );
}