import 'package:flutter/material.dart';

class MyListItem extends StatelessWidget{
  final String project;
  final Icon icon;
  final VoidCallback onPressed;
  const MyListItem({super.key, required this.project, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(10.0),
            shadowColor: Colors.lightBlue,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    //const SizedBox(width: 8),
                    Text(project,
                      style: const TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.black,
                        fontSize: 19,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.keyboard_double_arrow_right),
                      color: Colors.blue,
                      onPressed: onPressed,
                    ),]
              ),
            ),
          )
      ),
    );
  }
}