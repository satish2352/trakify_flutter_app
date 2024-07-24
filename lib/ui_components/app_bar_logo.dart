import 'package:flutter/material.dart';

Widget appBarLogo(BuildContext context){
  return Row(mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Image.asset(
        "assets/images/logo_blue.png",
        fit: BoxFit.fitHeight,
        width: MediaQuery.of(context).size.width*0.3,
      ),
    ],
  );
}