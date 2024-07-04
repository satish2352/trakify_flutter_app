import 'package:flutter/material.dart';

Widget appBarLogo(BuildContext context){
  String imageString = Theme.of(context).brightness==Brightness.light ? 'assets/images/logo_blue.png' : 'assets/images/logo_white.png';
  return Row(mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(padding: const EdgeInsets.only(left: 8),
        child: Image.asset(imageString, fit: BoxFit.fitWidth,
          width: MediaQuery.of(context).size.width*0.2,
          height: MediaQuery.of(context).size.height*0.2,
        ),
      ),
    ],
  );
}