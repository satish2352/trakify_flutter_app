import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trakify/app/no_internet_app.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/screens/choose_project.dart';
import 'package:trakify/screens/splash_screen.dart';
import 'package:trakify/ui_components/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    runApp(
        ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
            child: const NoInternetApp(),
        ),
    );
  } else {
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const MyApp(),
      ),
    );
  }
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
        brightness: Brightness.light,
        primaryColorDark: Colors.black,
        primaryColorLight: Colors.grey[700],
        primaryColor: Colors.blueAccent,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColorDark: Colors.white,
        primaryColor: Colors.blueAccent,
        primaryColorLight: Colors.grey[300],
        primarySwatch: Colors.blue,
      ),
      themeMode: Provider.of<ThemeProvider>(context).getCurrentTheme(),
      home: const SplashScreen(),
      //home: const ChooseProjectPage(userID: "6655933947cf188e0714349a"),
    );
  }
}