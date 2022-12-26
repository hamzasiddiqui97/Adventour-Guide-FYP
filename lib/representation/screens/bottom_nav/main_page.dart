import 'package:flutter/material.dart';
import 'package:google_maps_basics/representation/screens/bottom_nav/feedback_page.dart';
import 'package:google_maps_basics/representation/screens/bottom_nav/home_page.dart';
import 'package:google_maps_basics/representation/screens/bottom_nav/maps_page.dart';
import 'package:google_maps_basics/representation/screens/bottom_nav/my_plan.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {

  List pages = const[
    HomePageNavBar(),
    HomePageGoogleMap(),
    MyPlan(),
    FeedbackPage(),
  ];

  int currentIndex = 0;
  void onTap(int index){
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: currentIndex,
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.black,
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
              icon: Icon(Icons.feedback,),
              label: "Feedback",
            ),
          ],
        ),
      ),
    );
  }
}
