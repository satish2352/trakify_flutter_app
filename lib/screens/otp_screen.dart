import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/screens/choose_project.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/app_bar_logo.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/text.dart';

class OtpPage extends StatefulWidget{

  final String mobileNumber;
  final bool staySignedIn;

  const OtpPage({super.key, required this.mobileNumber, required this.staySignedIn});

  @override
  OtpPageState createState() => OtpPageState();
}

class OtpPageState extends State<OtpPage> {

  late String mobileNumber;
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String getOtp() {
    return _controllers.map((controller) => controller.text).join();
  }

  @override
  void initState() {
    super.initState();
    mobileNumber = widget.mobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(padding: const EdgeInsets.all(10.0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children:[
                appBarLogo(context),
                const SizedBox(height: 20,),
                const FadeInAnimation(direction: 'down', delay: 0.6,
                  child: MyHeadingText(text: "OTP"),
                ),
                const SizedBox(height: 5,),
                FadeInAnimation(direction: 'down', delay: 0.6,
                  child: MySimpleText(text: "A 4 digit code has been sent to\n$mobileNumber", size: 18, color: Colors.black, center: true),
                ),
                const SizedBox(height: 40.0),
                //otp container
                FadeInAnimation(direction: 'down', delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                      return Padding(padding: const EdgeInsets.all(8.0),
                        child: Container(width: 40, height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(1, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Center(
                            child: TextField(
                              controller: _controllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: _focusNodes[index].hasFocus ? Colors.blue : Colors.white,
                                counterText: '',
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 18.0,
                                height: 1.0,
                                color: _focusNodes[index].hasFocus ? Colors.white : Colors.black,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                              onTap: () {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                //////////////////////////////////////////////////
                const SizedBox(height: 20,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MySimpleText(text: "Didn't receive the code?", size: 18, color: Colors.black,),
                    const SizedBox(width: 10,),
                    GestureDetector(
                      onTap: (){
                        //resend otp
                        String otp = getOtp();
                      },
                      child: const MySimpleText(text: "Resend", size: 15, bold: true, color: Colors.blue,),
                    ),
                  ],
                ),
                const SizedBox(height: 5,),
                FadeInAnimation(delay: 1, direction: 'down',
                  child: MyButton(text: "Verify", onPressed: (){
                    NetworkUtil.checkConnectionAndProceed(context, () async {
                      DialogManager.showLoadingDialog(context);
                      try {
                        final response = await APIService.signIn(mobileNumber);
                        DialogManager.dismissLoadingDialog(context);
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('userID', response['id']);
                        prefs.setString('userName', response['name']);
                        if(widget.staySignedIn){
                          prefs.setBool('isSignedIn', true);
                        }
                        Navigator.push(context, CustomPageRoute(nextPage: ChooseProjectPage(userID: response['id'],), direction: 0),);
                      } catch (e) {
                        DialogManager.dismissLoadingDialog(context);
                        //DialogManager.showInfoDialog(context, 'Error', 'Mobile or password is incorrect\nOr user not registered');
                        DialogManager.showInfoDialog(context, 'Error', e.toString());
                      }
                    });
                  }),
                ),
                const SizedBox(height: 30,),
                FadeInAnimation(direction: 'up', delay: 1,
                  child: Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Image.asset("assets/images/otp_img.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }

}