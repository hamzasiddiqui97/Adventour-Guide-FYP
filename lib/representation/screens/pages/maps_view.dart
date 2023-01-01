import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageGoogleMaps extends StatefulWidget {
  const HomePageGoogleMaps({Key? key}) : super(key: key);

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    // target: LatLng(0,0),
    zoom: 14.4746,
  );

  static const CameraPosition targetPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962),zoom: 14.4746,bearing: 192.0,tilt: 60);

  @override
  State<HomePageGoogleMaps> createState() => _HomePageGoogleMapsState();
}

class _HomePageGoogleMapsState extends State<HomePageGoogleMaps> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: HomePageGoogleMaps._kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },

            // current location
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: {
              const Marker(
                markerId: MarkerId('current_location'),
                position: LatLng(0, 0),
                infoWindow: InfoWindow(
                  title: "Your Location",
                ),
              ),
            },
          ),
          const Positioned(top: 50, left: 20, right: 20, child: SearchBar(),),
          Positioned(
            right: 60,
            bottom: 30,
            child: FloatingActionButton(
              backgroundColor: ColorPalette.secondaryColor,
              onPressed: () {
                currentLocation();
              },
              child: const Icon(
                Icons.location_on,
                color: ColorPalette.primaryColor,
              ),
            ),

          ),
        ],
      ),
    );
  }

  Future<void> currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(HomePageGoogleMaps.targetPosition));
  }
}
