import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/model/NearbyResponse.dart';
import 'package:http/http.dart' as http;

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {

  String apiKey = googleApiKey;
  String radius = "30";

  double latitude =  24.921780;
  double longitude = 67.117981;

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){

              getNearbyPlaces();

            }, child: const Text("Nearby Gas Stations")),
            if(nearbyPlacesResponse.results == null || nearbyPlacesResponse.results!.isEmpty)
              const Center(child: Text("No results found")),
            if(nearbyPlacesResponse.results != null)
              for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
                nearbyPlacesWidget(nearbyPlacesResponse.results![i])
          ],
        ),
      ),
    );
  }

  void getNearbyPlaces() async {

    // for specific area type       &type=gas_station
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&key=$apiKey'
    );

    var response = await http.post(url);

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));



    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: ${results.name!}"),
          Text("Location: ${results.geometry!.location!.lat} , ${results.geometry!.location!.lng}"),
          Text(results.openingHours != null ? "Open" : "Closed"),
          ElevatedButton(onPressed: (){

          }, child: const Text('Navigate')),
        ],
      ),
    );

  }

}