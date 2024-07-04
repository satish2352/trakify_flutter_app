import 'package:flutter/material.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/wing_class.dart';
import 'package:trakify/screens/wings_dashboard.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/loading_indicator.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';


class WingScreen extends StatefulWidget {
  final String selectedProjectId;

  const WingScreen({super.key, required this.selectedProjectId});

  @override
  State<WingScreen> createState() => _WingScreenState();
}

class _WingScreenState extends State<WingScreen> with RouteAware{
  List<Wing> wings = [];
  bool _isLoading = false; // Add this variable

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
    // Called when the current route has been popped off, and the user returned to this route.
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
    FetchResult result = await APIService.fetchWings(widget.selectedProjectId);
    if(!mounted) return;
    if (result.success) {
      setState(() {
        wings = result.data as List<Wing>;
      });
    } else {
      DialogManager.showInfoDialog(context, 'Failed to load data', 'Please check your internet connection');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        title: const Text(
          'Wings',
          style: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_outlined)),
        actions: [IconButton(icon: const Icon(Icons.menu_outlined), onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return const NavBar();
            },
          );},),],
      ),
      body: _isLoading ? LoadingIndicator.build() : RefreshIndicator(strokeWidth: 2, color: Colors.blue, onRefresh: _refreshPage,
        child: SizedBox(width: double.infinity, height: double.infinity,
          child: SingleChildScrollView(physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(padding: const EdgeInsets.all(15.0),
              child: wings.isEmpty ? const Center(child: MySimpleText(text: "No wings are available", size: 25,),)
                  : GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 30,
                      mainAxisSpacing: 30,
                      children: List.generate(wings.length,
                        (index) => index%2==0?
                        FadeInAnimation(delay: 0.4, direction: 'right', child: _buildButton(context, wings[index])):
                        FadeInAnimation(delay: 0.4, direction: 'left', child: _buildButton(context, wings[index])),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context, Wing wing) {
    return SingleChildScrollView(
      child: Material(elevation: 4, borderRadius: BorderRadius.circular(20.0), shadowColor: Colors.lightBlue,
        child: GestureDetector(
          onTap: () {
            Navigator.push(context,
              CustomPageRoute(
                nextPage: WingsDashboardPage(wingName: wing.name, selectedProjectId: widget.selectedProjectId, selectedWingId: wing.id,),
                direction: 0,
              ),
            );
          },
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Container(alignment: Alignment.center,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20),),
                  color: Colors.blue,
                ),
                child: Column(
                  children: [
                    Text(wing.name, style: const TextStyle(fontFamily: 'OpenSans', fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold,),),
                    const SizedBox(height: 2),
                    MySimpleText(text: 'Number of Floors ${wing.floor.toString()}', size: 12,
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                    const SizedBox(height: 2),
                  ],
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20),),
                ),
                child: Padding(padding: const EdgeInsets.all(8),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildContainer(MyColor.gridYellow, wing.availableFlats.toString()),
                          buildContainer(MyColor.gridGreen, wing.bookedFlats.toString()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          buildContainer(MyColor.gridBlue, wing.holdFlats.toString()),
                          buildContainer(MyColor.gridRed, wing.blockedFlats.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refreshPage() async {
    try {
      await _fetchWings();
      if(!mounted) return;
    } catch (e) {
      DialogManager.showErrorDialog(context, "Could Not Fetch", "Cannot fetch data from the servers, please check your connection");
    }
  }

  buildContainer(Color bgColor, String wingCount) {
    return Container(padding: const EdgeInsets.all(5), width: 40,
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Center(child: MySimpleText(text: wingCount, color: bgColor == MyColor.gridYellow ? MyColor.black : Colors.white, size: 16,)),
    );
  }
}
