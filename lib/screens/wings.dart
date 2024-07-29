import 'package:flutter/material.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/data/wing_class.dart';
import 'package:trakify/screens/wings_dashboard.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/custom_appbar.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class WingScreen extends StatefulWidget {
  final Project project;

  const WingScreen({super.key, required this.project});

  @override
  State<WingScreen> createState() => _WingScreenState();
}

class _WingScreenState extends State<WingScreen> with RouteAware {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Wing> wings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    NetworkUtil.checkConnectionAndProceed(context, () {
      _initializeData();
    });
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
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
  void didPopNext() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchWings();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchWings() async {
    FetchResult result = await APIService.fetchWings(widget.project.id);
    if (!mounted) return;
    if (result.success) {
      setState(() {
        wings = result.data as List<Wing>;
      });
    } else {
      DialogManager.showInfoDialog(context, 'Failed to load data', 'Please check your internet connection');
    }
  }

  Future<void> _refreshPage() async {
    try {
      await _fetchWings();
      if (!mounted) return;
    } catch (e) {
      DialogManager.showErrorDialog(context, "Could Not Fetch", "Cannot fetch data from the servers, please check your connection");
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
                  image: AssetImage('assets/images/wings_bg.png'),
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
              onRefresh: _fetchWings,
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 1.0,
                expand: true,
                builder: (BuildContext context, ScrollController scrollController) {
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
                        FadeInAnimation(delay: 0.6, direction: "down",
                            child: MyHeadingText(text: widget.project.name, color: Colors.black)),
                        FadeInAnimation(delay: 1, direction: "down",
                          child: Column(children:[
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
                                  width: MediaQuery.of(context).size.width * 0.05,
                                  height: MediaQuery.of(context).size.width * 0.05,
                                  child: Image.asset("assets/images/location.png"),
                                ),
                                const SizedBox(width: 10),
                                MySimpleText(text: "${widget.project.city}, ${widget.project.state}", size: 14),
                              ],
                            ),
                          ]),
                        ),
                        const SizedBox(height: 20),
                        const FadeInAnimation(delay: 1.4, direction: "down", child: Center(child: MySubHeadingText(text: "SELECT WING", color: Colors.black))),
                        const SizedBox(height: 20),
                        SizedBox(height: MediaQuery.sizeOf(context).height*0.6,
                          child: GridView.builder(
                            controller: scrollController,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 3,
                            ),
                            itemCount: wings.length,
                            itemBuilder: (context, index) {
                              String direction = (index%2==0) ? "right" : "left";
                              return FadeInAnimation(delay: 1.4, direction: direction, child: _wingItem(wings[index]));
                            },
                          ),
                        ),
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

  Widget _wingItem(Wing wing) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,
          CustomPageRoute(
            nextPage: WingsDashboardPage(wingName: wing.name, project: widget.project, selectedWingId: wing.id,),
            direction: 0,
          ),
        );
      },
      child: SizedBox(width: MediaQuery.sizeOf(context).width*0.5 - 10,
        child: Stack(
          children:[
            Positioned(top: 55,
              child: Container(padding: const EdgeInsets.only(top: 40), width: MediaQuery.sizeOf(context).width*0.5-20,
              decoration: BoxDecoration(border: Border.all(color: Colors.black),),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  columnData(MyColor.gridGreen, wing.bookedFlats),
                  columnData(MyColor.gridBlue, wing.holdFlats),
                  columnData(MyColor.gridYellow, wing.availableFlats),
                  columnData(MyColor.gridRed, wing.blockedFlats),
                ],),
              ),
            ),
            Column(
              children: [
              MySimpleText(
                text: wing.name,
                color: Colors.black,
                size: 14,
                bold: true,
              ),
              const SizedBox(height: 10,),
              Center(
                child: Container(width: 60, height: 60,
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: MyColor.bluePrimary),
                  child: Image.asset("assets/images/wing_ic.png"),
                ),
              ),
              ],
            ),
      ],
        ),
      ),
    );
  }

  Widget columnData(Color color, int count) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          MySimpleText(text: count.toString(), size: 12),
        ],
      ),
    );
  }
}