import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/history_item.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/button.dart';
import 'package:trakify/ui_components/custom_appbar.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/history_custom_accordion_item.dart';
import 'package:trakify/ui_components/loading_indicator.dart';
import 'package:trakify/ui_components/navbar.dart';

class FlatHistory extends StatefulWidget {
  final String flatId, flatNumber;
  const FlatHistory({super.key, required this.flatId, required this.flatNumber});

  @override
  FlatHistoryState createState() => FlatHistoryState();
}

class FlatHistoryState extends State<FlatHistory> {

  late final String flatId;
  bool _isLoading = false;
  late List<HistoryItem> historyItems = [], filteredHistoryItems = [];
  bool _ascendingOrder = false;
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedStartDate, _selectedEndDate;
  final dateFormat = DateFormat('dd MMMM yyyy, hh:mm a');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    flatId = widget.flatId;
    NetworkUtil.checkConnectionAndProceed(context, () {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchHistory();
    setState(() {
      _isLoading = false;
      _selectedStartDate=null;
      _selectedEndDate=null;
    });
  }

  Future<void> _fetchHistory() async {
    FetchResult result = await APIService.fetchHistory(widget.flatId);
    if(!mounted) return;
    if (result.success) {
      setState(() {
        historyItems = (result.data as List<HistoryItem>)..sort((a, b) => b.updatedOn.compareTo(a.updatedOn));
        filteredHistoryItems = historyItems;
      });
    } else {
      DialogManager.showInfoDialog(context, 'Fail', result.error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: scaffoldKey,
      endDrawer: const Drawer(child: NavBar(),),
      appBar: CustomAppBar(scaffoldKey: scaffoldKey),
      body: _isLoading
          ? LoadingIndicator.build()
          : RefreshIndicator.adaptive(
              strokeWidth: 2,
              color: Colors.blue,
              onRefresh: _initializeData,
              child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: const EdgeInsets.all(12.0),
                    child: MyTextButton(text: _selectedStartDate != null
                        ? DateFormat('dd-MM-yyyy').format(_selectedStartDate!)
                        : 'Choose start date',
                      onTap: () async {
                      final pickedDate = await _selectDate(context);
                      if (pickedDate != null) {
                        setState(() {
                          _selectedStartDate = pickedDate;
                        });
                      }
                    },),
                  ),
                  Padding(padding: const EdgeInsets.all(12.0),
                    child: MyTextButton(
                      text: _selectedEndDate != null
                          ? DateFormat('dd-MM-yyyy')
                          .format(_selectedEndDate!)
                          : 'Choose End date',
                      onTap: () async {
                        final pickedDate = await _selectDate(context);
                        if (pickedDate != null) {
                          setState(() {
                            _selectedEndDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ),
                  Padding(padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyButton(text: 'Search', onPressed: _filterHistoryItems),
                        MyButton(text: 'Sort', onPressed: (){
                          setState(() {
                            _ascendingOrder = !_ascendingOrder;
                            filteredHistoryItems.sort((a, b) => _ascendingOrder
                                ? a.updatedOn.compareTo(b.updatedOn)
                                : b.updatedOn.compareTo(a.updatedOn));
                          });
                        }),
                        MyButton(text: 'Reset', onPressed: _initializeData),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: filteredHistoryItems.isEmpty
                        ? const Center(
                            child: Text(
                              'No data found',
                              style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView(
                            padding: const EdgeInsets.all(10),
                            children: List.generate(
                              filteredHistoryItems.length,
                              (index) => FadeInAnimation(
                                delay: 0.4,
                                direction: 'up',
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomAccordion(historyItem: filteredHistoryItems[index]),
                                ),
                              ),
                            ),
                          ),
                  ),
                ],
              )),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
    return picked;
  }

  void _filterHistoryItems() {
    if (_selectedStartDate == null || _selectedEndDate == null) {
      DialogManager.showErrorDialog(
          context, 'Error', 'Please select both start and end dates.');
      return;
    }

    if (_selectedStartDate!.isAfter(_selectedEndDate!)) {
      DialogManager.showErrorDialog(
          context, 'Error', 'Start date cannot be after end date.');
      return;
    }

    // log('Selected Start Date: ${_selectedStartDate!.toIso8601String()}');
    // log('Selected End Date: ${_selectedEndDate!.toIso8601String()}');

    final fromDate = DateTime(
      _selectedStartDate!.year,
      _selectedStartDate!.month,
      _selectedStartDate!.day,
      0,
      0,
      0,
    );
    final toDate = DateTime(
      _selectedEndDate!.year,
      _selectedEndDate!.month,
      _selectedEndDate!.day,
      23,
      59,
      59,
    );

    final filteredItems = historyItems.where((item) {
      DateTime? itemDate;
      try {
        itemDate = dateFormat.parse(item.updatedOn);

        // log('Item Updated On Date: ${itemDate.toIso8601String()}');
      } catch (e) {
        // log('Error parsing date: ${item.updatedOn}, error: $e');
        return false;
      }

      // log('From Date: ${fromDate.toIso8601String()}');
      // log('To Date: ${toDate.toIso8601String()}');

      return (itemDate.isAfter(fromDate) && itemDate.isBefore(toDate)) ||
          itemDate.isAtSameMomentAs(fromDate) ||
          itemDate.isAtSameMomentAs(toDate);
    }).toList();

    setState(() {
      filteredHistoryItems = filteredItems;
    });
  }
}
