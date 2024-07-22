import 'dart:async';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/loading_indicator.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/project_card.dart';
import 'package:trakify/ui_components/text.dart';

class ChooseProjectPage extends StatefulWidget {
  final String userID;

  const ChooseProjectPage({super.key, required this.userID});

  @override
  ChooseProjectPageState createState() => ChooseProjectPageState();
}

class ChooseProjectPageState extends State<ChooseProjectPage> with RouteAware {
  late List<Project> projects = [];
  String searchText = '';
  bool manuallyTapped = false;
  bool isExitPressed = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    NetworkUtil.checkConnectionAndProceed(context, () {
      initializeData();
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
    initializeData();
  }

  Future<void> initializeData() async {
    setState(() {
      isLoading = true;
    });
    await fetchProjects();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchProjects() async {
    FetchResult result = await APIService.fetchProjects(widget.userID);
    if (!mounted) return;
    //DialogManager.showInfoDialog(context, "Info", widget.userID);
    //DialogManager.showInfoDialog(context, "Info", result.success.toString());
    if (result.success) {
      setState(() {
        projects = result.data as List<Project>;
      });
      //DialogManager.showInfoDialog(context, 'Pass', projects.toString());
    } else {
      //API fetch Error
      DialogManager.showInfoDialog(
          context, 'Fail', "Please check your internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    String imageString = Theme.of(context).brightness == Brightness.light
        ? 'assets/images/logo_blue.png'
        : 'assets/images/logo_white.png';

    Color bgColor = Theme.of(context).brightness == Brightness.light
        ? Colors.white
        : Colors.black;

    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isDrawerOpen) {
          scaffoldKey.currentState!.openEndDrawer();
          return false;
        } else {
          _exitApp();
          return false;
        }
      },
      child: Scaffold(
        key: scaffoldKey, //backgroundColor: bgColor,
        appBar: AppBar(
          elevation: 4,
          //backgroundColor: bgColor,
          title: Image.asset(
            imageString,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          leading: IconButton(
              onPressed: () {
                if (scaffoldKey.currentState!.isDrawerOpen) {
                  scaffoldKey.currentState!.openEndDrawer();
                } else {
                  _exitApp();
                }
              },
              icon: const Icon(Icons.arrow_back_ios)),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                _showBottomDrawer(context);
              },
            ),
          ],
        ),
        //drawer: const NavBar(),
        body: isLoading ? LoadingIndicator.build()
            : RefreshIndicator(strokeWidth: 2, color: Colors.blue, onRefresh: fetchProjects,
                child: Container(padding: const EdgeInsets.all(10),
                  child: ListView.builder(shrinkWrap: true,
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        return ProjectCardWidget(project: projects[index],);
                      }),
                ),
              ),
      ),
    );
  }

  Future<void> _exitApp() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (isExitPressed) {
      exit(0);
    } else {
      isExitPressed = true;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Press back again to exit"),
      ));
      Timer(const Duration(seconds: 2), () {
        isExitPressed = false;
      });
    }
  }

  void _showBottomDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const NavBar();
      },
    );
  }
}
