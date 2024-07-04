import 'package:flutter/material.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/text.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColor.black,
        elevation: 4.0,
      ),
      onPressed: onPressed,
      child: Text(text.toUpperCase(), style: const TextStyle(fontFamily: 'OpenSans', color: Colors.white, fontSize: 16)),
    );
  }
}

class MyGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  const MyGoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.white,
      heroTag: null,
      mini: true,
      child: Image.asset('assets/images/ic_google.png', height: 30.0,),
    );
  }
}

class MyIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const MyIconButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      style: ButtonStyle(
        shadowColor: WidgetStateProperty.all<Color>(MyColor.bluePrimary),
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(MyColor.bluePrimary,),
      ),
    );
  }
}

class MyCardIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const MyCardIconButton({super.key, required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed,
      icon: Icon(icon, color: MyColor.white, size: 30, shadows: const [
        BoxShadow(color: MyColor.bluePrimary, spreadRadius: 10, blurRadius: 10, offset: Offset(0, 0),),
      ],),
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(4),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }
}

class FabButton extends StatelessWidget{

  final IconData iconData;
  final VoidCallback onPressed;

  const FabButton({super.key, required this.iconData, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        onPressed: onPressed,
        mini: true,
        backgroundColor: Colors.purple,
        heroTag: null,
        child: Icon(iconData, color: Colors.white),
      ),
    );
  }
}

class MyTextButton extends StatelessWidget{

  final String text;
  final VoidCallback onTap;
  const MyTextButton({super.key, required this.text, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, mainAxisSize: MainAxisSize.min,
        children: [
          MySimpleText(text: text, size: 15,),
          const SizedBox(width: 10,),
          const Icon(Icons.calendar_month_outlined, color: Colors.blue,),
        ],
      ),
    );
  }

}