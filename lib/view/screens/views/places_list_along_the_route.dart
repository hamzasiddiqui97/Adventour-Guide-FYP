import 'package:flutter/material.dart';
import 'package:google_maps_webservice/places.dart';


class PlacesListAlongTheRoute extends StatefulWidget {
  final List<PlacesSearchResult> points;

  const PlacesListAlongTheRoute({Key? key, required this.points})
      : super(key: key);

  @override
  _PlacesListAlongTheRouteState createState() =>
      _PlacesListAlongTheRouteState();
}

class _PlacesListAlongTheRouteState extends State<PlacesListAlongTheRoute> {
  @override
  void initState() {
    super.initState();
    print('Points in PlacesListAlongTheRoute: ${widget.points.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tourist Attractions'),
      ),
      body: ListView(
        children: widget.points.map((place) {
          return ListTile(
            title: Text(place.name),
            subtitle: Text(place.vicinity ?? ''),
          );
        }).toList(),
      ),
    );
  }
}
