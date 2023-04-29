import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMapForTrip extends StatefulWidget {

  const ViewMapForTrip({Key? key,this.list,this.title}) : super(key: key);
  final List<LatLng>? list;
  final String? title;

  @override
  State<ViewMapForTrip> createState() => _ViewMapForTripState();
}

class _ViewMapForTripState extends State<ViewMapForTrip> {
  void _createPolyline(List<LatLng> points) {
    Polyline polyline = Polyline(
      polylineId: PolylineId("route"),
      color: ColorPalette.secondaryColor,
      points: points,
      width: 5,
    );
    setState(() {
      _polylines.add(polyline);
    });
  }

  Set<Marker> createMarkers(List<LatLng> points) {
    Set<Marker> markers = {};
    for (int i = 0; i < points.length; i++) {
      markers.add(Marker(
        markerId: MarkerId('marker${i+1}'),
        position: points[i],
        infoWindow: InfoWindow(title: 'Place ${i+1}'),
      ));
    }
    return markers;
  }

  late GoogleMapController _mapController;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    if (widget.list != null) {
      // widget.list!.sort((a, b) => (a['sequence'] as int).compareTo(b['sequence'] as int));
      _markers = createMarkers(widget.list!);
    }  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
        backgroundColor: ColorPalette.secondaryColor,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.list!.first,
          zoom: 13,
        ),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) async {
          _mapController = controller;
          await _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: widget.list!.first,
                zoom: 13,
              ),
            ),
          );
          _createPolyline(widget.list!);
        },
        polylines: _polylines,
      ),
    );
  }
}
