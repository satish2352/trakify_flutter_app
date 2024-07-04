import 'package:flutter/material.dart';

class MyDropdown<T> extends StatefulWidget {
  final List<T>? items;
  final T value;
  final Function(T) onChanged;
  final String hint;

  const MyDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.hint,
  });

  @override
  MyDropdownState<T> createState() => MyDropdownState<T>();
}

class MyDropdownState<T> extends State<MyDropdown<T>> {
  late T _selectedValue;
  late String hint;

  @override
  void initState() {
    super.initState();
    if (!widget.items!.contains(widget.value)) {
      _selectedValue = widget.items!.first;
    } else {
      _selectedValue = widget.value;
    }
    hint = widget.hint;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12.0),
      shadowColor: Colors.lightBlue,
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, top: 0, bottom: 0, right: 5),
        child: DropdownButton<T>(
          value: _selectedValue,
          onChanged: (T? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedValue = newValue;
              });
              widget.onChanged(newValue);
            }
          },
          underline: Container(),
          hint: Text(hint),
          items: widget.items!.map<DropdownMenuItem<T>>((T value) {
            return DropdownMenuItem<T>(
              value: value,
              child: Text(
                value.toString(),
                style: const TextStyle(fontFamily: 'OpenSans'),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
