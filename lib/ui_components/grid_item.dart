import 'package:flutter/material.dart';
import 'package:trakify/data/flatItem_class.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/text.dart';

class GridItem extends StatelessWidget {
  final FlatItem flat;
  final VoidCallback onTap;
  const GridItem({super.key, required this.flat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color c = _getFlatStateColor(flat.flatStatus);
    return AppearAnimation(
      child: GestureDetector(
        onTap: onTap,
        child: Column(mainAxisSize: MainAxisSize.max,
          children: [
            Container(height: 30, width: 30,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                shape: BoxShape.rectangle,
                color: c,
              ),
              child: Image.asset("assets/images/ic_flat.png"),
            ),
            MySimpleText(
              text: flat.flatNumber,
              size: 14,
              bold: true,
              color: Colors.black,
            ),
            MySimpleText(
              text: "${flat.bhk} BHK",
              size: 12,
              bold: false,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  // Function to get flat state color
  Color _getFlatStateColor(String flatState) {
    flatState = flatState.toLowerCase();
    switch (flatState) {
      case 'available':
        return MyColor.gridYellow;
      case 'booked':
        return MyColor.gridGreen;
      case 'blocked':
        return MyColor.gridRed;
      case 'hold':
        return MyColor.gridBlue;
      default:
        return Colors.grey;
    }
  }
}
