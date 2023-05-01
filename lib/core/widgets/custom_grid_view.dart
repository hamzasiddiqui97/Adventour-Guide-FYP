import 'package:flutter/material.dart';
import 'package:google_maps_basics/view/screens/views/news_view.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/provider/weatherProvider.dart';
import 'package:google_maps_basics/widgets/sevenDayForecast.dart';
import '../../view/screens/views/nearby_places_list.dart';
import '../../view/screens/views/search_nearby_restaurant.dart';

class CustomGrid extends StatelessWidget {
  const CustomGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    const double iconSize = 40;


    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey.shade100),
      height: 450,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(22.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,

                      ),

                      height: 80,
                      width: 80,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NearByPlacesScreen()),
                          );
                        },
                        icon: const Icon(
                          Icons.near_me, color: ColorPalette.secondaryColor,
                          size: iconSize,),),
                    ),
                    const Text('Near Me', textAlign: TextAlign.center),

                  ],
                ),
                // Column(
                //   children: [
                //     Container(
                //       color: Colors.white,
                //       child: IconButton(
                //         onPressed: () {},
                //         icon: const Icon(Icons.route, color: ColorPalette.secondaryColor,
                //           size: iconSize,),),
                //     ),
                //     const Text('Packages', textAlign: TextAlign.center),
                //   ],
                // ),
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,

                      ),


                      height: 80,
                      width: 80,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewsScreen()),
                          );
                        },
                        icon: const Icon(Icons.newspaper,
                          color: ColorPalette.secondaryColor, size: iconSize,),),
                    ),
                    const Text('News', textAlign: TextAlign.center,),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,

                      ),


                      height: 80,
                      width: 80,
                      child: IconButton(
                        onPressed: () {
                          // _currentLocation();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NearbyRestaurantSource()),
                          );
                        },
                        icon: const Icon(
                          Icons.restaurant, color: ColorPalette.secondaryColor,
                          size: iconSize,),),
                    ),
                    const Text('Restaurant', textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: [
                    Container(

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,

                      ),

                      height: 80,
                      width: 80,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => Provider<WeatherProvider>(
                                create: (context) => WeatherProvider(),
                                child: viewfront()
                            ),
                          ));
                        },
                        icon: const Icon(
                          Icons.sunny_snowing, color: ColorPalette.secondaryColor,
                          size: iconSize,),),
                    ),
                    const Text(''
                        'Weather ', textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,

                      ),

                      height: 80,
                      width: 80,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_transportation,
                          color: ColorPalette.secondaryColor, size: iconSize,),),
                    ),
                    const Text('Transport', textAlign: TextAlign.center),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}