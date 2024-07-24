import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/screens/wings.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/details_item.dart';
import 'package:trakify/ui_components/my_text_field.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';

class ProjectInfo extends StatefulWidget {
  final Project project;
  const ProjectInfo({super.key, required this.project});

  @override
  ProjectInfoState createState() => ProjectInfoState();
}

class ProjectInfoState extends State<ProjectInfo> {
  late final Project project;

  @override
  void initState() {
    super.initState();
    project = widget.project;
  }

  @override
  Widget build(BuildContext context) {
    String imageString = Theme.of(context).brightness == Brightness.light
        ? 'assets/images/logo_blue.png'
        : 'assets/images/logo_white.png';
    return Scaffold(
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
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: () {
              showBottomDrawer(context);
            },
          ),
        ],
      ),
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
                    MyHeadingText(text: project.name, color: Colors.black,),
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
                    const SizedBox(height: 20,),
                    Center(
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
                    const SizedBox(height: 20,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customStateWidget("AVAILABLE", MyColor.gridYellow, project.availableFlats, "assets/images/ic_available.png"),
                        customStateWidget("BOOKED", MyColor.gridGreen, project.bookedFlats, "assets/images/ic_booked.png"),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customStateWidget("ON HOLD", MyColor.gridBlue, project.heldFlats, "assets/images/ic_hold.png"),
                        customStateWidget("BLOCKED", MyColor.gridRed, project.blockedFlats, "assets/images/ic_blocked.png"),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Center(
                      child: MyButton(text: "SELECT WING", onPressed: (){
                        Navigator.push(context, CustomPageRoute(nextPage: WingScreen(project: project,), direction: 0),);
                      }),
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