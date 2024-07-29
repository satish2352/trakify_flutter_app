import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class DialogManager {

  static Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Please wait..."),
            ],
          ),
        );
      },
    );
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  static void showSuccessDialog(BuildContext context, String title, String description) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: title,
      desc: description,
      autoHide: const Duration(seconds: 3),
      dialogBorderRadius: BorderRadius.circular(20),
    ).show();
  }

  static void showQuestionDialog(BuildContext context, String title, Function()? onOkPressed) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.scale,
      title: title,
      btnCancelOnPress: () {},
      btnCancelText: 'Cancel',
      btnOkOnPress: onOkPressed,
      btnOkText: 'Confirm',
    ).show();
  }

  static void showInfoDialog(BuildContext context, String title, String description) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      title: title,
      desc: description,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    ).show();
  }

  static void showErrorDialog(BuildContext context, String title, String description) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    ).show();
  }
}