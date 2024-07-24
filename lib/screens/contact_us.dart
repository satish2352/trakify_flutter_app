import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/custom_appbar.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/my_text_field.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  ContactUsState createState() => ContactUsState();
}

class ContactUsState extends State<ContactUs> {

  String userId = "";
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(), _emailController = TextEditingController(), _numberController = TextEditingController();
  late String _selectedBhkValue="", _selectedBudget="";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    if (userID != null && userID.isNotEmpty) {
      setState(() {
        userId = userID;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const Drawer(child: NavBar(),),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/contact_us_bg.png'),
                fit: BoxFit.fitWidth,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.6,
            maxChildSize: 1.0,
            expand: true,
            builder: (BuildContext context,
                ScrollController scrollController) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Column(
                        children: [
                          AppearAnimation(
                            child: Column(
                              children: [
                                const MyHeadingText(text: "CONTACT US", color: Colors.black,),
                                const SizedBox(height: 20,),
                                MyIconTextField(hintText: "Name", ic: const Icon(Icons.person), controller: _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10,),
                                MyIconTextField(hintText: "Mobile Number", ic: const Icon(Icons.call), controller: _numberController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty || value.length<10) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 10,),
                                MyIconTextField(hintText: "Email Id", ic: const Icon(Icons.mail), controller: _emailController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20,),
                              ],
                            ),
                          ),
                AppearAnimation(
                  child: Column(
                    children: [
                          const MySimpleText(text: "Budget", size: 18, bold: true, color: Colors.black,),
                          const SizedBox(height: 10,),
                          choiceChipRow(),
                          const SizedBox(height: 20,),
                          ],),),
                AppearAnimation(
                  child: Column(
                    children: [
                          const MySimpleText(text: "Number of bedrooms", size: 18, bold: true, color: Colors.black,),
                          const SizedBox(height: 10,),
                          radioButtonForFlatStatus(),
                          const SizedBox(height: 20,),
                          ],),),
                          AppearAnimation(
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                MyButton(text: "SUBMIT", onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    if (_selectedBudget.isEmpty ||
                                        _selectedBhkValue.isEmpty) {
                                      DialogManager.showErrorDialog(
                                          context, "Info Incomplete",
                                          "Please select Budget and BHK");
                                    } else {
                                      addDataInInquiryApi(
                                        _nameController.text,
                                        _numberController.text,
                                        _emailController.text,
                                        _selectedBudget,
                                        _selectedBhkValue,
                                      );
                                    }
                                  }
                                }),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  radioButtonForFlatStatus() {
    List<String> values = ['1 BHK', '2 BHK', '3 BHK', '4 BHK'];
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((status) {
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Radio<String>(
                value: status,
                groupValue: _selectedBhkValue,
                onChanged: (String? value) {
                  setState(() {
                    _selectedBhkValue = value!;
                  });
                },
              ),
              MySimpleText(text: status, size: 14, color: Colors.black, bold: true,),
            ],
          ),
        );
      }).toList(),
    );
  }

  choiceChipRow() {
    List<String> values = ['Low', 'Medium', 'High'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: values.map((status) {
        bool isSelected = _selectedBudget == status;
        Color bgColor = isSelected ? MyColor.bluePrimary : Colors.white;
        Color textColor = isSelected ? Colors.white : Colors.black;

        return ChoiceChip(
          label: MySimpleText(
            text: status,
            size: 14,
            color: textColor,
            bold: true,
          ),
          selected: isSelected,
          onSelected: (isSelected) {
            setState(() {
              _selectedBudget = (isSelected ? status : null)!;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          selectedColor: bgColor,
        );
      }).toList(),
    );
  }

  void addDataInInquiryApi(String name, String number, String email, String budget, String bhk) {
    DialogManager.showInfoDialog(context, "Test", "$name $number $email $budget $bhk");
  }
}