import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/views/news_view.dart';

class NewsWeatherScreen extends StatefulWidget {
  const NewsWeatherScreen({ super.key });
  @override
  State<NewsWeatherScreen> createState() => _NewsWeatherScreen();
}

class _NewsWeatherScreen extends State<NewsWeatherScreen> with SingleTickerProviderStateMixin {
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'News'),
    Tab(text: 'Weather'),
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
              if (tab.text == 'News') {
                return const NewsScreen();
              } else {
                return Center(
                  child: Text(
                    'This is the ${tab.text!.toLowerCase()} tab',
                    style: const TextStyle(fontSize: 36),
                  ),
                );
              }
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