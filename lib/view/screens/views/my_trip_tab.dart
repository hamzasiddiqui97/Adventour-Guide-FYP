import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';

class MyTripTab extends StatefulWidget {
  const MyTripTab({ super.key });
  @override
  State<MyTripTab> createState() => _MyTripTab();
}

class _MyTripTab extends State<MyTripTab> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'Trips'),
    Tab(text: 'Booking'),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          centerTitle: true,
          title: Text(_buildTitle()),
          bottom: TabBar(
            unselectedLabelColor: ColorPalette.primaryColor,
            indicator: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: ColorPalette.secondaryColor),
              ),
            ),
            onTap: (index) {
              setState(() {
                _tabController.index = index;
              });
            },
            controller: _tabController,
            tabs: myTabs,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TabBarView(
            controller: _tabController,
            children: myTabs.map((Tab tab) {
              final String label = tab.text!.toLowerCase();
              return Center(
                child: Text(
                  'This is the $label tab',
                  style: const TextStyle(fontSize: 36),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
  _buildTitle() {
    final String? title = (myTabs[_tabController.index].text);
    return title;
  }
}