import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesListAlongTheRoute extends StatefulWidget {
  final List<Marker> markers;

  const PlacesListAlongTheRoute({Key? key, required this.markers})
      : super(key: key);

  @override
  _PlacesListAlongTheRouteState createState() =>
      _PlacesListAlongTheRouteState();
}

class _PlacesListAlongTheRouteState extends State<PlacesListAlongTheRoute> {
  @override
  Widget build(BuildContext context) {
    print('Markers in PlacesListAlongTheRoute: ${widget.markers.length}');

    if (widget.markers.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(title: const Text('Points')),
          body: const Center(child: Text('No points found')),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Points'),
        ),
        body: ListView.builder(
          itemCount: widget.markers.length,
          itemBuilder: (context, index) {
            final marker = widget.markers.elementAt(index);
            return Card(
              margin: const EdgeInsets.all(8),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      marker.infoWindow.title ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      marker.infoWindow.snippet ?? 'No vicinity information',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        // Add your logic to add the place to the trip
                      },
                      child: const Text('Add place to trip'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
