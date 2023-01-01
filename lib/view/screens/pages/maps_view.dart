import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePageGoogleMaps extends StatefulWidget {
  const HomePageGoogleMaps({Key? key}) : super(key: key);

  // static const CameraPosition targetPosition = CameraPosition(target: LatLng(37.42796133580664, -122.085749655962),zoom: 14.4746,bearing: 192.0,tilt: 60);

  @override
  State<HomePageGoogleMaps> createState() => _HomePageGoogleMapsState();
}

class _HomePageGoogleMapsState extends State<HomePageGoogleMaps> {

  final Completer<GoogleMapController> _controller = Completer();


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  final List<Marker> _markers = [];


  loadData(){
    _currentLocation().then((value) async{
      _markers.add(Marker(markerId: MarkerId(
          'current location'),
        position: LatLng(value.latitude,value.longitude),
        infoWindow: InfoWindow(
            title: "Your Location"),
      )
      );
      CameraPosition cameraPosition = CameraPosition(
          zoom: 15,
          target: LatLng(value.latitude,value.longitude));

      GoogleMapController controller =await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }


  Future<Position> _currentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace){
      print("error"+ error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },

            // current location
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: Set<Marker>.of(_markers),
          ),
          const Positioned(top: 50, left: 20, right: 20, child: SearchBar(),),
          Positioned(
            right: 30,
            bottom: 30,
            child: FloatingActionButton(
              backgroundColor: ColorPalette.secondaryColor,
              onPressed: () async{
                _currentLocation().then((value) async{
                  _markers.add(Marker(markerId: MarkerId(
                      'current location'),
                      position: LatLng(value.latitude,value.longitude),
                  infoWindow: InfoWindow(
                      title: "Your Location"),
                  )
                  );
                  CameraPosition cameraPosition = CameraPosition(
                      zoom: 15,
                      target: LatLng(value.latitude,value.longitude));

                  GoogleMapController controller =await _controller.future;
                  controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
                  setState(() {});
                });

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









}
