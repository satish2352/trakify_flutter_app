import 'package:flutter/material.dart';

class MyDetailsItem extends StatelessWidget {
  final String value, itemName;

  const MyDetailsItem({super.key, required this.itemName, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(6.0),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(itemName, style: const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.normal, fontSize: 14),),),
                Expanded(child: Text(value, style: const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold, fontSize: 16),),),
              ],
            ),
          ),
          //const Row(children: [Expanded(child: Divider(color: Colors.grey,))])
        ],
      ),
    );
  }
}
