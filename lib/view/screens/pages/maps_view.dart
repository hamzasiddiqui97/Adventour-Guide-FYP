import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class HomePageGoogleMaps extends StatefulWidget {
  const HomePageGoogleMaps({Key? key}) : super(key: key);

  @override
  State<HomePageGoogleMaps> createState() => _HomePageGoogleMapsState();
}


const kGoogleApiKey = googleApiKey;
final homeScaffoldKey = GlobalKey<ScaffoldMessengerState>();

class _HomePageGoogleMapsState extends State<HomePageGoogleMaps> {

  final Mode _mode = Mode.overlay;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.921780, 67.117981),
    zoom: 14.4746,
  );

  late GoogleMapController googleMapController;

  final List<Marker> _markers = [];

  // current location started
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
              borderSide: BorderSide(color: ColorPalette.primaryColor),)),
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
                    infoWindow: InfoWindow(
                        title: "Your Location"),
                  )
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