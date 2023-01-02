import 'package:flutter/material.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/core/widgets/search_bar_widget.dart';

class HomePageNavBar extends StatelessWidget {
  const HomePageNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: ColorPalette.primaryColor,
            expandedHeight: 100,
          flexibleSpace: FlexibleSpaceBar(

            background: Padding(
              padding: EdgeInsets.only(top: 20,),
              child: SearchBar(onPress: (){}),
            ),
          ),
          ),
          SliverList(
              delegate:SliverChildBuilderDelegate((context, index) {
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    width: 50,
                    child: const Placeholder(),

                  ),
                  title: Text("Place ${index+1}", textScaleFactor: 2,),
                );
              },
                  childCount: 20,)
          )
        ],

      )
    );
  }
}
