import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/flat_class.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/custom_appbar.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/my_text_field.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class UpdateFlat extends StatefulWidget {
  final Flat flat;
  final Project project;
  final String wingName, floorNumber, floorId;

  const UpdateFlat({
    super.key, required this.flat, required this.project, required this.wingName, required this.floorNumber, required this.floorId
  }
);

  @override
  UpdateFlatState createState() => UpdateFlatState();
}

class UpdateFlatState extends State<UpdateFlat> {

  String userId = '';

  final Map<String, Color> statusColors = {
    'available': MyColor.gridYellow,
    'booked': MyColor.gridGreen,
    'blocked': MyColor.gridRed,
    'on hold': MyColor.gridBlue,
  };

  late String customerName = widget.flat.customerName, _selectedStatusValue = widget.flat.flatStatus;
  late String? customerComment;
  late int customerContact = widget.flat.customerNumber;

  late TextEditingController customerNameController, customerNumberController, _commentController;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState(){
    super.initState();
    _initializeData();
    customerNameController = TextEditingController(text: customerName);
    _commentController = TextEditingController();
    customerNumberController = TextEditingController(text: customerContact.toString());
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

  void _updateFlatDetails() {
    NetworkUtil.checkConnectionAndProceed(context, () {
      if (_formKey.currentState!.validate()) {
        DialogManager.showQuestionDialog(context, 'Confirm Submission?', () async {
          if (_formKey.currentState!.validate()) {
            DialogManager.showLoadingDialog(context);
            String formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.now());
            Map<String, dynamic> updateResult = await APIService.updateFlatDetails(
              widget.floorId,
              widget.flat.id,
              _selectedStatusValue,
              _commentController.text,
              userId,
              formattedDate,
            );
            if (updateResult.containsKey('error')) {
              DialogManager.dismissLoadingDialog(context);
              DialogManager.showErrorDialog(context, 'Error', updateResult['error'],);
            } else {
              DialogManager.dismissLoadingDialog(context);
              DialogManager.showSuccessDialog(context, 'Hurray!', 'Flat status updated',);
              _commentController.clear();
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const Drawer(child: NavBar(),),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/flat_details_bg.png'),
                  fit: BoxFit.fill,
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
                        const SizedBox(height: 10),
                        MyHeadingText(text: widget.project.name, color: Colors.black),
                        //const SizedBox(height: 5),
                        Container(padding: const EdgeInsets.symmetric(vertical: 5),
                          width: MediaQuery.sizeOf(context).width*0.8,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blue, Colors.white],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Text(
                              "Wing ${widget.wingName} | ${widget.floorNumber} | Flat No. ${widget.flat.flatNumber}",
                              style: const TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                              height: MediaQuery.of(context).size.width * 0.05,
                              child: Image.asset("assets/images/location.png"),
                            ),
                            const SizedBox(width: 10),
                            MySimpleText(text: "${widget.project.city}, ${widget
                                .project.state}", size: 14),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const MyHeadingText(text: "ACTION", color: Colors.black),
                        const SizedBox(height: 10),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, mainAxisSize: MainAxisSize.max,
                          children: [
                            radioButtonForFlatStatus(),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MyIconTextField(hintText: "Customer Name", ic: const Icon(Icons.person),
                          controller: customerNameController,
                          onChanged: (newValue){
                          setState(() {
                            customerName = newValue;
                          });
                          },
                        ),
                        const SizedBox(height: 20),
                        MyIconTextField(hintText: "Customer Contact", ic: const Icon(Icons.call),
                          controller: customerNumberController,
                          keyboardType: TextInputType.number,
                          onChanged: (newValue){
                          setState(() {
                            customerContact = newValue.toString() as int;
                          });
                          },
                        ),
                        const SizedBox(height: 20),
                        MyIconTextField(hintText: "Comment", ic: const Icon(Icons.message),
                          controller: _commentController,
                          onChanged: (newValue){
                            setState(() {
                              customerComment = newValue.toString() ;
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min,
                          children: [
                            MyButton(text: "SUBMIT", onPressed: (){
                              if (customerNumberController.text.isEmpty || customerNameController.text.isEmpty || _commentController.text.isEmpty || _selectedStatusValue==widget.flat.flatStatus) {
                                DialogManager.showErrorDialog(context, 'Error', 'Please fill new state, customer name, number & comment.');
                              } else {
                                //Navigator.of(context).pop();
                                _updateFlatDetails();
                              }
                            }),
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
      ),
    );
  }

  radioButtonForFlatStatus() {
    List<String> statuses = ['available', 'booked', 'blocked', 'on hold'];
    statuses.remove(widget.flat.flatStatus);

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: statuses.map((status) {
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: [
              Radio<String>(
                value: status,
                groupValue: _selectedStatusValue,
                onChanged: (String? value) {
                  setState(() {
                    _selectedStatusValue = value!;
                  });
                },
                activeColor: statusColors[status],
                //overlayColor: new WidgetStateProperty<Color?>,
              ),
              MySimpleText(text: status, size: 16, color: statusColors[status], bold: true,),
            ],
          ),
        );
      }).toList(),
    );
  }


}