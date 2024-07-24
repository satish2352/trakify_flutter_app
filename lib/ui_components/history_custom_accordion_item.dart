import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trakify/data/history_item.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/text.dart';

class CustomAccordion extends StatefulWidget {
  final HistoryItem historyItem;
  const CustomAccordion({super.key, required this.historyItem});

  @override
  CustomAccordionState createState() => CustomAccordionState();
}

class CustomAccordionState extends State<CustomAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    //Color headerBgColor = Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black54;
    //Color textColor = Theme.of(context).brightness == Brightness.dark ? Colors.black87 : Colors.white;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: _isExpanded ? const BorderRadius.vertical(top: Radius.circular(20)) : BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MySimpleText(
                      text: "Flat '${widget.historyItem.newState}' by ${widget.historyItem.updatedBy.split(' ').first}",
                      size: 16,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getStateColor(widget.historyItem.oldState),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Icon(Icons.arrow_forward_outlined, color: Colors.white, size: 15),
                        const SizedBox(width: 5),
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getStateColor(widget.historyItem.newState),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                MyIconButton(
                  icon: _isExpanded ? Icons.keyboard_arrow_up_outlined : Icons.keyboard_arrow_down_outlined,
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow("Name", widget.historyItem.updatedBy),
                  _buildInfoRow("Time", widget.historyItem.updatedOn),
                  _buildInfoRow("Old status", widget.historyItem.oldState),
                  _buildInfoRow("New status", widget.historyItem.newState),
                  const SizedBox(height: 5),
                  const MySimpleText(text: "Comment", size: 14, bold: true, color: Colors.black54),
                  MySimpleText(text: widget.historyItem.comment, size: 14, bold: true, color: Colors.black),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          MySimpleText(text: label, size: 14, bold: true, color: Colors.black54),
          MySimpleText(text: value, size: 14, bold: true, color: Colors.black),
        ],
      ),
    );
  }

  String formattedDate(DateTime dateTime) {
    return DateFormat('dd-MMM hh:mm a').format(dateTime);
  }

  Color _getStateColor(String state) {
    state = state.toLowerCase();
    switch (state) {
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
