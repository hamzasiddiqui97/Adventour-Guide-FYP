import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/MultipleDestinations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

import '../../../widgets/search_bar_widget.dart';
import '../views/places_list_along_the_route.dart';

class HomePageGoogleMaps extends StatefulWidget {
  const HomePageGoogleMaps({Key? key}) : super(key: key);

  @override
  State<HomePageGoogleMaps> createState() => _HomePageGoogleMapsState();
}

const kGoogleApiKey = googleApiKey;

class _HomePageGoogleMapsState extends State<HomePageGoogleMaps> {
  List<Map<String, String>> markerDataList = [];

  final homeScaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final List<String> _selectedPlaceTypes = [];

  final List<Marker> _attractionMarkers = [];

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
    // "car_rental",
    // "embassy"
  ];

  bool showSearchField = false;
  final Mode _mode = Mode.overlay;
  late GoogleMapController googleMapController;

  bool showMultipleSearchBars = false;

  final sourceController = TextEditingController();
  final List<TextEditingController> destinationControllers = [];
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
    _clearMap();
    polylinePoints = PolylinePoints();
    sourceController.text = 'Source';
    destinationControllers.add(TextEditingController(text: 'Destination'));
  }

  final List<Marker> _markers = [];

  Map<String, String> placeTypeToMarkerImage = {
    'tourist_attraction': 'assets/markers/park.png',
    'gas_station': 'assets/markers/gas-station.png',
    'restaurant': 'assets/markers/restaurant.png',
    'cafe': 'assets/markers/cafe.png',
    'airport': 'assets/markers/airport.png',
    'museum': 'assets/markers/museum.png',
    'stadium': 'assets/markers/stadium.png',
    'hospital': 'assets/markers/hospital.png',
    'police': 'assets/markers/police-station.png',
    'atm': 'assets/markers/atm-card.png',
    'parking': 'assets/markers/parking-area.png',
    'bank': 'assets/markers/atm-card.png',
  };


  // polylines
  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  final Map<String, List<PlacesSearchResult>> _placesCache = {};

  //variables for the source and destinations
  late LatLng destination;
  late LatLng source;
  bool isLegendOpen = false;

  // copy of polylineCoordinates to send to new screen..
  List<LatLng> tempPolylineCoordinates = [];

  void setPolylines() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> polylineCoordinates = [];

    List<Marker> markers = _markers.toList();

    for (int i = 0; i < markers.length - 1; i++) {
      LatLng originLocation = markers[i].position;
      LatLng destinationLocation = markers[i + 1].position;

      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey,
        PointLatLng(originLocation.latitude, originLocation.longitude),
        PointLatLng(
            destinationLocation.latitude, destinationLocation.longitude),
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
    }

    Polyline polyline = Polyline(
      polylineId: const PolylineId('poly'),
      color: ColorPalette.secondaryColor,
      width: 3,
      points: polylineCoordinates,
    );

    // Assign polylineCoordinates to tempPolylineCoordinates (making copy of polyline points).
    tempPolylineCoordinates = List<LatLng>.from(polylineCoordinates);

    setState(() {
      _polylines.clear();
    });

    setState(() {
      _polylines.add(polyline);
    });

    print('polylineCoordinates length: ${polylineCoordinates.length}');

    final places = GoogleMapsPlaces(apiKey: googleApiKey);
    getTouristAttractionsAlongPolyline(
        polylineCoordinates, places, _selectedPlaceTypes, context);
  }

  void _showFetchingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(width: 10),
              Text('Fetching nearby places...'),
            ],
          ),
        );
      },
    ).then((value) {
      if (value == null || !value) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No places found'),
          backgroundColor: ColorPalette.secondaryColor,
        ));
      }
    });
  }

  void updateMapWithSelectedPlaceType(List<String> _selectedPlaceTypes) {
    // Clear previous markers
    setState(() {
      _attractionMarkers.clear();
    });
    // Get new markers based on selected place types
    final places = GoogleMapsPlaces(apiKey: googleApiKey);

    for (String placeType in _selectedPlaceTypes) {
      if (_placesCache.containsKey(placeType)) {
        // Use cached results if available
        getTouristAttractionsAlongPolyline(
            polylineCoordinates, places, [placeType], context);
      } else {
        // Get new results and store them in the cache
        getTouristAttractionsAlongPolyline(
            polylineCoordinates, places, [placeType], context)
            .then((result) {
          _placesCache[placeType] = result;
        });
      }
    }

    print('placesCache length: ${_placesCache.length}');
    print('placesCache length: ${_placesCache.entries}');
    setState(() {});
  }

  Future<List<PlacesSearchResult>> getTouristAttractionsAlongPolyline(
      List<LatLng> polylineCoordinates,
      GoogleMapsPlaces places,
      List<String> _selectedPlaceTypes,
      BuildContext context) async {
    _showFetchingDialog(context);

    final touristAttractions = <PlacesSearchResult>{};
    final uniquePlaceIds = <String>{};

    final searchResults = await Future.wait(_selectedPlaceTypes.map(
            (placeType) => Future.wait(
            polylineCoordinates.map((point) => places.searchNearbyWithRadius(
              Location(lat: point.latitude, lng: point.longitude),
              100,
              type: placeType,
            )))));

    for (final nearbySearch in searchResults.expand((x) => x)) {
      for (final result in nearbySearch.results) {
        if (uniquePlaceIds.add(result.placeId)) {
          touristAttractions.add(result);
        }
      }
    }

    // Print the names of the tourist attractions
    for (final place in touristAttractions) {
      // Get icon based on the first place type
      Future<BitmapDescriptor> icon = getMarkerIconForPlaceType(place.types[0]);

      _markers.add(Marker(
        markerId: MarkerId(place.placeId),
        position: LatLng(place.geometry!.location.lat, place.geometry!.location.lng),
        infoWindow: InfoWindow(title: place.name, snippet: place.vicinity),
        icon: await icon,  // Use custom icon here
      ));

    }

    setState(() {});

    if (kDebugMode) {
      print('tourist attractions list length: ${touristAttractions.length}');
    }

    // Close the fetching dialog
    Navigator.pop(context);

    return touristAttractions.toList();
  }

  Future<BitmapDescriptor> getMarkerIconForPlaceType(String placeType) async {
    if (placeTypeToMarkerImage.containsKey(placeType)) {
      return await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(size: Size(3, 3)),
          placeTypeToMarkerImage[placeType]!);
    } else {
      return BitmapDescriptor.defaultMarker; // Default marker icon
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

    if (p != null) {
      displayPredictionSource(p, homeScaffoldKey.currentState);
    } else {
      // homeScaffoldKey.currentState?.showSnackBar(const SnackBar(content: Text('Error: No prediction selected')));
      return;
    }
  }

  void onError(PlacesAutocompleteResponse? response) {
    final errorMessage = response?.errorMessage ?? 'Unknown error';
    homeScaffoldKey.currentState
        ?.showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  Future<void> displayPredictionSource(
      Prediction p, ScaffoldMessengerState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry?.location.lat;
    final lng = detail.result.geometry?.location.lng;

    if (lat != null && lng != null) {
      setState(() {
        source = LatLng(lat, lng);
        sourceController.text = detail.result.name;
        _markers.add(Marker(
            markerId: const MarkerId("source"),
            position: source,
            infoWindow: InfoWindow(title: detail.result.name)));
      });
      setPolylines();
      googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 15.0));
    } else {
      currentState?.showSnackBar(
          const SnackBar(content: Text('Error: Could not get location')));
    }
  }

  // destination search autocomplete button

  Future<void> _handlePressButtonDestination(int index) async {
    Prediction? p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        onError: onErrorDestination,
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

    if (p != null) {
      displayPredictionDestination(p, homeScaffoldKey.currentState, index);
    } else {
      homeScaffoldKey.currentState?.showSnackBar(
          const SnackBar(content: Text('Error: No prediction selected')));
    }
  }

  void onErrorDestination(PlacesAutocompleteResponse? response) {
    final errorMessage = response?.errorMessage ?? 'Unknown error';
    homeScaffoldKey.currentState
        ?.showSnackBar(SnackBar(content: Text(errorMessage)));
  }

  List<Destination> destinations = [];

  Future<void> displayPredictionDestination(
      Prediction p, ScaffoldMessengerState? currentState, int index) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry?.location.lat;
    final lng = detail.result.geometry?.location.lng;

    if (lat != null && lng != null) {
      Destination newDestination = Destination(
        name: detail.result.name,
        location: LatLng(lat, lng),
      );

      setState(() {
        destinations.add(newDestination);
        multipleDestinations[index] = newDestination.name;
      });

      _markers.add(Marker(
        markerId: MarkerId("destination ${destinations.length}"),
        position: newDestination.location,
        infoWindow: InfoWindow(title: newDestination.name),
      ));
      setPolylines();
      setState(() {});
      googleMapController.animateCamera(
          CameraUpdate.newLatLngZoom(newDestination.location, 15.0));
      if (kDebugMode) {
        print('destinations: ${destinations.toString()}');
      }
    } else {
      currentState?.showSnackBar(
          const SnackBar(content: Text('Error: Could not get location')));
    }
  }

  void _clearMap() {
    setState(() {
      _markers.clear();
      _polylines.clear();
      sourceController.clear();
      destinationControllers.clear();
      multipleDestinations.clear();
      showMultipleSearchBars = false;
      _selectedPlaceTypes.clear();
      destinations.clear();
      _attractionMarkers.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
              markers: {..._markers, ..._attractionMarkers}.toSet(),
            ),

            if (!showSearchField)
              Positioned(
                bottom: 80,
                left: 10,
                child: ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          ColorPalette.secondaryColor)),
                  onPressed: () async {
                    // final distancesAndTimes = await calculateDistanceAndTime(_markers);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlacesListAlongTheRoute(
                          markers: _markers.toSet().toList(),
                          // distancesAndTimes: distancesAndTimes,
                          polylineCoordinates: tempPolylineCoordinates,
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'Places List',
                    style: TextStyle(color: ColorPalette.primaryColor),
                  ),
                ),
              ),

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
                  height: MediaQuery.of(context).size.height * 0.28,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SearchBar(
                                    width: MediaQuery.of(context).size.width *
                                        0.81,
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
                                InkWell(
                                  splashColor: ColorPalette.secondaryColor,
                                  onTap: () {
                                    setState(() {
                                      showMultipleSearchBars = true;
                                      final TextEditingController controller =
                                      TextEditingController(
                                          text: 'Destination');
                                      destinationControllers.add(controller);
                                      multipleDestinations.add(controller.text);
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
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.8,
                                              controller: TextEditingController(
                                                text:
                                                multipleDestinations[index],
                                              ),
                                              hintText: 'Search Destination',
                                              onPress: () {
                                                _handlePressButtonDestination(
                                                    index);
                                              },
                                              onPlaceSelected:
                                                  (String placeName) {
                                                setState(() {
                                                  multipleDestinations[index] =
                                                      placeName;
                                                });
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                // Remove the corresponding marker from the _markers list
                                                MarkerId markerIdToRemove =
                                                MarkerId(
                                                    "destination ${index + 1}");
                                                _markers.removeWhere((marker) =>
                                                marker.markerId ==
                                                    markerIdToRemove);

                                                // Remove the corresponding destination from the destinations list
                                                multipleDestinations
                                                    .removeAt(index);
                                                setPolylines();
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
                                                color:
                                                ColorPalette.secondaryColor,
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

                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        ColorPalette.secondaryColor)),
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PlacesListAlongTheRoute(
                                            markers: _markers.toSet().toList(),
                                            // distancesAndTimes: distancesAndTimes,
                                            polylineCoordinates:
                                            tempPolylineCoordinates,
                                          ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Create Trip',
                                  style: TextStyle(
                                      color: ColorPalette.primaryColor),
                                ),
                              ),
                            )
                          ],
                        )
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
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                            _selectedPlaceTypes.contains(_placeTypes[index])
                                ? ColorPalette.primaryColor
                                : Colors.black,
                            backgroundColor:
                            _selectedPlaceTypes.contains(_placeTypes[index])
                                ? ColorPalette.secondaryColor
                                : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              if (_selectedPlaceTypes
                                  .contains(_placeTypes[index])) {
                                _selectedPlaceTypes.remove(_placeTypes[index]);
                              } else {
                                _selectedPlaceTypes.add(_placeTypes[index]);
                              }
                              updateMapWithSelectedPlaceType(
                                  _selectedPlaceTypes);
                            });
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: _selectedPlaceTypes
                                    .contains(_placeTypes[index]),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (_selectedPlaceTypes
                                        .contains(_placeTypes[index])) {
                                      _selectedPlaceTypes
                                          .remove(_placeTypes[index]);
                                    } else {
                                      _selectedPlaceTypes
                                          .add(_placeTypes[index]);
                                    }
                                    updateMapWithSelectedPlaceType(
                                        _selectedPlaceTypes);
                                  });
                                },
                              ),
                              Text(_placeTypes[index]),
                            ],
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
                          infoWindow:
                          const InfoWindow(title: "Current Location"),
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


            Positioned(
              bottom: 30,
              left: 10,
              child: ElevatedButton(
                onPressed: () {
                  _clearMap();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorPalette
                      .secondaryColor, // Change the button color here
                ),
                child: const Text(
                  'Clear Markers',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            if (!showSearchField)
              Positioned(
                top: 30,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLegendOpen =
                      !isLegendOpen; // Toggles the isLegendOpen boolean
                    });
                  },

                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text('Legend',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                        if (isLegendOpen) ...[
                          // Only show these widgets if isLegendOpen is true
                          const Divider(),
                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/park.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text(
                                  'Tourist Attraction'),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/gas-station.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Gas Station'),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/restaurant.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Restaurant'),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/cafe.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Cafe'),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/hospital.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Hospital'),
                            ],
                          ),
                          const Divider(),


                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/airport.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Airport'),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/atm-card.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('ATM'),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/parking-area.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Parking'),
                            ],
                          ),
                          const Divider(),

                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/police-station.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Police station'),
                            ],
                          ),
                          const Divider(),



                          Row(
                            children: <Widget>[
                              Image.asset('assets/markers/stadium.png', width: 24, height: 24),
                              const SizedBox(width: 10),
                              const Text('Stadium'),
                            ],
                          ),
                          const Divider(),
                          // Row(
                          //   children: <Widget>[
                          //     Image.asset('assets/markers/atm-card.png', width: 24, height: 24), // Default icon for 'Others'
                          //     const SizedBox(width: 10),
                          //     const Text('Others'),
                          //   ],
                          // ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
