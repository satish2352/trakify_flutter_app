import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/screens/choose_project.dart';
import 'package:trakify/screens/intro_screen.dart';
import 'package:trakify/screens/login_display.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  late Widget nextScreen;
  bool firstLaunch = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    firstLaunch = await _isFirstLaunch();
    Future.delayed(const Duration(seconds: 4), _checkLoggedIn);
  }

  Future<void> _checkLoggedIn() async {
    if (firstLaunch) {
      nextScreen = const Intro();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(!mounted) return;
      String? userID = prefs.getString('userID');
      String? isSignedIn = prefs.getString('signedIn');
      if (userID != null && userID.isNotEmpty && isSignedIn != null && isSignedIn.isNotEmpty) {
        nextScreen = ChooseProjectPage(userID: userID);
      } else {
        nextScreen = const LoginDisplayScreen();
      }
    }
    Navigator.pushReplacement(context, CustomPageRoute(nextPage: nextScreen, direction: 1));
  }

  Future<bool> _isFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTime = prefs.getBool('isFirstLaunch');
    if (isFirstTime == null || isFirstTime) {
      await prefs.setBool('isFirstLaunch', false);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    double imageWidth = MediaQuery.of(context).size.width*0.8,
    imageHeight = imageWidth*0.5;

    return Scaffold(
      backgroundColor: MyColor.deepNavyBlue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: InfiniteAnimation(
              textToShow: "",
              connectedWidget: Image.asset('assets/images/logo_white.png',
                key: UniqueKey(),
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
              ),
              disconnectedWidget: Image.asset('assets/images/logo_blue.png',
                key: UniqueKey(),
                width: imageWidth,
                height: imageHeight,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}