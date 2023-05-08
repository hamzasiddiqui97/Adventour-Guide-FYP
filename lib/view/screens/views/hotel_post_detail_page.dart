import 'package:flutter/material.dart';
class HotelPostDetailsPage extends StatelessWidget {
  const HotelPostDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: const Text('Posting Details'),
          centerTitle: true),
    );
  }
}
