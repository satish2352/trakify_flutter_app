import 'package:flutter/material.dart';

class FilterChipList extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final Function(String) onItemSelected;

  const FilterChipList({super.key,
    required this.items,
    required this.selectedItem,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          return Padding(padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(item, style: const TextStyle(fontFamily: 'OpenSans'),),
              selected: selectedItem == item,
              onSelected: (selected) {
                onItemSelected(item);
              },
              selectedColor: Colors.blue,
              backgroundColor: Colors.grey[100],
              labelStyle: TextStyle(
                  color: selectedItem == item ? Colors.white : Colors.black,
                  fontFamily: 'OpenSans'
              ),
              elevation: selectedItem == item ? 4 : 0,
              shadowColor: Colors.grey[800]!,
              pressElevation: 10,
              checkmarkColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
                side: BorderSide(
                  color: selectedItem == item ? Colors.blue : Colors.grey[300]!,
                  width: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}