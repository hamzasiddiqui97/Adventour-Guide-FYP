import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/view/screens/pages/home_view.dart';
import 'package:google_maps_basics/view/screens/pages/my_account.dart';

//
// class TransportationOwnerPage extends StatefulWidget {
//   final String uid;
//   const TransportationOwnerPage({Key? key, required this.uid}) : super(key: key);
//
//   @override
//   State<TransportationOwnerPage> createState() => _TransportationOwnerPageState();
// }
//
// class _TransportationOwnerPageState extends State<TransportationOwnerPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         backgroundColor: ColorPalette.secondaryColor,
//         foregroundColor: ColorPalette.primaryColor,
//         title: const Text('TransportationOwnerPage'),
//       ),
//       body: Column(
//         children: [
//           Text('Welcome, transport owner! Your UID: ${widget.uid}'),
//
//           ElevatedButton(
//               onPressed: () async {
//                 await FirebaseAuth.instance.signOut();
//                 Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
//               },
//               child: const Text('Sign Out', ))
//
//         ],
//       ),
//     );
//   }
// }

class TransportationOwnerPage extends StatefulWidget {
  final String uid;

  const TransportationOwnerPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<TransportationOwnerPage> createState() => _TransportationOwnerPageState();
}

class _TransportationOwnerPageState extends State<TransportationOwnerPage> {
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
