import 'package:flutter/material.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/screens/wings.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/custom_appbar.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class ProjectInfo extends StatefulWidget {
  final Project project;
  const ProjectInfo({super.key, required this.project});

  @override
  ProjectInfoState createState() => ProjectInfoState();
}

class ProjectInfoState extends State<ProjectInfo> {

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final Project project;

  @override
  void initState() {
    super.initState();
    project = widget.project;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey,
      endDrawer: const Drawer(child: NavBar(),),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 4,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)
                ),
                shadowColor: Colors.lightBlue,
                child: Container(width: MediaQuery.sizeOf(context).width, height: MediaQuery.sizeOf(context).height*0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/project_details_bg.png'),
                      fit: BoxFit.fitWidth,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                )
              ),
              Padding(padding: const EdgeInsets.all(20.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInAnimation(delay: 1, direction: "down",
                        child: MyHeadingText(text: project.name, color: Colors.black,)),
                    FadeInAnimation(delay: 1.6, direction: "down",
                      child: Column(children: [
                        Row(children: [
                          SizedBox(width: MediaQuery.sizeOf(context).width*0.05,
                              height: MediaQuery.sizeOf(context).width*0.05,
                              child: Image.asset("assets/images/building.png")
                          ),
                          const SizedBox(width: 10,),
                          MySimpleText(text: project.type, size: 14),
                        ],),
                        Row(children: [
                          SizedBox(width: MediaQuery.sizeOf(context).width*0.05,
                              height: MediaQuery.sizeOf(context).width*0.05,
                              child: Image.asset("assets/images/location.png")),
                          const SizedBox(width: 10,),
                          MySimpleText(text: "${project.city}, ${project.state}", size: 14),
                        ],),
                      ],),
                    ),
                    const SizedBox(height: 20,),
                    FadeInAnimation(delay: 2.4, direction: "down",
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.only(left: 30,),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min,
                            children: [
                              const MySimpleText(text: "Total wings' flats", size: 18, color: Colors.black, bold: true,),
                              const SizedBox(width: 10,),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: MySimpleText(text:
                                  (project.availableFlats+project.blockedFlats+project.bookedFlats+project.heldFlats).toString(),
                                  color: Colors.white, bold: true, size: 18,),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, mainAxisSize: MainAxisSize.max,
                      children: [
                        FadeInAnimation(delay: 2.6, direction: "right",
                            child: customStateWidget("AVAILABLE", MyColor.gridYellow, project.availableFlats, "assets/images/ic_available.png")),
                        FadeInAnimation(delay: 2.6, direction: "left",
                            child: customStateWidget("BOOKED", MyColor.gridGreen, project.bookedFlats, "assets/images/ic_booked.png")),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, mainAxisSize: MainAxisSize.max,
                      children: [
                        FadeInAnimation(delay: 2.6, direction: "right",
                            child: customStateWidget("ON HOLD", MyColor.gridBlue, project.heldFlats, "assets/images/ic_hold.png")),
                        FadeInAnimation(delay: 2.6, direction: "left",
                            child: customStateWidget("BLOCKED", MyColor.gridRed, project.blockedFlats, "assets/images/ic_blocked.png")),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    FadeInAnimation(delay: 2.6, direction: "up",
                      child: Center(
                        child: MyButton(text: "SELECT WING", onPressed: (){
                          Navigator.push(context, CustomPageRoute(nextPage: WingScreen(project: project,), direction: 0),);
                        }),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget columnName(String name){
    return Text(name, style: const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.normal, fontSize: 14),);
  }

  Widget columnValue(String value){
    return Text(
      value,
      style: const TextStyle(
        fontFamily: 'OpenSans',
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      softWrap: true,
    );
  }

  Widget customStateWidget(String title, Color color, int count, String icon_address){
    return Padding(padding: const EdgeInsets.all(5.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisSize: MainAxisSize.max,
          children: [
        MySimpleText(text: title, size: 16, color: Colors.black, bold: true,),
        const SizedBox(height: 10,),
        Stack(
          children: [
            Material(
              shape: const CircleBorder(),
              elevation: 4,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(child: MyHeadingText(text: count.toString(), color: Colors.black)),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Material(
                shape: const CircleBorder(),
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  width: 40, // Adjust the size as needed
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                    color: color,
                  ),
                  child: Image.asset(icon_address),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}