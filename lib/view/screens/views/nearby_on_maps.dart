import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';


class MapsViewScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;

  final String rating;
  final String vicinity;

  MapsViewScreen({required this.latitude, required this.longitude,required this.title, required this.rating, required this.vicinity});

  @override
  _MapsViewScreenState createState() => _MapsViewScreenState();
}

class _MapsViewScreenState extends State<MapsViewScreen> {
  late GoogleMapController _mapController;

  void shareGoogleMaps(double latitude, double longitude) {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    Share.share(googleMapsUrl);
  }
  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Set<Marker> _createMarker() {
      return <Marker>{
        Marker(
          markerId: MarkerId('place_marker'),
          position: LatLng(widget.latitude, widget.longitude),
          infoWindow: InfoWindow(
            title: widget.title,
            snippet: '${widget.vicinity} And Rating: ${widget.rating} ',
          ),
        ),
      };
    }


    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorPalette.secondaryColor,
            foregroundColor: ColorPalette.primaryColor,
            centerTitle: true,
            title: const Text('Near You'),
          ),
          body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.latitude, widget.longitude),
              zoom: 13,
            ),
            // markers: {
            //   Marker(
            //     markerId: const MarkerId("selected_place"),
            //     position: LatLng(widget.latitude, widget.longitude),
            //     infoWindow: InfoWindow(
            //       title: widget.title,
            //     ),
            //   ),
            // },,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _createMarker(),
          ),
        ),
      ),
    );
  }
}
