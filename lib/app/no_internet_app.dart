import 'package:flutter/material.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/main.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/text.dart';

class NoInternetApp extends StatelessWidget {
  const NoInternetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FadeInAnimation(
                    direction: 'down',
                    delay: 0.6,
                    child: MyHeadingText(text: "T R A C I F Y"),
                  ),
                  const SizedBox(height: 20),
                  InfiniteAnimation(
                    textToShow: "Please connect to internet",
                    connectedWidget: Icon(Icons.wifi, key: UniqueKey(), color: Colors.green, size: 100,),
                    disconnectedWidget: Icon(Icons.wifi_off, key: UniqueKey(), color: Colors.red, size: 100,),
                  ),
                  const SizedBox(height: 20),
                  Builder(
                      builder: (context) {
                        return MyButton(
                          onPressed: () async {
                            NetworkUtil.checkConnectionAndProceed(context, (){
                              Navigator.pushReplacement(context, CustomPageRoute(nextPage: const MyApp(), direction: 1),);
                            });
                          }, text: 'retry',
                        );
                      }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}