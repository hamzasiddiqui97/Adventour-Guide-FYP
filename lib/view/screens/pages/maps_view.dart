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
  const HomePageGoogleMaps({Key? key}) : super(key: key);

  @override
  State<HomePageGoogleMaps> createState() => _HomePageGoogleMapsState();
}

const kGoogleApiKey = googleApiKey;
final homeScaffoldKey = GlobalKey<ScaffoldMessengerState>();

class _HomePageGoogleMapsState extends State<HomePageGoogleMaps> {
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
  }

  final List<Marker> _markers = [];

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
        PointLatLng(
            source.latitude,
            source.longitude
        ),
        PointLatLng(
            destination.latitude,
            destination.longitude
        )
    );

    if (result.status == 'OK') {
      // show distance and time

      // end

      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.add(
            Polyline(
                width: 9,
                polylineId: PolylineId('polyLine'),
                color:ColorPalette.secondaryColor ,
                points: polylineCoordinates
            )
        );
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
      setState(() {}
      );
    });
  }

  Future<Position> _currentLocation() async {
    setPolylines();
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error: $error");
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

        decoration: InputDecoration(
            hintText: "Search Places",
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(color: ColorPalette.primaryColor),
            )),
        components: [Component(Component.country, "pk")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.errorMessage!)));
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldMessengerState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    destination = LatLng(lat, lng);

    _markers.clear();
    _polylines.clear();
    _markers.add(Marker(
        markerId: const MarkerId("0"),
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
                child: const Text('Nearby Places'),
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
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: SearchBar(onPress: () {
              _handlePressButton();
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
                    source = LatLng(value.latitude, value.longitude);
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