import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_basics/core/constant/color_constants.dart';
// import 'package:google_maps_basics/core/widgets/heading_text.dart';
import 'package:google_maps_basics/core/widgets/rounded_button.dart';
// import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';
import 'package:google_maps_basics/core/widgets/custom_grid_view.dart';
// import 'package:google_maps_basics/view/screens/pages/my_account.dart';
import 'package:google_maps_basics/view/screens/views/create_custom_trip.dart';
import 'package:location/location.dart';
import '../../../helper/utils.dart';
import '../../../models/weather.dart';



class HomePageNavBar extends StatefulWidget {



  const HomePageNavBar({Key? key}) : super(key: key);

  @override
  _HomePageNavBarState createState() => _HomePageNavBarState();
}


class _HomePageNavBarState extends State<HomePageNavBar> {


  String apiKey = '97f6f37816c2c554f9f209bd1b7b7afe';
  Weather? _weather;
  Location location = Location();
  bool _isWeatherDataLoading = true;

  @override
  void initState() {

    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        _fetchWeather();
      }
    });
  }


  Future<void> _fetchWeather() async {
    LocationData locationData = await location.getLocation();
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric'));
    if (mounted && response.statusCode == 200) {
      setState(() {
        _isWeatherDataLoading = false;
        final jsonData = json.decode(response.body);
        _weather = Weather.fromJson(jsonData);
      });
    } else if (mounted) {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {


    final List<Map<String, String>> destinations = [
      {
        'name': 'Amsterdam',
        'picture': 'https://www.example.com/amsterdam.jpg',
      },
      {
        'name': 'Barcelona',
        'picture': 'https://www.example.com/barcelona.jpg',
      },
      {
        'name': 'London',
        'picture': 'https://www.example.com/london.jpg',
      },
      {
        'name': 'Paris',
        'picture': 'https://www.example.com/paris.jpg',
      },
      {
        'name': 'Rome',
        'picture': 'https://www.example.com/rome.jpg',
      },
      {
        'name': 'Sydney',
        'picture': 'https://www.example.com/sydney.jpg',
      },
    ];

    const TextStyle myTextStyle = TextStyle(
      fontSize: 25,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    );

    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.end,
              //   children: [
              //     // SearchBar(hintText: 'Search', width: screenWidth / 1.3),
              //     IconButton(
              //         onPressed: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const MyAccount()),
              //           );
              //         },
              //         icon: const Icon(
              //           Icons.person,
              //           color: ColorPalette.secondaryColor,
              //           size: 40,
              //         ))
              //   ],
              // ),
              const SizedBox(
                height: 25,
              ),




              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isWeatherDataLoading)
                    Center(child: CircularProgressIndicator()),
                  if (!_isWeatherDataLoading && _weather != null)
                    Text(
                      "${_weather!.cityName}",
                      style: myTextStyle,
                    ),
                  const SizedBox(width: 10.0),

                  if (!_isWeatherDataLoading && _weather != null)
                    MapString.mapStringToIcon(
                    context,
                    '${_weather?.currently}',
                    30,
                  ),
                  const SizedBox(width: 10.0),
                  if (_weather != null)
                    Text(
                      "${_weather!.temp.round()} °C",
                      style: const TextStyle(
                        color: ColorPalette.secondaryColor,
                        fontSize: 25.0,
                      ),
                    ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const CustomGrid(),
              Center(
                  child: RoundedButton(
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateCustomTrip()),
                  );
                },
                name: 'Create Trip',
                textColor: Colors.white,
                color: ColorPalette.secondaryColor,
                width: 200,
              )),
              // HeadingText(
              //     text: "Destinations",
              //     style: const TextStyle(fontSize: 30, color: Colors.black)),
              // Container(
              //   height: 350,
              //   child: GridView.count(
              //     scrollDirection: Axis.vertical,
              //     crossAxisSpacing: 15.0,
              //     mainAxisSpacing: 15.0,
              //     shrinkWrap: true,
              //     crossAxisCount: 2,
              //     children: List.generate(
              //       destinations.length,
              //         (index) {
              //         return Card(
              //           child: Column(
              //             children: [
              //               Expanded(
              //                 child: Image.network(
              //                   destinations[index]['picture']!,
              //                   height: 150,
              //                   width: double.infinity,
              //                   fit: BoxFit.cover,
              //                 ),
              //               ),
              //               Text(
              //                 destinations[index]['name']!,
              //                 style: Theme.of(context).textTheme.headline4,
              //               ),
              //             ],
              //           ),
              //         );
              //         }
              //     ),
              //   ),
              // ),

            ],
          ),
        ),
      ),
    );
  }
}
