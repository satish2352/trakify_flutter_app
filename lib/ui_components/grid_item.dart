import 'package:flutter/material.dart';
import 'package:trakify/data/flatItem_class.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';

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
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: c,
            boxShadow: [
              BoxShadow(
                color: c.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              flat.flatNumber,
              style: TextStyle(
                fontFamily: 'OpenSans',
                color: _getTextColor(c),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
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
