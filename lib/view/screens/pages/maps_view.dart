import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';
import 'package:google_maps_basics/model/NearbyResponse.dart';
import 'package:google_maps_basics/view/screens/views/nearby_places_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'package:http/http.dart' as http;

class HomePageGoogleMaps extends StatefulWidget {
  const HomePageGoogleMaps({Key? key}) : super(key: key);

  @override
  State<HomePageGoogleMaps> createState() => _HomePageGoogleMapsState();
}

const kGoogleApiKey = googleApiKey;
final homeScaffoldKey = GlobalKey<ScaffoldMessengerState>();

class _HomePageGoogleMapsState extends State<HomePageGoogleMaps> {

  String totalDistance = '';
  String totalTime = '';

  final Mode _mode = Mode.overlay;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.921780, 67.117981),
    zoom: 14.4746,
  );

  late GoogleMapController googleMapController;

  final List<Marker> _markers = [];


  // polyline Code from git

  // LatLng origin = const LatLng(24.92467020467566, 67.11490186889257);
  // LatLng destination = const LatLng(24.927715525776858, 67.10870060173293);

//   void drawPolyline() async {
//     var response = await http.post(Uri.parse("https://maps.googleapis.com/maps/api/directions/json?key=" +
//         googleApiKey +
//         "&units=metric&origin=" +
//         origin.latitude.toString() +
//         "," +
//         origin.longitude.toString() +
//         "&destination=" +
//         destination.latitude.toString() +
//         "," +
//         destination.longitude.toString() +
//         "&mode=driving"));
//
//     print(response.body);
//
//     polylineResponse = PolylineResponse.fromJson(jsonDecode(response.body));
//
//     totalDistance = polylineResponse.routes![0].legs![0].distance!.text!;
//     totalTime = polylineResponse.routes![0].legs![0].duration!.text!;
//
//     for (int i = 0; i < polylineResponse.routes![0].legs![0].steps!.length; i++) {
//       polylinePoints.add(Polyline(polylineId: PolylineId(polylineResponse.routes![0].legs![0].steps![i].polyline!.points!), points: [
//         LatLng(
//             polylineResponse.routes![0].legs![0].steps![i].startLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].startLocation!.lng!),
//         LatLng(polylineResponse.routes![0].legs![0].steps![i].endLocation!.lat!, polylineResponse.routes![0].legs![0].steps![i].endLocation!.lng!),
//       ],width: 3,color: Colors.red));
//     }
//
//     setState(() {});
//   }
// }

  // polyline ended here



  // current location started
  loadData(){
    _currentLocation().then((value) async{
      _markers.add(Marker(markerId: MarkerId(
          'current location'),
        position: LatLng(value.latitude,value.longitude),
        infoWindow: InfoWindow(
            title: "Your Location"),
      ),
      );
      CameraPosition cameraPosition = CameraPosition(
          zoom: 15,
          target: LatLng(value.latitude,value.longitude));

      // GoogleMapController controller =await _controller.future;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
  // current location ended


  // search places function started

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: "en",
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(hintText: "Search Places",
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: ColorPalette.primaryColor),)),
        components: [Component(Component.country,"pk")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response){
    homeScaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(Prediction p, ScaffoldMessengerState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail =await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    _markers.clear();
    _markers.add(Marker(markerId: const MarkerId("0"),position: LatLng(lat, lng), infoWindow: InfoWindow(title: detail.result.name)));
    setState(() {});

    googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat,lng), 15.0));

  }


  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key:homeScaffoldKey ,
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },

            // current location
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: Set<Marker>.of(_markers),
          ),

          Positioned(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NearByPlacesScreen()),
                  );
                },
                child: const Text('Get Nearby Places'),
              )
          ),

          Positioned(
            top: 100,
            left: 5,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              color: ColorPalette.primaryColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total distance: $totalDistance"),
                  Text("Total time: $totalTime"),
                ],
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: SearchBar(
                onPress: (){
                  _handlePressButton();
                }),),
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
                    infoWindow: const InfoWindow(
                        title: "Your Location"),
                  ),


                  );

                  CameraPosition cameraPosition = CameraPosition(
                      zoom: 15,
                      target: LatLng(value.latitude,value.longitude));

                  // GoogleMapController controller =await _controller.future;
                  googleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
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
