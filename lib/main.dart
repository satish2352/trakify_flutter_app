import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Trakify',
      theme: ThemeData(
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.grey[700],
        primaryColor: Colors.blueAccent,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      //home: const ChooseProjectPage(userID: "6655933947cf188e0714349a"),
    );
  }
}