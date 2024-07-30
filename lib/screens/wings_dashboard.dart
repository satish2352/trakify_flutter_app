import 'package:flutter/material.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/flatItem_class.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/screens/flat_details.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/custom_appbar.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/grid_item.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class WingsDashboardPage extends StatefulWidget {
  final Project project;
  final String selectedWingId, wingName;

  const WingsDashboardPage({
    super.key,
    required this.project,
    required this.selectedWingId,
    required this.wingName,
  });

  @override
  WingsDashboardPageState createState() => WingsDashboardPageState();
}

class WingsDashboardPageState extends State<WingsDashboardPage> with RouteAware {

  late List<FlatItem> flatItems = [], filteredFlats = [];
  TextEditingController searchController = TextEditingController();
  String dropdownValue = 'All';
  String searchText = '';
  final List<String> flatStatus = ['All', 'available', 'booked', 'hold', 'blocked'];
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    NetworkUtil.checkConnectionAndProceed(context, ()
    {
      _initializeData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the user returned to this route.
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchFlats();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchFlats() async {
    FetchResult result = await APIService.fetchFloors(widget.selectedWingId);
    if(!mounted) return;
    if (result.success) {
      setState(() {
        flatItems = result.data as List<FlatItem>;
        filteredFlats = flatItems;
      });
    } else {
      DialogManager.showInfoDialog(context, 'Fail', result.error.toString());
    }
  }

  void filterFlats(String searchTerm, String status) {
    setState(() {
      filteredFlats = flatItems.where((flat) {
        final flatStatusMatches = status == 'All' || flat.flatStatus.toLowerCase() == status.toLowerCase();
        final flatNumberMatches = flat.flatNumber.contains(searchTerm);
        return flatStatusMatches && flatNumberMatches;
      }).toList();
    });
  }

  Row legendRow(String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(margin: const EdgeInsets.all(5), height: 10, width: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10,),
        MySubHeadingText(text: text),
        const SizedBox(height: 25,),
      ],
    );
  }

  Padding legendColumn(String text, Color color){
    return Padding(padding: const EdgeInsets.all(4.0),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(elevation: 4, shape: const CircleBorder(),
            child: Container(width: 20, height: 20,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: color
              ),
            ),
          ),
          const SizedBox(height: 5,),
          MySimpleText(text: text, size: 10, color: Colors.black,),
        ],
      ),
    );
  }

  String getUserReadableFloorLabel(int originalFloor) {
    try {
      int floorNumber = originalFloor;
      if (floorNumber > 0) {
        return 'Floor $floorNumber';
      } else if (floorNumber < 0) {
        return 'UG${floorNumber.abs()}';
      } else {
        return 'Ground Floor';
      }
    } on Exception {
      return originalFloor.toString();
    }
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
                  image: AssetImage('assets/images/wings_dashboard_bg.jpg'),
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
              onRefresh: _fetchFlats,
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 1.0,
                expand: true,
                builder: (BuildContext context, ScrollController scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyHeadingText(text: "${widget.project.name}\n${widget.wingName}", color: Colors.black),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                                height: MediaQuery.of(context).size.width * 0.05,
                                child: Image.asset("assets/images/building.png"),
                              ),
                              const SizedBox(width: 10),
                              MySimpleText(text: widget.project.type, size: 14),
                            ],
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.05,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.05,
                                child: Image.asset("assets/images/location.png"),
                              ),
                              const SizedBox(width: 10),
                              MySimpleText(text: "${widget.project.city}, ${widget
                                  .project.state}", size: 14),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Center(child: MySubHeadingText(text: "SELECT FLAT", color: Colors.black)),
                          const SizedBox(height: 20),
                          //add component here
                          _isLoading ? const Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                strokeWidth: 2,
                              ),
                            ],
                          ) : filteredFlats.isEmpty ? const MySimpleText(text: 'No flats available', size: 18,) : Column(
                            children: [
                              for (final floorNumber in filteredFlats.map((flat) => flat.floorNumber).toSet().toList())
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: AppearAnimation(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
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
                                                  getUserReadableFloorLabel(floorNumber).toUpperCase(),
                                                  style: const TextStyle(
                                                    fontFamily: 'OpenSans',
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, crossAxisSpacing: 3.0, mainAxisSpacing: 3.0,
                                      ),
                                      itemCount: filteredFlats.where((flat) => flat.floorNumber == floorNumber).toList().length,
                                      itemBuilder: (context, flatIndex) {
                                        final flat = filteredFlats.where((flat) => flat.floorNumber == floorNumber).toList()[flatIndex];
                                        return GridItem(
                                          flat: flat,
                                          onTap: () {
                                            NetworkUtil.checkConnectionAndProceed(context, () {
                                              Navigator.push(context, CustomPageRoute(nextPage: FlatDetails(flatId: flat.id, floorId: flat.floorId, project: widget.project, wingName: widget.wingName, floorNumber: getUserReadableFloorLabel(flat.floorNumber),), direction: 1));
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 50,),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(bottom: -5,
              child:Container(color: Colors.white, width: MediaQuery.sizeOf(context).width,
                child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    legendColumn("AVAILABLE", MyColor.gridYellow),
                    legendColumn("BOOKED", MyColor.gridGreen),
                    legendColumn("ON HOLD", MyColor.gridBlue),
                    legendColumn("BLOCKED", MyColor.gridRed),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}