import 'dart:async';
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

  String _placeType = "cafe";
  int _selectedIndex = 0;

  final List<String> _placeTypes = [
    "All",
    "tourist_attraction",
    "gas_station",
    "restaurant",
    "cafe",
    "hospital",
    "police",
    "atm",
    "parking",
    "bank",
    "car_rental",
    "embassy"
  ];

  final sourceController = TextEditingController();
  final destinationController = TextEditingController();
  bool showSearchField = false;
  String totalDistance = '';
  String totalTime = '';
  final Mode _mode = Mode.overlay;
  late GoogleMapController googleMapController;

  @override
  void dispose() {
    googleMapController.dispose();
    super.dispose();
  }

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


  // final List<Marker> _markersPolylinePlaces = []; for adding markers along polyline

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
        PointLatLng(source.latitude, source.longitude),
        PointLatLng(destination.latitude, destination.longitude));

    if (result.status == 'OK') {
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
      final places = GoogleMapsPlaces(apiKey: googleApiKey);
      getTouristAttractionsAlongPolyline(polylineCoordinates, places, _placeType);

    }
  }

  void updateMapWithSelectedPlaceType(String placeType) {
    // Clear previous markers
    _markers.clear();
    // Get new markers based on selected place type
    final places = GoogleMapsPlaces(apiKey: googleApiKey);

    getTouristAttractionsAlongPolyline(polylineCoordinates, places, _placeType);
    // Update the map
    setState(() {});
  }


  void getTouristAttractionsAlongPolyline(List<LatLng> polylineCoordinates, GoogleMapsPlaces places, String placeType) async {
    final touristAttractions = <PlacesSearchResult>[];
    for (final point in polylineCoordinates) {
      final nearbySearch = await places.searchNearbyWithRadius(
        Location(lat: point.latitude, lng: point.longitude),
        200,
        type: placeType,
      );
      touristAttractions.addAll(nearbySearch.results);
    }

    // print the names of the tourist attractions
    for (final place in touristAttractions) {
      _markers.add(Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
        infoWindow: InfoWindow(title: place.name, snippet: place.vicinity),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
      setState(() {
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

    // _markers.clear();    // removed this to make sure marker is not clear for source when dest is selected
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
            markers: _markers.toSet(),
          ),

          if (showSearchField)
            Positioned(
            top: 140,
            right: 0,
            left: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              height: MediaQuery.of(context).size.height / 13,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _placeTypes.length,
                itemBuilder: (BuildContext context, int index) {
                  var textPainter = TextPainter(
                    text: TextSpan(
                        text: _placeTypes[index],
                        style: Theme.of(context).textTheme.button),
                    textDirection: TextDirection.ltr,
                  );
                  textPainter.layout();
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(

                      width: textPainter.width + 40,
                      child: InkWell(
                        splashColor: Colors.white,
                        onTap: (){
                          setState(() {
                            _placeType = _placeTypes[index];
                          });
                          updateMapWithSelectedPlaceType(_placeType);
                        },

                        child: FloatingActionButton(
                          backgroundColor:  _selectedIndex == index ? ColorPalette.secondaryColor : Colors.black54,
                          foregroundColor: ColorPalette.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                          onPressed: () {
                            setState(() {
                              _selectedIndex = index;
                              _placeType = _placeTypes[index];
                            });
                            updateMapWithSelectedPlaceType(_placeType);
                          },
                          child: Text(_placeTypes[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
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
                child: const Text(
                  'Nearby Places',
                  style: TextStyle(color: ColorPalette.primaryColor),
                ),
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
                decoration: BoxDecoration(
                  color: ColorPalette.secondaryColor,
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
                  child: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (showSearchField)
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: SearchBar(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showSearchField = false;
                      });
                    },
                    icon: const Icon(Icons.close_outlined),
                  ),
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
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        showSearchField = false;
                      });
                    },
                    icon: const Icon(Icons.close_outlined),
                  ),
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
