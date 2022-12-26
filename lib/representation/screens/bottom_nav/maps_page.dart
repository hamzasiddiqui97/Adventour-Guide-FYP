import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageGoogleMap extends StatefulWidget {
  const HomePageGoogleMap({super.key});

  @override
  State<HomePageGoogleMap> createState() => _HomePageGoogleMapState();
}

class _HomePageGoogleMapState extends State<HomePageGoogleMap> {
  final Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(24.923541, 67.116233),
    zoom: 16,
  );

  List<Marker> _marker = [];
  final List<Marker> _list = [];

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then(
          (value) {},
    )
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GoogleMap(
          markers: Set<Marker>.of(_marker),
          compassEnabled: true,
          mapType: MapType.normal,
          myLocationEnabled: true,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: _kGooglePlex,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.location_searching,
        ),
        onPressed: () {
          getUserCurrentLocation().then((value) async {
            print(value.latitude.toString() + "" + value.longitude.toString());

            _marker.add(
              Marker(
                markerId: MarkerId('1'),
                position: LatLng(value.latitude, value.longitude),
                infoWindow: InfoWindow(title: "My Current Location"),
              ),
            );
            CameraPosition cameraPosition = CameraPosition(
              zoom: 17,
              target: LatLng(value.latitude, value.longitude),
            );

            final GoogleMapController controller = await _controller.future;
            controller
                .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState(() {});
          });
        },
      ),
    );
  }
}
