import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';
import 'package:google_maps_basics/model/MultipleDestinations.dart';
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
  String _placeType = "gas_station";
  int _selectedIndex = 0;

  final List<String> _placeTypes = [
    "All",
    "tourist_attraction",
    "gas_station",
    "restaurant",
    "cafe",
    "airport",
    "museum",
    "stadium",
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

  bool showMultipleSearchBars = false;
  final List multipleDestinations = [];

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
  final Map<String, List<PlacesSearchResult>> _placesCache = {};

  //variables for the source and destinations
  late LatLng destination;
  late LatLng source;

  ///////////////////// NEW POLYLINE CODE FOR MULTIPLE DESTINATION //////////////////////
  void setPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    // Add the source location to the polyline coordinates
    polylineCoordinates.add(source);

    // Iterate through all the destinations and add their locations to the polyline coordinates
    for (int i = 0; i < destinations.length; i++) {
      Destination destination = destinations[i];
      LatLng destinationLocation = destination.location;
      double destinationLat = destinationLocation.latitude;
      double destinationLng = destinationLocation.longitude;

      // Get the route between the previous destination (or the source) and the current destination
      LatLng originLocation = (i == 0) ? source : destinations[i - 1].location;
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(originLocation.latitude, originLocation.longitude),
        PointLatLng(destinationLat, destinationLng),
      );

      // Add the points of the polyline result to the polyline coordinates
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      print(polylineCoordinates);
    }

    // Define the polyline options
    Polyline polyline = Polyline(
      polylineId: const PolylineId('poly'),
      color: ColorPalette.secondaryColor,
      width: 3,
      points: polylineCoordinates,
    );

    // Add the polyline to the map
    setState(() {
      _polylines.add(polyline);
    });
    final places = GoogleMapsPlaces(apiKey: googleApiKey);
    getTouristAttractionsAlongPolyline(polylineCoordinates, places, _placeType);

  }


  void updateMapWithSelectedPlaceType(String placeType) {
    // Clear previous markers
    // _markers.clear();
    // Get new markers based on selected place type
    final places = GoogleMapsPlaces(apiKey: googleApiKey);

    if (_placesCache.containsKey(placeType)) {
      // Use cached results if available
      getTouristAttractionsAlongPolyline(
          polylineCoordinates, places, _placesCache[placeType].toString());
    } else {
      // Get new results and store them in the cache
      getTouristAttractionsAlongPolyline(polylineCoordinates, places, placeType)
          .then((result) {
        _placesCache[placeType] = result;
      });
    }
    setState(() {});
  }

  Future<List<PlacesSearchResult>> getTouristAttractionsAlongPolyline(
      List<LatLng> polylineCoordinates,
      GoogleMapsPlaces places,
      String placeType) async {
    final touristAttractions = <PlacesSearchResult>[];
    for (final point in polylineCoordinates) {
      final nearbySearch = await places.searchNearbyWithRadius(
        Location(lat: point.latitude, lng: point.longitude),
        200,
        type: placeType,
      );
      touristAttractions.addAll(nearbySearch.results);
    }
    print(touristAttractions);
    // print the names of the tourist attractions
    for (final place in touristAttractions) {
      _markers.add(Marker(
        markerId: MarkerId(place.placeId),
        position:
            LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
        infoWindow: InfoWindow(title: place.name, snippet: place.vicinity),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
      ));
      setState(() {});
    }

    return touristAttractions;
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
        logo: const Text(''),
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
    sourceController.text = detail.result.name;
    _markers.add(Marker(
        markerId: const MarkerId("source"),
        position: source,
        infoWindow: InfoWindow(title: detail.result.name)));
    setPolylines();
    setState(() {});
    googleMapController
        .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0));
  }

  // destination search autocomplete button
  Future<void> _handlePressButtonDestination() async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onError,
        mode: _mode,
        language: "en",
        logo: const Text(''),
        strictbounds: false,
        types: [""],
        decoration: InputDecoration(
            hintText: "Search Destination",
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

  List<Destination> destinations = [];

  Future<void> displayPredictionDestination(
      Prediction p, ScaffoldMessengerState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    Destination newDestination = Destination(
      name: detail.result.name,
      location: LatLng(lat, lng),
    );

    setState(() {
      destinations.add(newDestination);
    });

    destinationController.text = detail.result.name;
    _markers.add(Marker(
      markerId: MarkerId("destination ${destinations.length}"),
      position: newDestination.location,
      infoWindow: InfoWindow(title: newDestination.name),
    ));
    setPolylines();
    setState(() {});
    googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(newDestination.location, 15.0));
  }

  @override
  Widget build(BuildContext context) {
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

          if (!showSearchField)
            Positioned(
                bottom: 30,
                left: 10,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ColorPalette.secondaryColor)),
                  onPressed: () {
                    _currentLocation();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NearByPlacesScreen()),
                    );
                  },
                  child: const Text(
                    'Nearby Me',
                    style: TextStyle(color: ColorPalette.primaryColor),
                  ),
                )),

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
              top: 0,
              child: Container(
                color: ColorPalette.primaryColor,
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      // search field and add more field button
                      if (showSearchField)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SearchBar(
                                  width:
                                      MediaQuery.of(context).size.width * 0.81,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showSearchField = false;
                                      });
                                    },
                                    icon: const Icon(Icons.arrow_upward),
                                  ),
                                  controller: sourceController,
                                  hintText: 'Search Source',
                                  onPress: () {
                                    Timer(const Duration(milliseconds: 500),
                                        () {
                                      _handlePressButtonSource();
                                    });
                                  }),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showMultipleSearchBars = true;
                                    multipleDestinations
                                        .add(destinationController.text);
                                    destinationController.text = '';
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 40,
                                      color: ColorPalette.secondaryColor,
                                  ),
                                ),
                              ),
                            ]),

                      ///// MULTIPLE SEARCH BAR FIELD /////
                      Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        child: Column(
                          children: [
                            if (showMultipleSearchBars)
                              Column(
                                children: List.generate(
                                  multipleDestinations.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: SearchBar(
                                            width: MediaQuery.of(context).size.width * 0.8,
                                            controller: TextEditingController(
                                              text: multipleDestinations[index],
                                            ),
                                            hintText: 'Search Destination',
                                            onPress: () {
                                              _handlePressButtonDestination();
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              multipleDestinations
                                                  .removeAt(index);

                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white,
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              size: 38,
                                              color: ColorPalette.secondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // list of places types
          if (showSearchField)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.28,
              right: 1,
              left: 1,
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
                          onTap: () {
                            setState(() {
                              _placeType = _placeTypes[index];
                            });
                            updateMapWithSelectedPlaceType(_placeType);
                          },
                          child: FloatingActionButton(
                            backgroundColor: _selectedIndex == index
                                ? ColorPalette.secondaryColor
                                : Colors.white,
                            foregroundColor: _selectedIndex == index
                                ? ColorPalette.primaryColor
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
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

          // current location
          if (!showSearchField)
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
