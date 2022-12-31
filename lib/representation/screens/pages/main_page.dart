import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/representation/screens/pages/my_account.dart';
import 'package:google_maps_basics/representation/screens/pages/home_view.dart';
import 'package:google_maps_basics/representation/screens/pages/maps_view.dart';
import 'package:google_maps_basics/representation/screens/pages/myplan_view.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  List pages = const [
    HomePageNavBar(),
    HomePageGoogleMaps(),
    MyPlan(),
    MyAccount(),
  ];

  int _currentIndex = 0;
  void onTap(int index){
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[_currentIndex],
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
              icon: Icon(Icons.home,),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map,),
              label: "Maps",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.emoji_transportation,),
              label: "My Plans",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
