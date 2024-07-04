import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/screens/choose_project.dart';
import 'package:trakify/screens/otp_screen.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/app_bar_logo.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/my_text_field.dart';
import 'package:trakify/ui_components/text.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  SignInPageState createState() => SignInPageState();
}

class SignInPageState extends State<SignInPage> {

  //String userID = '663c4806c3d95b4a80840035';
  String mobile = '';
  String password = '';
  bool staySignedIn = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    staySignedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(padding:const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              appBarLogo(context),
              const SizedBox(height: 30,),
              const FadeInAnimation(direction: 'down', delay: 0.6,
                child: MyHeadingText(text: "LOGIN"),
              ),
              const SizedBox(height: 60.0),
              FadeInAnimation(direction: 'down', delay: 1,
                child: MyIconTextField(
                  hintText: "Enter Mobile Number",
                  keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                  ic: const Icon(Icons.call, color: Colors.white,),
                  onChanged: (value) {
                    setState(() {
                      mobile = sanitizePhoneNumber(value);
                    });
                    _formKey.currentState!.validate();
                  },
                  validator: (value) {
                    String sanitizedValue = sanitizePhoneNumber(value!);
                    if (sanitizedValue.length != 10) {
                      return 'Please enter a 10-digit phone number';
                    }
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              FadeInAnimation(direction: 'down', delay: 1.6,
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyButton(text: 'Sign In',
                      onPressed: () {
                        //call API Here
                        /*
                        testing user
                        name: "Kshitij Kulkarni"
                        contact: 9321085764
                        */
                        if(mobile.isNotEmpty) {
                          NetworkUtil.checkConnectionAndProceed(
                              context, () async {
                            DialogManager.showLoadingDialog(context);
                            try {
                              //final response = await APIService.signIn(mobile);
                              DialogManager.dismissLoadingDialog(context);
                              Navigator.push(context, CustomPageRoute(
                                  nextPage: OtpPage(mobileNumber: mobile),
                                  direction: 0),);
                            } catch (e) {
                              DialogManager.dismissLoadingDialog(context);
                              //DialogManager.showInfoDialog(context, 'Error', 'Mobile or password is incorrect\nOr user not registered');
                              DialogManager.showInfoDialog(
                                  context, 'Error', e.toString());
                            }
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              FadeInAnimation(direction: 'up', delay: 1,
                child: Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Image.asset("assets/images/login_page_bg.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String sanitizePhoneNumber(String input) {
    // Remove '+' and following two digits if present
    input = input.replaceAll(RegExp(r'\+\d{2}'), '');
    // Remove all non-numeric characters
    String sanitizedValue = input.replaceAll(RegExp(r'\D'), '');
    // Limit to the last 10 digits
    if (sanitizedValue.length > 10) {
      sanitizedValue = sanitizedValue.substring(sanitizedValue.length - 10);
    }
    return sanitizedValue;
  }

  /*
  bool _isPasswordValid(String password) {
    final RegExp passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])[A-Za-z\d\W_]{8,}$');
    return passwordRegex.hasMatch(password);
  }
  */

}
