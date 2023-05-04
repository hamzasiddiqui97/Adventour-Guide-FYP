import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_basics/distanceWrapper.dart' as dw;
import 'package:dio/dio.dart';

import '../../../core/widgets/customInfoWindowGoogleMaps.dart';
import '../../../distanceWrapper.dart';

class ViewMapForTrip extends StatefulWidget {
  const ViewMapForTrip(
      {Key? key, this.list, this.title, required this.tempPlaces})
      : super(key: key);
  final List<LatLng>? list;
  final String? title;

  final Map<int, dynamic> tempPlaces;

  @override
  State<ViewMapForTrip> createState() => _ViewMapForTripState();
}

class _ViewMapForTripState extends State<ViewMapForTrip> {


  String formattedDistance = '';
  String formattedTime = '';

  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  List<LatLng>? _sortedList;
  List<dw.Element?> distancesList = [];

  @override
  void initState() {
    super.initState();
    if (widget.list != null) {
      List<dynamic> tempPlacesList = widget.tempPlaces.values.toList();
      tempPlacesList.sort((a, b) => a['sequence'].compareTo(b['sequence']));
      _sortedList = tempPlacesList
          .map((point) => LatLng(point['latitude'], point['longitude']))
          .toList();
      _calculateDistances(_sortedList!).then((_) {
        setState(() {
          _markers = createMarkers(_sortedList!, distancesList);
        });
      });
    }
  }

  Future<void> _createPolyline(List<LatLng> points) async {
    if (_sortedList == null || _sortedList!.isEmpty) {
      return;
    }

    List<LatLng> polylineCoordinates = await _getDirections(points);

    Polyline polyline = Polyline(
      polylineId: const PolylineId("route"),
      color: ColorPalette.secondaryColor,
      points: polylineCoordinates,
      width: 5,
    );

    // Calculate the bounds of the polyline coordinates
    double minLat = polylineCoordinates.first.latitude;
    double maxLat = polylineCoordinates.first.latitude;
    double minLng = polylineCoordinates.first.longitude;
    double maxLng = polylineCoordinates.first.longitude;
    for (LatLng point in polylineCoordinates) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    // Animate the camera to show the entire polyline
    if (polylineCoordinates.isNotEmpty) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );
      _mapController.animateCamera(
        CameraUpdate.newLatLngBounds(
          bounds,
          50.0, // Padding
        ),
      );
    }

    setState(() {
      _polylines.add(polyline);
    });
  }

  Set<Marker> createMarkers(
      List<LatLng> points, List<dw.Element?> distancesList) {
    Set<Marker> markers = {};
    for (int i = 0; i < points.length; i++) {
      var place = widget.tempPlaces.values.toList().firstWhere(
            (place) =>
                place['latitude'] == points[i].latitude &&
                place['longitude'] == points[i].longitude,
          );
      int sequence = place['sequence'];
      String name = place['name'];

      String nextPlaceName;
      if (i < points.length - 1) {
        var nextPlace = widget.tempPlaces.values.toList().firstWhere(
              (place) => place['sequence'] == sequence + 1,
            );
        nextPlaceName = nextPlace['name'];
      } else {
        nextPlaceName = 'Destination';
      }

      String distance = i == 0
          ? (distancesList[i]?.distance?.text ?? 'Unknown')
          : (i == points.length - 1
              ? 'N/A'
              : (distancesList[i - 1]?.distance?.text ?? 'Unknown'));
      String duration = i == 0
          ? (distancesList[i]?.duration?.text ?? 'Unknown')
          : (i == points.length - 1
              ? 'N/A'
              : (distancesList[i - 1]?.duration?.text ?? 'Unknown'));

      markers.add(Marker(
        markerId: MarkerId('marker$sequence'),
        position: points[i],
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return SizedBox(
                height: 300,
                child: CustomInfoWindow(
                  title: 'Place $sequence: $name',
                  distance: distance,
                  duration: duration,
                  nextPlaceName: nextPlaceName,
                ),
              );
            },
          );
        },
      ));
    }
    return markers;
  }

  Future<List<LatLng>> _getDirections(List<LatLng> points) async {
    List<LatLng> polylineCoordinates = [];
    String waypoints = '';

    for (int i = 1; i < points.length - 1; i++) {
      waypoints += '${points[i].latitude},${points[i].longitude}|';
    }

    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${points.first.latitude},${points.first.longitude}&destination=${points.last.latitude},${points.last.longitude}&waypoints=optimize:true|${waypoints}&key=$googleApiKey';
    http.Response response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['routes'].isNotEmpty) {
        String encodedPolyline =
            jsonResponse['routes'][0]['overview_polyline']['points'];
        polylineCoordinates = PolylinePoints()
            .decodePolyline(encodedPolyline)
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();
      }
    }

    return polylineCoordinates;
  }

  Dio dio = Dio();

  Future<DistanceWrapper?> distance(
      {required LatLng origin, required LatLng destination}) async {
    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${origin.latitude},${origin.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$googleApiKey',
    );
    DistanceWrapper distanceWrapper = DistanceWrapper.fromJson(response.data);
    return distanceWrapper;
  }

  Future<void> _calculateDistances(List<LatLng> points) async {
    distancesList.clear();

    for (int i = 0; i < points.length; i++) {
      LatLng origin = points[i];
      LatLng destination = points[(i + 1) % points.length];

      DistanceWrapper? distanceWrapper =
          await distance(origin: origin, destination: destination);

      if (distanceWrapper != null && distanceWrapper.status == 'OK') {
        dw.Element? element = distanceWrapper.rows?.first?.elements?.first;
        distancesList.add(element);
      } else {
        print('Error: ${distanceWrapper?.status}');
        distancesList.add(null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    num totalDistance = distancesList
        .where((element) => element != null)
        .map((element) => element!.distance!.value)
        .fold<num>(0, (a, b) => a + b!);

    num totalTime = distancesList
        .where((element) => element != null)
        .map((element) => element!.duration!.value)
        .fold<num>(0, (a, b) => a + b!);

    String formattedDistance = totalDistance >= 1000
        ? '${(totalDistance / 1000).toStringAsFixed(2)} km'
        : '${totalDistance.toInt()} m';

    int totalTimeInHours = (totalTime / 3600).floor();
    int totalTimeInMinutes = ((totalTime % 3600) / 60).floor();
    num totalTimeInSeconds = totalTime % 60;
    formattedTime = '${totalTimeInHours}h ${totalTimeInMinutes}m ${totalTimeInSeconds}s';

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title ?? 'Map'),
            backgroundColor: ColorPalette.secondaryColor,
            foregroundColor: ColorPalette.primaryColor,
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: widget.list?.first ?? const LatLng(0, 0),
                  zoom: 13,
                ),
                markers: _markers,
                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;
                  if (_sortedList != null) {
                    // print('Creating polyline with points: ${widget.list}');
                    print('Creating polyline with _sortedList: ${_sortedList}');

                    await _mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: _sortedList!.first,
                          zoom: 13,
                        ),
                      ),
                    );
                    _createPolyline(_sortedList!);
                  }
                },
                polylines: _polylines,
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Distance: $formattedDistance',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Total Time: $formattedTime',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
