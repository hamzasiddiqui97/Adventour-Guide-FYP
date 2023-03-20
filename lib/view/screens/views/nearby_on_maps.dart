import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapsViewScreen extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String title;

  MapsViewScreen({required this.latitude, required this.longitude,required this.title});

  @override
  _MapsViewScreenState createState() => _MapsViewScreenState();
}

class _MapsViewScreenState extends State<MapsViewScreen> {
  late GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        color: Colors.white,
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
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("selected_place"),
                  position: LatLng(widget.latitude, widget.longitude),
                  infoWindow: InfoWindow(
                    title: widget.title,
                  ),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    _mapController.dispose();
    return true;
  }
}
