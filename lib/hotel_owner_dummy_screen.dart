import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/pages/home_view.dart';
import 'package:google_maps_basics/view/screens/pages/my_account.dart';


class HotelOwnerPage extends StatefulWidget {
  final String uid;

  const HotelOwnerPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<HotelOwnerPage> createState() => _HotelOwnerPageState();
}

class _HotelOwnerPageState extends State<HotelOwnerPage> {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomePageNavBar(),
      const MyAccount(),
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
    return Scaffold(
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
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
