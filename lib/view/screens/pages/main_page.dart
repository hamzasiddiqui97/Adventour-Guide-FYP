import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/pages/home_view.dart';
import 'package:google_maps_basics/view/screens/pages/maps_view.dart';
import 'package:google_maps_basics/view/screens/pages/my_account.dart';
import 'package:google_maps_basics/view/screens/pages/myplan_view.dart';

class NavigationPage extends StatefulWidget {
  final String uid;
  const NavigationPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePageNavBar(),
      HomePageGoogleMaps(),
      MyPlan(uid: widget.uid),
      MyAccount(),
    ];
  }

  int _currentIndex = 0;
  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: _currentIndex,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: ColorPalette.secondaryColor,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: "Maps",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_transportation),
              label: "My Plans",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
