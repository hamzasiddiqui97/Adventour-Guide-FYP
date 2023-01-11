import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';
import 'package:google_maps_basics/view/screens/views/nearby_places_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class HomePageGoogleMaps extends StatefulWidget {
  const HomePageGoogleMaps({Key? key, this.long, this.lat}) : super(key: key);

  final double? long;
  final double? lat;
  @override
  State<HomePageGoogleMaps> createState() => _HomePageGoogleMapsState();
}

const kGoogleApiKey = googleApiKey;
final homeScaffoldKey = GlobalKey<ScaffoldMessengerState>();

class _HomePageGoogleMapsState extends State<HomePageGoogleMaps> {
  final sourceController = TextEditingController();
  final destinationController = TextEditingController();
  bool showSearchField = false;

  String totalDistance = '';
  String totalTime = '';

  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.921780, 67.117981),
    zoom: 14.4746,
  );

  void _onMapCreated(GoogleMapController controller) {
    googleMapController = controller;
  }

  @override
  void initState() {
    super.initState();
    polylinePoints = PolylinePoints();
    sourceController.text = 'Source';
    destinationController.text = 'Destination';
  }

  final List<Marker> _markers = [
    // Marker(
    // markerId: const MarkerId('current location'),
    // position: LatLng(24.9277448, 67.1088845),
    // infoWindow: const InfoWindow(title: "Current Location"),
    // ),
  ];

  // polylines
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;

  //variables for the source and destinations
  late LatLng destination;
  late LatLng source;
  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.status == 'OK') {
      // show distance and time

      // end

      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(Polyline(
            width: 9,
            polylineId: const PolylineId('polyLine'),
            color: ColorPalette.secondaryColor,
            points: polylineCoordinates));
      });
    }
  }

  // current location started
  loadData() async {
    _currentLocation().then((value) async {
      source = LatLng(value.latitude, value.longitude);
      _markers.add(
        Marker(
          markerId: const MarkerId('current location'),
          position: LatLng(value.latitude, value.longitude),
          infoWindow: const InfoWindow(title: "Current Location"),
        ),
      );
      CameraPosition cameraPosition = CameraPosition(
          zoom: 15, target: LatLng(value.latitude, value.longitude));

      // GoogleMapController controller =await _controller.future;
      googleMapController
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  Future<Position> _currentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error: $error");
    });
    return await Geolocator.getCurrentPosition();
  }
  // current location ended

  // search places function started

  // source search autocomplete button
  Future<void> _handlePressButtonSource() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: "en",
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: "Search source",
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: ColorPalette.primaryColor),
            )),
        components: [Component(Component.country, "pk")]);

    displayPredictionSource(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPredictionSource(
      Prediction p, ScaffoldMessengerState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    source = LatLng(lat, lng);
    sourceController.text =
        detail.result.name; // update the source field's text

    _markers.clear();
    _polylines.clear();
    _markers.add(Marker(
        markerId: const MarkerId("source"),
        // position: LatLng(lat, lng),
        position: source,
        infoWindow: InfoWindow(title: detail.result.name)));
    setPolylines();
    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 13.0));
  }

  // destination search autocomplete button
  Future<void> _handlePressButtonDestination() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: "en",
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: "Search Places",
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: ColorPalette.primaryColor),
            )),
        components: [Component(Component.country, "pk")]);

    displayPredictionDestination(p!, homeScaffoldKey.currentState);
  }

  void onErrorDestination(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPredictionDestination(
      Prediction p, ScaffoldMessengerState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    destination = LatLng(lat, lng);
    destinationController.text =
        detail.result.name; // update the source field's text

    _markers.clear();
    _polylines.clear();
    _markers.add(Marker(
        markerId: const MarkerId("destination"),
        // position: LatLng(lat, lng),
        position: destination,
        infoWindow: InfoWindow(title: detail.result.name)));
    setPolylines();
    setState(() {});

    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0));
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: homeScaffoldKey,
      body: Stack(
        alignment: Alignment.center,
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            compassEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: _onMapCreated,
            polylines: _polylines,
            // current location
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: Set<Marker>.of(_markers),
          ),
          Positioned(
              bottom: 30,
              left: 10,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorPalette.secondaryColor)),
                onPressed: () {
                  _currentLocation();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NearByPlacesScreen()),
                  );
                },
                child: const Text('Nearby Places',style: TextStyle(color: ColorPalette.primaryColor),),
              )),
          // Positioned(
          //   top: 100,
          //   left: 5,
          //   child: Container(
          //     margin: const EdgeInsets.all(20),
          //     padding: const EdgeInsets.all(20),
          //     color: ColorPalette.primaryColor,
          //     child: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Text("Total distance: $totalDistance"),
          //         Text("Total time: $totalTime"),
          //       ],
          //     ),
          //   ),
          // ),

          if (!showSearchField)
            Positioned(
              top: 30,
              right: 30,
              child: Container(
                decoration:BoxDecoration(color: ColorPalette.secondaryColor,
                borderRadius: BorderRadius.circular(40),
                ),
                height: 60,
                width: 60,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showSearchField = !showSearchField;
                    });
                  },
                  child: const Icon(Icons.search,color: Colors.white,),
                ),
              ),
            ),
          if (showSearchField)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: SearchBar(
                suffixIcon: IconButton(onPressed: (){
                  setState(() {
                    showSearchField = false;
                  });
                }, icon: const Icon(Icons.close_outlined),),
                  controller: sourceController,
                  hintText: 'Search Source',
                  onPress: () {
                    _handlePressButtonSource();
                  }),
            ),
          if (showSearchField)
            Positioned(
              top: 90,
              left: 20,
              right: 20,
              child: SearchBar(
                  suffixIcon: IconButton(onPressed: (){
                    setState(() {
                      showSearchField = false;
                    });
                  }, icon: const Icon(Icons.close_outlined),),
                  controller: destinationController,
                  hintText: 'Search Destination',
                  onPress: () {
                    _handlePressButtonDestination();
                  }),
            ),
          Positioned(
            right: 30,
            bottom: 30,
            child: FloatingActionButton(
              backgroundColor: ColorPalette.secondaryColor,
              onPressed: () async {
                _currentLocation().then((value) async {
                  setState(() {
                    // source = LatLng(value.latitude, value.longitude);
                  });
                  _markers.add(
                    Marker(
                      markerId: const MarkerId('current location'),
                      position: LatLng(value.latitude, value.longitude),
                      infoWindow: const InfoWindow(title: "Current Location"),
                    ),
                  );

                  CameraPosition cameraPosition = CameraPosition(
                      zoom: 15,
                      target: LatLng(value.latitude, value.longitude));

                  // GoogleMapController controller =await _controller.future;
                  googleMapController.animateCamera(
                      CameraUpdate.newCameraPosition(cameraPosition));
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
