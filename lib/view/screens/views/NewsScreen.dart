import 'package:flutter/material.dart';
import 'package:google_maps_basics/provider/weatherProvider.dart';
import 'package:google_maps_basics/widgets/WeatherInfo.dart';
import 'package:google_maps_basics/widgets/fadeIn.dart';
import 'package:google_maps_basics/widgets/hourlyForecast.dart';
import 'package:google_maps_basics/widgets/locationError.dart';
import 'package:google_maps_basics/widgets/mainWeather.dart';
import 'package:google_maps_basics/widgets/requestError.dart';
import 'package:google_maps_basics/widgets/sevenDayForecast.dart';
import 'package:google_maps_basics/widgets/weatherDetail.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../widgets/searchBar.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({ Key?key }): super(key:key);
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  PageController _pageController = PageController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> _getData() async {
    _isLoading = true;
    final weatherData = Provider.of<WeatherProvider>(context, listen: false);
    weatherData.getWeatherData();
    _isLoading = false;
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<WeatherProvider>(context, listen: false)
        .getWeatherData(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Consumer<WeatherProvider>(
          builder: (context, weatherProv, _) {
            if (weatherProv.isLocationError) {
              return LocationError();
            }
            if (weatherProv.isRequestError) {
              return RequestError();
            }
            return Column(
              children: [
                SearchBarWeather(),
                Center(
                  child: SmoothPageIndicator(
                    controller: _pageController,
                    count: 2,
                    effect: ExpandingDotsEffect(
                      activeDotColor: themeContext.primaryColor,
                      dotHeight: 6,
                      dotWidth: 6,
                    ),
                  ),
                ),
                _isLoading || weatherProv.isLoading
                    ? Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            backgroundColor: themeContext.primaryColor,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : Expanded(
                        child: PageView(
                          physics: BouncingScrollPhysics(),
                          controller: _pageController,
                          children: [
                            // First Page of the Page View
                            RefreshIndicator(
                              onRefresh: () async => _refreshData(context),
                              child: ListView(
                                padding: const EdgeInsets.all(10),
                                shrinkWrap: true,
                                children: [
                                  FadeIn(
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 250),
                                    child: MainWeather(),
                                  ),
                                  FadeIn(
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 500),
                                    child: WeatherInfo(),
                                  ),
                                  FadeIn(
                                    curve: Curves.easeIn,
                                    duration: Duration(milliseconds: 750),
                                    child: HourlyForecast(),
                                  ),
                                ],
                              ),
                            ),
                            // Second Page of the Page View
                            ListView(
                              padding: const EdgeInsets.all(10),
                              children: [
                                FadeIn(
                                  curve: Curves.easeIn,
                                  duration: Duration(milliseconds: 250),
                                  child: SevenDayForecast(),
                                ),
                                const SizedBox(height: 16.0),
                                FadeIn(
                                  curve: Curves.easeIn,
                                  duration: Duration(milliseconds: 500),
                                  child: WeatherDetail(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
