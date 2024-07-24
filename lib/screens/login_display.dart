import 'package:flutter/material.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/screens/sign_in.dart';
import 'package:trakify/ui_components/app_bar_logo.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/text.dart';

class LoginDisplayScreen extends StatefulWidget {
  const LoginDisplayScreen({super.key});

  @override
  State<LoginDisplayScreen> createState() => _LoginDisplayScreenState();
}

class _LoginDisplayScreenState extends State<LoginDisplayScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  appBarLogo(context),
                  const SizedBox(height: 60,),
                  const Padding(padding: EdgeInsets.only(left: 20.0),
                    child: MySimpleText(text: 'Find your perfect\nplace to stay', size: 28, color: Colors.black,),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 20),
                    child: Image.asset('assets/images/login_display.png',
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 30),
                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyButton(text: 'LOGIN', onPressed: () {
                          Navigator.pushReplacement(context, CustomPageRoute(nextPage: const SignInPage(), direction: 1));
                        },),
                      ],
                    ),
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