import 'package:flutter/material.dart';
import 'package:google_maps_basics/provider/weatherProvider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../newsServices/utils.dart';
import '../weatherScreens/homeScreen.dart';
import '../weatherScreens/hourlyWeatherScreen.dart';
import '../weatherScreens/weeklyWeatherScreen.dart';




class SevenDayForecast extends StatelessWidget {
  Widget dailyWidget(dynamic weather, BuildContext context) {
    final dayOfWeek = DateFormat('EEE').format(weather.date);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 7),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              dayOfWeek,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 20),
            child:
                MapString.mapStringToIcon(context, '${weather.condition}', 35),
          ),
          Text(
            '${weather.condition}',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15.0, left: 20.0),
          child: Text(
            'Next 7 Days',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15.0),
          child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(25.0),
              shrinkWrap: true,
              children: [
                Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '${weatherProv.weather.temp.toStringAsFixed(1)}°',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          MapString.mapInputToWeather(
                            context,
                            '${weatherProv.weather.currently}',
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: MapString.mapStringToIcon(
                          context,
                          '${weatherProv.weather.currently}',
                          45,
                        ),
                      ),
                    ],
                  );
                }),
                SizedBox(height: 15),
                Consumer<WeatherProvider>(builder: (context, weatherProv, _) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: weatherProv.sevenDayWeather
                          .map((item) => dailyWidget(item, context))
                          .toList(),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}




class viewfront extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeatherProvider(),
      child: MaterialApp(
        title: 'Flutter Weather',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(
              color: Colors.orange,
            ),
            elevation: 0,
          ),
          scaffoldBackgroundColor: Colors.white,
          primaryColor: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: Colors.white),
        ),
        home: HomeScreen(),
        routes: {
          WeeklyScreen.routeName: (myCtx) => WeeklyScreen(),
          HourlyScreen.routeName: (myCtx) => HourlyScreen(),
        },
      ),
    );
  }
}