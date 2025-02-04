import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/flat_class.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/screens/flat_history.dart';
import 'package:trakify/screens/update_flat.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/custom_appbar.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class FlatDetails extends StatefulWidget {
  final String flatId, floorId, wingName;
  final String floorNumber;
  final Project project;

  const FlatDetails({super.key, required this.flatId, required this.floorId, required this.project, required this.wingName, required this.floorNumber});

  @override
  FlatDetailsState createState() => FlatDetailsState();
}

class FlatDetailsState extends State<FlatDetails> with RouteAware {

  String userId = '';
  late Flat flat;
  List<String>? flatStates;
  String newState = '';
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    newState = '';
    NetworkUtil.checkConnectionAndProceed(context, () {
      _initializeData();
    });
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the user returned to this route.
    _initializeData();
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
    /*
    DialogManager.showInfoDialog(context, 'Info', '${widget.floorId}\n'
        '${widget.flatId}\n'
        '${result.error.toString()}\n'
        '${result.success.toString()}\n');
    */
    if (result.success) {
      setState(() {
        flat = result.data[0];
        //DialogManager.showInfoDialog(context, 'Info', f);
        flatStates = ['available', 'booked', 'blocked', 'hold'];
        newState = flat.flatStatus;
      });
    } else {
      DialogManager.showInfoDialog(context, 'Failed to load data', "Please check your internet connection");
    }
  }

  outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey, endDrawer: const Drawer(child: NavBar(),),
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
            RefreshIndicator(
              strokeWidth: 2,
              color: Colors.blue,
              onRefresh: _fetchFlat,
              child: DraggableScrollableSheet(
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
                    child: _isLoading ? const Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          strokeWidth: 2,
                        ),
                      ],
                    ) : ListView(
                      controller: scrollController,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            imageContainer("assets/images/project_details_bg.png"),
                            imageContainer("assets/images/wings_bg.png"),
                            imageContainer("assets/images/wings_dashboard_bg.png"),
                            imageContainer("assets/images/flat_details_bg.png"),
                        ],),
                        const SizedBox(height: 10),
                        FadeInAnimation(delay: 0.6, direction: "down", child: MyHeadingText(text: widget.project.name, color: Colors.black)),
                        //const SizedBox(height: 5),
                        FadeInAnimation(delay: 0.6, direction: "down",
                          child: Container(padding: const EdgeInsets.symmetric(vertical: 5),
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
                                "Wing ${widget.wingName} | ${widget.floorNumber} | Flat No. ${flat.flatNumber}",
                                style: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        FadeInAnimation(delay: 0.6, direction: "down",
                          child: Row(
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
                        ),
                        const SizedBox(height: 10),
                        FadeInAnimation(delay: 1.2, direction: "down",
                          child: Row(
                            children: [
                              const Icon(Icons.currency_rupee, size: 20,),
                              MyHeadingText(text: formatPrice(flat.price), color: Colors.black),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeInAnimation(delay: 1.2, direction: "down",
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const MySimpleText(text: "Description", size: 16, color: Colors.black, bold: true,),
                              MySimpleText(text: "A ${flat.bhk} flat,\nspread across ${flat.area} square foot." , size: 16, color: Colors.black,),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.min,
                          children: [
                            FadeInAnimation(delay: 1.8, direction: "right",
                              child: MyButton(text: flat.flatStatus, onPressed: (){
                                Navigator.push(context, CustomPageRoute(nextPage: UpdateFlat(flat: flat, project: widget.project, wingName: widget.wingName, floorNumber: widget.floorNumber, floorId: widget.floorId,), direction: 0),);
                              }),
                            ),
                            FadeInAnimation(delay: 1.8, direction: "left",
                              child: MyCardIconButton(onPressed: (){
                                Navigator.push(context, CustomPageRoute(nextPage: FlatHistory(flatId: flat.id, flatNumber: flat.flatNumber,), direction: 0),);
                              }, icon: Icons.history),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  imageContainer(String s) {
    return FadeInAnimation(delay: 0.6, direction: "right",
      child: Padding(padding: const EdgeInsets.all(2),
        child: Container(width: 40, height: 40,
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage(s)),
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }

}

String formattedDate(String dateString) {
  DateTime dateTime = DateTime.parse(dateString);
  String formattedDateString = DateFormat('dd-MMM\nhh:mma').format(dateTime);
  return formattedDateString;
}

String formatPrice(int price) {
  final formatter = NumberFormat.simpleCurrency(name: 'INR', locale: 'en_IN');
  String formattedPrice = formatter.format(price);
  // Remove the default currency symbol and add the rupee symbol
  return formattedPrice.replaceFirst('₹', '').trim();
}