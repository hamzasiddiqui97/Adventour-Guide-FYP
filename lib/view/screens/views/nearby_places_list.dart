import 'package:flutter/material.dart';

class SearchNearbyPlaces extends StatelessWidget {
  const SearchNearbyPlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby Places'),
      ),
      body: Container(child: Text("near by window"),),
    );
  }
}
