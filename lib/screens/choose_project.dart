import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
      DialogManager.showInfoDialog(context, 'Fail', "Please check your internet connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageString = Theme.of(context).brightness == Brightness.light
        ? 'assets/images/logo_blue.png'
        : 'assets/images/logo_white.png';

    return WillPopScope(
      onWillPop: () async {
        if (scaffoldKey.currentState!.isEndDrawerOpen) {
          scaffoldKey.currentState!.openEndDrawer();
          Navigator.pop(context);
          return false;
        } else {
          _exitApp();
          return false;
        }
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 4,
          title: Image.asset(
            imageString,
            fit: BoxFit.fitWidth,
            width: MediaQuery.of(context).size.width * 0.2,
            height: MediaQuery.of(context).size.height * 0.2,
          ),
          leading: IconButton(
            onPressed: () {
              if (scaffoldKey.currentState!.isEndDrawerOpen) {
                scaffoldKey.currentState!.openEndDrawer();
              } else {
                _exitApp();
              }
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.menu_outlined),
              onPressed: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: const Drawer(child: NavBar(),),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height*0.5,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/choose_project_bg.png'),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
            RefreshIndicator(strokeWidth: 2, color: Colors.blue, onRefresh: fetchProjects,
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                minChildSize: 0.6,
                maxChildSize: 1.0,
                expand: true,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding: EdgeInsets.only(left: 10, top: 5, bottom: 8),
                            child: MyHeadingText(
                              text: "Project List",
                              color: Colors.black,
                            )),
                        isLoading
                            ? const Center(child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.blue),
                                  strokeWidth: 2,
                                ),
                            )
                            : Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: projects.length,
                                  itemBuilder: (context, index) {
                                    return Center(
                                        child: ProjectCardWidget(
                                            project: projects[index]));
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
}
