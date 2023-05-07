import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/mainController.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/custom_grid_view.dart';
import 'package:google_maps_basics/view/screens/views/addProperty.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../helper/utils.dart';
import '../../../models/weather.dart';

class HomePageNavBar extends StatefulWidget {
  const HomePageNavBar({Key? key}) : super(key: key);

  @override
  _HomePageNavBarState createState() => _HomePageNavBarState();
}

class _HomePageNavBarState extends State<HomePageNavBar> {
  // weather api
  String apiKey = '97f6f37816c2c554f9f209bd1b7b7afe';
  Weather? _weather;
  bool _isWeatherDataLoading = true;
  bool _isRequestError = false;
  bool _isLocationError = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    final position = await _determinePosition();
    if (position == null) {
      // Location services are not enabled or permission is denied
      setState(() {
        _isWeatherDataLoading = false;
        _isLocationError = true;
      });
      return;
    }

    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric'));

    if (mounted && response.statusCode == 200) {
      setState(() {
        _isWeatherDataLoading = false;
        final jsonData = json.decode(response.body);
        _weather = Weather.fromJson(jsonData);
      });
    } else if (mounted) {
      setState(() {
        _isWeatherDataLoading = false;
        _isRequestError = true;
      });
      throw Exception('Failed to load weather data');
    }
    if (kDebugMode) {
      print('weather response: ${response.body}');
      print('city name: ${_weather?.cityName}');
      print('city temperature: ${_weather?.temp}');
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return null;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return null;
    }
    // Get current location
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.put(MainController());
    const TextStyle myTextStyle = TextStyle(
      fontSize: 25,
      color: Colors.black,
      fontWeight: FontWeight.normal,
    );
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: mainController.role.value == "Tourist"
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade50,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        // color: Colors.orange,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isWeatherDataLoading)
                              const Center(child: CircularProgressIndicator()),
                            if (!_isWeatherDataLoading && _weather != null)
                              Text(
                                _weather!.cityName,
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
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const CustomGrid(),
                    ],
                  ),
                )
              : SafeArea(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 3,
                              spreadRadius: 0,
                              offset: Offset(0.0, 2.0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey.shade50,
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        // color: Colors.orange,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isWeatherDataLoading)
                              const Center(child: CircularProgressIndicator()),
                            if (!_isWeatherDataLoading && _weather != null)
                              Text(
                                _weather!.cityName,
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
                      ),
                      SizedBox(height: 2.h,),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                              () => PropertyAdd(),
                            );
                          },
                          child: const Text(
                            'Post data',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
