import 'package:flutter/material.dart';
import 'package:trakify/data/project_class.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/details_item.dart';
import 'package:trakify/ui_components/navbar.dart';

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
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Project Details",
          style: TextStyle(
              fontFamily: 'OpenSans', fontSize: 25, color: Colors.white),
        ),
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
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12.0),
                  shadowColor: Colors.lightBlue,
                  child: FadeInAnimation(
                    direction: 'down',
                    delay: 0.4,
                    /*
                    child: Row(
                      children:[
                        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                          columnName("Name"),
                          columnName("Description"),
                          columnName("Address"),
                          columnName("City"),
                          columnName("State"),
                        ]),
                        const SizedBox(width: 20),
                        Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start,
                            children:[
                          columnValue(project.name),
                          columnValue(project.description),
                          columnValue(project.area),
                          columnValue(project.city),
                          columnValue(project.state),
                        ]),
                      ],
                    ),
                    */
                    child: Column(children: [
                      const SizedBox(height: 10),
                      MyDetailsItem(itemName: 'Name', value: project.name),
                      MyDetailsItem(itemName: 'Description', value: project.description),
                      MyDetailsItem(itemName: 'Address', value: project.area),
                      MyDetailsItem(itemName: 'City', value: project.city),
                      MyDetailsItem(itemName: 'State', value: project.state),
                      //MyDetailsItem(itemName: 'Pin', value: project.pin),
                    ]),
                  ),
                ),
                // Dropdown for Flat State
                const SizedBox(height: 10),
              ],
            ),
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
}
