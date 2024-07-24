import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool shouldExitApp;

  const CustomAppBar({
    super.key,
    required this.scaffoldKey,
    this.shouldExitApp = false,
  });

  @override
  Widget build(BuildContext context) {

    return AppBar(
      elevation: 4,
      title://const Text("Trakify"),
      Image.asset(
        'assets/images/logo_blue.png',
        width: MediaQuery.sizeOf(context).width*0.3,
        fit: BoxFit.fill,
      ),
      leading: IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (scaffoldKey.currentState!.isEndDrawerOpen) {
            scaffoldKey.currentState!.openEndDrawer();
          } else {
            if (shouldExitApp) {
              _exitApp(context, shouldExitApp);
            } else {
              Navigator.pop(context);
            }
          }
        },
        icon: const Icon(Icons.arrow_back_ios),
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.menu_outlined),
          onPressed: () {
            scaffoldKey.currentState!.openEndDrawer();
          },
        ),
      ],
    );
  }

  // This is required to set the size of the AppBar
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _exitApp(BuildContext context, bool isExitPressed) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (isExitPressed) {
      exit(0);
    } else {
      isExitPressed = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Press back again to exit"),
      ));
      Timer(const Duration(seconds: 2), () {
        isExitPressed = false;
      });
    }
  }

}