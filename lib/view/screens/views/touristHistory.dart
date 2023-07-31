import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/firebase_reference.dart';
import 'package:google_maps_basics/widgets/touristHotelBookingList.dart';
import 'package:google_maps_basics/widgets/touristTransportBookingLIst.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TouristHistory extends StatefulWidget {
  const TouristHistory({Key? key}) : super(key: key);

  @override
  State<TouristHistory> createState() => _TouristHistoryState();
}

class _TouristHistoryState extends State<TouristHistory> with TickerProviderStateMixin{
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Hotel'),
    Tab(text: 'Transport'),
    // Tab(text: 'RIGHT'),
  ];

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
    final uid = FirebaseAuth.instance.currentUser!.uid;
    AddPlacesToFirebaseDb.getTouristHistory(uid);
    AddPlacesToFirebaseDb.getTransportHistory(uid);

  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.secondaryColor,
        foregroundColor: ColorPalette.primaryColor,
        title: const Text("Your Bookings"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.lime,
          indicatorWeight: 5.0,
          labelColor: Colors.white,
          labelPadding: EdgeInsets.only(top: 10.0),
          unselectedLabelColor: Colors.grey,
          tabs:myTabs
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TouristHotelBookingList(),
          TouristTransportBookingList()
        ],
      ),
    );
  }
}
