import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trakify/app/network.dart';
import 'package:trakify/app/page_route.dart';
import 'package:trakify/data/api_service.dart';
import 'package:trakify/data/flatItem_class.dart';
import 'package:trakify/screens/update_flat.dart';
import 'package:trakify/ui_components/animations.dart';
import 'package:trakify/ui_components/colors.dart';
import 'package:trakify/ui_components/dialog_manager.dart';
import 'package:trakify/ui_components/dropdown.dart';
import 'package:trakify/ui_components/grid_item.dart';
import 'package:trakify/ui_components/loading_indicator.dart';
import 'package:trakify/ui_components/material_text_form_field.dart';
import 'package:trakify/ui_components/navbar.dart';
import 'package:trakify/ui_components/text.dart';


class WingsDashboardPage extends StatefulWidget {
  final String selectedProjectId, selectedWingId, wingName;

  const WingsDashboardPage({
    super.key,
    required this.selectedProjectId,
    required this.selectedWingId,
    required this.wingName,
  });

  @override
  WingsDashboardPageState createState() => WingsDashboardPageState();
}

class WingsDashboardPageState extends State<WingsDashboardPage> with RouteAware {

  late List<FlatItem> flatItems = [], filteredFlats = [];
  TextEditingController searchController = TextEditingController();
  String dropdownValue = 'All';
  String searchText = '';
  final List<String> flatStatus = ['All', 'available', 'booked', 'hold', 'blocked'];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    NetworkUtil.checkConnectionAndProceed(context, ()
    {
      _initializeData();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modalRoute = ModalRoute.of(context);
    if (modalRoute is PageRoute) {
      routeObserver.subscribe(this, modalRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Called when the current route has been popped off, and the user returned to this route.
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(() {
      _isLoading = true;
    });
    await _fetchFlats();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _fetchFlats() async {
    FetchResult result = await APIService.fetchFloors(widget.selectedWingId);
    if(!mounted) return;
    if (result.success) {
      setState(() {
        flatItems = result.data as List<FlatItem>;
        filteredFlats = flatItems;
      });
    } else {
      DialogManager.showInfoDialog(context, 'Fail', result.error.toString());
    }
  }

  void filterFlats(String searchTerm, String status) {
    setState(() {
      filteredFlats = flatItems.where((flat) {
        final flatStatusMatches = status == 'All' || flat.flatStatus.toLowerCase() == status.toLowerCase();
        final flatNumberMatches = flat.flatNumber.contains(searchTerm);
        return flatStatusMatches && flatNumberMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(strokeWidth: 2, color: Colors.blue,
      onRefresh: _fetchFlats,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(widget.wingName, style: const TextStyle(fontSize: 25, color: Colors.white),),
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_outlined)),
          actions: [
            IconButton(onPressed: _showHelp, icon: const Icon(Icons.info_outline_rounded),),
            IconButton(icon: const Icon(Icons.menu_outlined), onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return const NavBar();
                },
              );},),
          ],
        ),
        body: _isLoading ? LoadingIndicator.build() :SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(padding: const EdgeInsets.all(10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FadeInAnimation(delay: 1, direction: 'right',
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const MySimpleText(text: "SEARCH", size: 12, color: Colors.grey,),
                              MaterialTextFormField(
                                hintText: 'Number',
                                suffixIcon: Icons.search,
                                keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                controller: searchController,
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value;
                                  });
                                  filterFlats(searchText, dropdownValue);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      FadeInAnimation(delay: 1, direction: 'left',
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const MySimpleText(text: "STATUS", size: 12, color: Colors.grey,),
                            MyDropdown(
                              items: flatStatus,
                              value: flatStatus.first,
                              hint: "STATUS",
                              onChanged: (String? newValue) {
                                setState(() {
                                    dropdownValue = newValue!;
                                  },
                                );
                                filterFlats(searchText, dropdownValue);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const MySimpleText(text: "FLATS", size: 12, color: Colors.grey),
                  Material(elevation: 4, borderRadius: BorderRadius.circular(12.0), shadowColor: Colors.lightBlue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
                          child: Column(
                            children:[
                              for (var floorNumber in flatItems.map((flat) => flat.floorNumber).toSet().toList())
                                MySimpleText(text: getUserReadableFloorLabel(floorNumber), size: 12,),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Expanded(
                          child: SizedBox(height: MediaQuery.of(context).size.height * 0.6,
                            child: filteredFlats.isEmpty ? const Center(child: MySimpleText(text: 'No flats available', size: 18,),) : ListView.builder(
                              itemCount: filteredFlats.map((flat) => flat.floorNumber).toSet().length,
                              itemBuilder: (BuildContext context, int index) {
                                final floorNumber = filteredFlats.map((flat) => flat.floorNumber).toSet().toList()[index];
                                final flatsForFloor = filteredFlats.where((flat) => flat.floorNumber == floorNumber).toList();
                                return Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: AppearAnimation(
                                        child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(width: 60, child: Divider(color: Colors.grey,)),
                                            Padding(padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                              child: Text(getUserReadableFloorLabel(floorNumber),
                                                style: const TextStyle(fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(width: 60, child: Divider(color: Colors.grey,)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GridView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0,
                                      ),
                                      itemCount: flatsForFloor.length,
                                      itemBuilder: (context, flatIndex) {
                                        return GridItem(
                                          flat: flatsForFloor[flatIndex],
                                          onTap: () {
                                            NetworkUtil.checkConnectionAndProceed(context, () {
                                              Navigator.push(context, CustomPageRoute(nextPage: UpdateFlat(flatId: flatsForFloor[flatIndex].id, floorId: flatsForFloor[flatIndex].floorId), direction: 1));
                                            });
                                          },
                                        );
                                        },
                                    ),
                                  ],
                                );
                                },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showHelp() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: MyHeadingText(text: 'Info')),
                const SizedBox(
                  height: 20,
                ),
                const MySimpleText(text: "Color Details", size: 20, bold: true),
                const SizedBox(height: 10,),
                legendRow('Flat is Booked', MyColor.gridGreen),
                legendRow('Flat is Available', MyColor.gridYellow),
                legendRow('Flat is Blocked', MyColor.gridRed),
                legendRow('Flat is on Hold', MyColor.gridBlue),
                const SizedBox(height: 20,),
                const MySimpleText(text: "Floor Details", size: 20, bold: true),
                const SizedBox(height: 10,),
                const MySimpleText(text: "Under the 'FLATS' section, the left side has floor indicator which shows all the floors.\n- F stands for floors above ground floor.\n- G stands for Ground Floor.\n- UG means UnderGround Floors", size: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Row legendRow(String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(margin: const EdgeInsets.all(5), height: 10, width: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10,),
        MySubHeadingText(text: text),
        const SizedBox(height: 25,),
      ],
    );
  }

  String getUserReadableFloorLabel(int originalFloor) {
    try {
      int floorNumber = originalFloor;
      if (floorNumber > 0) {
        return 'F$floorNumber';
      } else if (floorNumber < 0) {
        return 'UG${floorNumber.abs()}';
      } else {
        return 'G';
      }
    } on Exception {
      return originalFloor.toString();
    }
  }
}
