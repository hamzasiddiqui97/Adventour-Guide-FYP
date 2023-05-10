import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/hotelOwnerController.dart';
import 'package:google_maps_basics/controllers/mainController.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/custom_grid_view.dart';
import 'package:google_maps_basics/model/firebase_reference.dart';
import 'package:google_maps_basics/view/screens/views/addProperty.dart';
import 'package:http/http.dart' as http;
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../helper/utils.dart';
import '../../../models/weather.dart';
import '../../../snackbar_utils.dart';
import '../views/hotel_post_detail_page.dart';
import '../views/hotel_post_details_tourist_view.dart';

class HomePageNavBar extends StatefulWidget {
  const HomePageNavBar({Key? key}) : super(key: key);

  @override
  _HomePageNavBarState createState() => _HomePageNavBarState();
}

class _HomePageNavBarState extends State<HomePageNavBar> {
  final MainController mainController = Get.put(MainController());
  final HotelOwnerController hotelOwnerController =
      Get.put(HotelOwnerController());
  // weather api
  String apiKey = '97f6f37816c2c554f9f209bd1b7b7afe';
  Weather? _weather;
  bool _isWeatherDataLoading = true;
  bool _isRequestError = false;
  bool _isLocationError = false;
  late bool roleLoading;


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
  void initState() {
    super.initState();

    _fetchWeather();
    _initializeRole();

  }

  void _initializeRole() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    setState(() {
      roleLoading = true; // set _isLoading to true before fetching data
    });
    try {
      final userRole = await AddPlacesToFirebaseDb().getUserRole(uid);
      mainController.role.value = userRole;
      print('main controooolllllll: ${mainController.role.value}');
      print('shared prrrrrr: $userRole');
      if (userRole == 'Tourist') {
        await AddPlacesToFirebaseDb.getAllHotelPosts();
      } else if (userRole == 'Hotel Owner') {
        await AddPlacesToFirebaseDb.getPersonalHotelPost(uid);
      }
      setState(() {
        roleLoading = false; // set _isLoading to false after fetching data
      });
    } catch (e) {
      print('Error getting user role: $e');
      setState(() {
        roleLoading = false; // set _isLoading to false even if there is an error
      });
    }
  }


  @override
  Widget build(BuildContext context) {
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
          body: roleLoading ? const Center(child: CircularProgressIndicator(),)
              : mainController.role.value == "Tourist" ? SingleChildScrollView(
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
                            offset: const Offset(0.0, 2.0),
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
                    const Center(
                      child: Text(
                        'Explore',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const CustomGrid(),
                    const SizedBox(
                      height: 30,
                    ),
                    const Center(
                      child: Text(
                        'Hotels',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotelOwnerController.propertyList.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (kDebugMode) {
                            print('hotelOwnerController propertyList length: ${hotelOwnerController.propertyList.length}');
                          }

                          var property =
                          hotelOwnerController.propertyList[index];

                          return GestureDetector(
                            onTap: () {
                              Get.to(() =>


                                  HotelPostDetailsTouristPage(property: property));
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 5.0,
                                    spreadRadius: 0.0,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Card(
                                child: Stack(
                                  children: [
                                    // Display the image
                                    property.coverImage != null
                                        ? SizedBox(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      height: 65.w,
                                      child: Image.network(
                                        property.coverImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                        : const SizedBox.shrink(),
                                    // Display the hotel title at the bottom
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      child: InkWell(
                                        onTap: () {
                                          Utils.showSnackBar('Tap', true);
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width,
                                          padding: const EdgeInsets.all(8.0),
                                          color: Colors.white,
                                          child: Text(
                                            property.title,
                                            style: const TextStyle(
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: 30,
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),



                  ],
                ),
              )
              : mainController.role.value == "Hotel Owner" ?  SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 2.h,
                      ),
                      const Text('Your Posts',style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),),
                      // List of cards
                      Expanded(
                        child: ListView.builder(
                          itemCount: hotelOwnerController.propertyList.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (kDebugMode) {
                              print('hotelOwnerController propertyList length: ${hotelOwnerController.propertyList.length}');
                            }

                            var property =
                                hotelOwnerController.propertyList[index];


                            return GestureDetector(
                              onTap: () {
                                Get.to(() =>
                                    HotelPostDetailsPage(property: property));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      blurRadius: 5.0,
                                      spreadRadius: 0.0,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  child: Stack(
                                    children: [
                                      // Display the image
                                      property.coverImage != null
                                          ? SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 65.w,
                                              child: Image.network(
                                                property.coverImage!,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                      // Display the hotel title at the bottom
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        child: InkWell(
                                          onTap: () {
                                            Utils.showSnackBar('Tap', true);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: Text(
                                              property.title,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 30,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      ),

                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(
                                    () => PropertyAdd(),
                              );
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    ColorPalette.secondaryColor),
                                foregroundColor: MaterialStateProperty.all(
                                    ColorPalette.primaryColor)),
                            child: const Text(
                              'List Your Hotel',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
            child: const Center(child: Text('An error Occured please try logging in again.')),
          ),
        ),
      ),
    );
  }
}
