import 'package:flutter/material.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/my_text_field.dart';
import 'package:trakify/ui_components/text.dart';

class ForgotPasswordPage extends StatefulWidget{
  const ForgotPasswordPage({super.key});
  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {

  String email = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(padding:const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                const FadeInAnimation(delay: 0.2, direction: 'down',
                  child: MyHeadingText(text: "Forgot Password?")),
                const SizedBox(height: 2),
                const FadeInAnimation(delay: 0.4, direction: 'down',
                  child: MySubHeadingText(text: "Please enter your email below.\nA password reset link will be shared to your account.")),
                const SizedBox(height: 60),
                FadeInAnimation(
                  direction: 'down',
                  delay: 0.6,
                  child: MyTextField(
                    ic: const Icon(Icons.account_circle_outlined),
                    hintText: 'Email',
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      String sanitizedValue = value.replaceAll(RegExp(r'\D+'), '');
                      if (sanitizedValue.length != 10) {
                        return 'Please enter a 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 60),
                FadeInAnimation(
                  direction: 'down',
                  delay: 0.8,
                  child: Row(
                    children:[
                      Expanded(
                        child: MyButton(
                          text: 'Confirm',
                          onPressed: () {if (_formKey.currentState!.validate()) {}},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FadeInAnimation(delay: 1, direction: 'right',child: MyIconButton(onPressed: (){Navigator.of(context).pop();}, icon: Icons.arrow_back_outlined,),),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}