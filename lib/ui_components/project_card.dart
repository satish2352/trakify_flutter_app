import 'package:flutter/material.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/screens/wings.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/text.dart';

class ProjectCardWidget extends StatelessWidget {
  final Project project;

  const ProjectCardWidget({
    super.key,
    required this.project,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 160, width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, CustomPageRoute(nextPage: WingScreen(selectedProjectId: project.id), direction: 1));
        },
        child: Stack(
          children: [
            Positioned(top: 40, left: 40,
              child: Container(padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey, width: 1,),
                ),
                child: Padding(padding: const EdgeInsets.only(left: 60),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                    children: [
                      MySimpleText(text: project.name, size: 20, bold: true, color: Colors.black,),
                      MySimpleText(text: project.type, size: 14,),
                      MySimpleText(text: "${project.city}, ${project.state}", size: 14),
                      Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          columnData(MyColor.gridGreen, project.bookedFlats),
                          columnData(MyColor.gridBlue, project.heldFlats),
                          columnData(MyColor.gridYellow, project.availableFlats),
                          columnData(MyColor.gridRed, project.blockedFlats),
                          const SizedBox(width: 5,),
                          Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                            children: [
                              const MySimpleText(text: "Flats", size: 15, color: Colors.blue, bold: true,),
                              const SizedBox(width: 5,),
                              MySimpleText(text: project.totalFlats.toString(), size: 15,),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(top: 5, left: 5,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/project_image.png"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget columnData(Color color, int count){
    return Padding(padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          Container(height: 15, width: 15,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          MySimpleText(text: count.toString(), size: 12),
        ],
      ),
    );
  }
}