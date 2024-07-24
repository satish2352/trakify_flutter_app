import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/screens/project_info.dart';
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
    return SizedBox(height: 160, width: MediaQuery.sizeOf(context).width * 0.9,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, CustomPageRoute(nextPage: ProjectInfo(project: project), direction: 1));
        },
        child: Stack(
          children: [
            Positioned(top: 40, left: 40,
              child: Material(borderRadius: BorderRadius.circular(20), elevation: 4,
                child: Container(padding: const EdgeInsets.only(right: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey, width: 1,),
                    color: Colors.grey[100],
                  ),
                  child: Padding(padding: const EdgeInsets.only(left: 60),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                      children: [
                        MySimpleText(text: project.name, size: 20, bold: true, color: Colors.black,),
                        MySimpleText(text: project.type, size: 14, color: Colors.black,),
                        MySimpleText(text: "${project.city}, ${project.state}", size: 14,color: Colors.black,),
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
                                MySimpleText(text: project.totalFlats.toString(), size: 15,color: Colors.black,),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(top: 5, left: 5,
              child: Material(shape: const CircleBorder(), elevation: 4, shadowColor: Colors.black,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/project_details_bg.png"),
                      fit: BoxFit.cover,
                    ),
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
          Material(shape: const CircleBorder(), elevation: 4, shadowColor: color,
            child: Container(height: 15, width: 15,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
          ),
          MySimpleText(text: count.toString(), size: 12,color: Colors.black,),
        ],
      ),
    );
  }
}