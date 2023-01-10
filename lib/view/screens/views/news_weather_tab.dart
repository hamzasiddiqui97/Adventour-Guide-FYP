import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(_buildTitle())),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              _tabController.index = index;
            });
          },
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: TabBarView(
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
    );
  }
  _buildTitle() {
    final String? title = (myTabs[_tabController.index].text);
    return title;
  }
}