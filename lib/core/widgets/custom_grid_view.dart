import 'package:flutter/material.dart';
import 'package:google_maps_basics/view/screens/views/news_view.dart';
import 'package:provider/provider.dart';

import 'package:google_maps_basics/Screens/weeklyWeatherScreen.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/screens/homeScreen.dart';
import 'package:google_maps_basics/provider/weatherProvider.dart';
import 'package:google_maps_basics/widgets/sevenDayForecast.dart';


class CustomGrid extends StatelessWidget {
  const CustomGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return Container(
      color: Colors.white,
      height: 250,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.hotel, color: ColorPalette.secondaryColor,
                          size: 30,),),
                    ),
                    const Text('Hotel', textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.route, color: ColorPalette.secondaryColor,
                          size: 30,),),
                    ),
                    const Text('Packages', textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewsScreen()),
                          );
                        },
                        icon: const Icon(Icons.newspaper,
                          color: ColorPalette.secondaryColor, size: 30,),),
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
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.restaurant, color: ColorPalette.secondaryColor,
                          size: 30,),),
                    ),
                    const Text('Restaurant', textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.white,
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
                          size: 30,),),
                    ),
                    const Text(''
                        'Weather ', textAlign: TextAlign.center),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.emoji_transportation,
                          color: ColorPalette.secondaryColor, size: 30,),),
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