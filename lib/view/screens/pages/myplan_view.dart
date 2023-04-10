import 'package:flutter/material.dart';
import '../../../core/constant/color_constants.dart';

class MyPlan extends StatefulWidget {
  final String uid;

  const MyPlan({Key? key, required this.uid}) : super(key: key);

  @override
  State<MyPlan> createState() => _MyPlanState();
}

class _MyPlanState extends State<MyPlan> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: ColorPalette.secondaryColor,
          foregroundColor: ColorPalette.primaryColor,
          title: const Text('My Trips'),
          centerTitle: true,
        ),
        body: const Center(child: Text('Nothing to Show')),
        // body: StreamBuilder<DatabaseEvent>(
        //   stream: AddPlacesToFirebaseDb.getPlacesStream(widget.uid),
        //   builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
        //     if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
        //       Map<dynamic, dynamic> values =
        //       snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        //       List<dynamic> places = values.values.toList();
        //       return ListView.builder(
        //         itemCount: places.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           return Card(
        //             child: ListTile(
        //               title: Text(places[index]['name']),
        //               subtitle: Text(places[index]['address']),
        //               trailing: IconButton(
        //                 icon: Icon(Icons.delete),
        //                 onPressed: () {
        //                   AddPlacesToFirebaseDb.deletePlace(widget.uid, places[index]['key']);
        //                 },
        //               ),
        //             ),
        //           );
        //         },
        //       );
        //     } else {
        //       return Center(
        //         child: Text('No places saved'),
        //       );
        //     }
        //   },
        // ),
      ),
    );
  }
}
