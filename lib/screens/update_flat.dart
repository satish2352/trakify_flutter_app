import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/flat_class.dart';
import 'package:trakify/screens/flat_history.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/details_item.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/dropdown.dart';
import 'package:trakify/ui_components/loading_indicator.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class UpdateFlat extends StatefulWidget {
  final String flatId, floorId;
  const UpdateFlat({super.key, required this.flatId, required this.floorId});

  @override
  UpdateFlatState createState() => UpdateFlatState();
}

class UpdateFlatState extends State<UpdateFlat> {
  String userId = '';
  Flat? flat;
  final _formKey = GlobalKey<FormState>();
  List<String>? flatStates;
  String newState = '';
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    newState = '';
    NetworkUtil.checkConnectionAndProceed(context, () {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    if (userID != null && userID.isNotEmpty) {
      setState(() {
        userId = userID;
      });
    }
    setState(() {
      _isLoading = true;
    });
    await _fetchFlat();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchFlat() async {
    FetchResult result = await APIService.fetchFlatDetails(widget.floorId, widget.flatId);
    if (!mounted) return;
    //DialogManager.showInfoDialog(context, 'Info', '${widget.floorId}\n${widget.flatId}\n${result.toString()}');
    if (result.success) {
      setState(() {
        flat = result.data[0];
        //DialogManager.showInfoDialog(context, 'Info', f);
        flatStates = ['available', 'booked', 'blocked', 'hold'];
        newState = flat!.flatStatus;
      });
    } else {
      DialogManager.showInfoDialog(context, 'Failed to load data', "Please check your internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text(
          'Flat Details',
          style: TextStyle(fontFamily: 'OpenSans', fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        }, icon: const Icon(Icons.arrow_back_outlined)),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(context, CustomPageRoute(nextPage: FlatHistory(flatId: flat!.id, flatNumber: flat!.flatNumber), direction: 0),);
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const NavBar();
                },
              );
            },
          ),
        ],
      ),
      body: _isLoading ? LoadingIndicator.build() : RefreshIndicator.adaptive(
        strokeWidth: 2,
        color: Colors.blue,
        onRefresh: _initializeData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              // ignore: unnecessary_null_comparison
              child: flat != null ? _buildFlatDetails() : Center(child: LoadingIndicator.build(),),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlatDetails() {
    return Form(
      key: _formKey,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Colors.lightBlue,
              color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black54,
              child: FadeInAnimation(
                direction: 'down',
                delay: 0.4,
                child: Column(children: [
                  MyDetailsItem(itemName: 'Customer Name', value: flat!.customerName),
                  MyDetailsItem(itemName: 'Customer Number', value: flat!.customerNumber.toString()),]),
              ),
            ),
            const SizedBox(height: 10),
            Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12.0),
              shadowColor: Colors.lightBlue,
              color: Theme.of(context).brightness == Brightness.light ? MyColor.darkWhite : MyColor.darkBlack,
              child: FadeInAnimation(
                direction: 'down',
                delay: 0.4,
                child: Column(children: [
                  MyDetailsItem(itemName: 'Flat Number', value: flat!.flatNumber),
                  MyDetailsItem(itemName: 'BHK', value: flat!.bhk.toString()),
                  MyDetailsItem(itemName: 'Area', value: flat!.area.toString()),
                  MyDetailsItem(itemName: 'Price', value: flat!.price.toString()),
                  MyDetailsItem(itemName: 'Current State', value: flat!.flatStatus,),
                  if (flat!.comment != null && flat!.comment!.isNotEmpty) ...[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.black54,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          MyDetailsItem(itemName: 'Comment', value: flat!.comment!,),
                          const SizedBox(height: 10),
                          MyDetailsItem(itemName: 'Last changed by', value: formattedDate(flat!.lastUpdated.toString(),),),
                        ],
                      ),
                    )
                  ],
                ]),
              ),
            ),
            // Dropdown for Flat State
            const SizedBox(height: 20),
            // Text Field for Comments
            FadeInAnimation(
              direction: 'down',
              delay: 1.6,
              child: MyButton(text: 'Change Flat State', onPressed: () {
                _showUpdateDialog();
              }),
            ),
          ],
        ),
      ),
    );
  }

  outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(10),
    );
  }

  String formattedDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDateString = DateFormat('dd-MMM\nhh:mma').format(dateTime);
    return formattedDateString;
  }

  void _showUpdateDialog() {
    showDialog(context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MySimpleText(text: 'Customer Name', size: 12),
                TextFormField(initialValue: flat?.customerName),
                const SizedBox(height: 10),
                const MySimpleText(text: 'Customer Number', size: 12),
                TextFormField(initialValue: flat?.customerNumber.toString()),
                const SizedBox(height: 10),
                FadeInAnimation(direction: 'down', delay: 0.8,
                  child: Padding(padding: const EdgeInsets.all(8.0),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(child: Text('Change State: ', style: TextStyle(fontFamily: 'OpenSans'),),),
                        Expanded(child: MyDropdown(hint: 'State', items: flatStates, value: newState,
                          onChanged: (String newValue) {
                            setState(() {
                              newState = newValue;
                            });
                          },
                        ),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInAnimation(direction: 'down', delay: 1.2,
                  child: TextFormField(controller: _commentController, maxLines: 2,
                    decoration: const InputDecoration(hintText: "Enter comments here...",),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            MyButton(
              text: 'Update',
              onPressed: () {
                if (_commentController.text.isEmpty) {
                  DialogManager.showErrorDialog(context, 'Error', 'Comments cannot be empty.');
                } else {
                  Navigator.of(context).pop();
                  _updateFlatDetails();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _updateFlatDetails() {
    NetworkUtil.checkConnectionAndProceed(context, () {
      if (_formKey.currentState!.validate()) {
        DialogManager.showQuestionDialog(context, 'Confirm Submission?', () async {
          if (_formKey.currentState!.validate()) {
            String formattedDate = DateFormat('dd MMMM yyyy, hh:mm a').format(DateTime.now());
            Map<String, dynamic> updateResult = await APIService.updateFlatDetails(
              widget.floorId,
              flat!.id,
              newState,
              _commentController.text,
              userId,
              formattedDate,
            );
            if (updateResult.containsKey('error')) {
              DialogManager.showErrorDialog(context, 'Error', updateResult['error'],);
            } else {
              _fetchFlat();
              DialogManager.showSuccessDialog(context, 'Hurray!', 'Flat status updated',);
              _commentController.clear();
            }
          }
        });
      }
    });
  }
}