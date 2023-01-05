import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_basics/.env.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/NearbyResponse.dart';
import 'package:http/http.dart' as http;

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {

  String apiKey = googleApiKey;
  String radius = "50";
  String placeType = 'bank';

  double latitude =  24.921780;
  double longitude = 67.117981;

  final placeTypes = ['All','gas_station', 'restaurant', 'cafe', 'bank', 'atm'];

  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  void setRadius(String newRadius) {
    setState(() {
      radius = newRadius;
    });
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.secondaryColor,
          title: const Text('Nearby Places',style: TextStyle(color: ColorPalette.primaryColor),),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text('Area Type:'),
                    DropdownButton(
                      hint: Text(placeType == '' ? 'All' : placeType),
                      items: placeTypes.map((placeType) => DropdownMenuItem(
                        value: placeType == 'All' ? '' : placeType,
                        child: Text(placeType),
                      )).toList(),

                      onChanged: (String? newPlaceType) {
                        setState(() => placeType = newPlaceType!);
                      },
                      enableFeedback: true,
                    ),

                  ],
                ),

                Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: TextField(

                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorPalette.secondaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: Icon(Icons.radar,color: ColorPalette.secondaryColor),
                      hintText: "Enter radius",
                      contentPadding: EdgeInsets.all(20),
                    ),
                    onChanged: (newRadius) => setRadius(newRadius),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorPalette.secondaryColor)),

                  onPressed: (){

                  getNearbyPlaces();

                },

                  child: const Text("Nearby Places",
                    style: TextStyle(
                        color: ColorPalette.primaryColor,
                    ),

                  ),
                ),
                if(nearbyPlacesResponse.results == null || nearbyPlacesResponse.results!.isEmpty)
                  const Center(child: Text("No results found")),
                if(nearbyPlacesResponse.results != null)
                  for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
                    nearbyPlacesWidget(nearbyPlacesResponse.results![i]),
              ],

            ),
          ),
        ),
      ),
    );
  }

  // if radius value is negative this will show up on screen
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorPalette.secondaryColor)),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK',style: TextStyle(color: ColorPalette.primaryColor),),

            ),
          ],
        );
      },
    );
  }
  void getNearbyPlaces() async {

      if (radius == null || radius.isEmpty || double.tryParse(radius) == null || double.parse(radius) <= 0) {
        showErrorDialog('Please enter a valid radius');
        return;
      }

    // for specific area type       &type=gas_station
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=$radius&type=$placeType&key=$apiKey');

    var response = await http.post(url);

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});
  }

  Widget nearbyPlacesWidget(Results results) {

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(border: Border.all(color: ColorPalette.secondaryColor),borderRadius: BorderRadius.circular(10)),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${results.name!}"),
            // Text("Location: ${results.geometry!.location!.lat} , ${results.geometry!.location!.lng}"),
            Text("""Place Status: ${results.openingHours != null ? "Open" : "Closed"}"""),
            Center(
              child: ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(ColorPalette.secondaryColor)),
                  onPressed: (){  },
                  child: const Text('Navigate')),
            ),

          ],
        ),


      ),

    );



  }

}