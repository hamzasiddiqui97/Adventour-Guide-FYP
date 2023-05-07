import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/pages/home_view.dart';
import 'package:google_maps_basics/view/screens/pages/my_account.dart';


class HotelOwnerPage extends StatefulWidget {
  final String? uid;

  const HotelOwnerPage({Key? key, this.uid}) : super(key: key);

  @override
  State<HotelOwnerPage> createState() => _HotelOwnerPageState();
}

class _HotelOwnerPageState extends State<HotelOwnerPage> {
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePageNavBar(),
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
    return Scaffold(
      // appBar:
      // AppBar(
      //   title: Text('Hotel'),
      //   automaticallyImplyLeading: false,
      // ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      // Column(children: [
      //   // Text('Welcome, hotel owner! Your UID: ${widget.uid}'),
      //   Center(
      //     child: ElevatedButton(
      //       onPressed: () {
      //         // await FirebaseAuth.instance.signOut();
      //         // Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      //         Get.to(() => PropertyAdd());
      //       },
      //       child: const Text(
      //         'Post data',
      //       ),
      //     ),
      //   )
      // ]),
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
