import 'dart:io';
import 'package:flutter/material.dart';

class NetworkUtil {
  static Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  static void checkConnectionAndProceed(BuildContext context, Function onConnected) async {
    bool connected = await isConnected();
    if (connected) {
      onConnected();
    } else {
      _showNoConnectionDialog(context);
    }
  }

  static void _showNoConnectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}