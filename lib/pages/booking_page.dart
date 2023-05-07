import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_basics/provider/booking_provider.dart';

class BookingPage extends StatefulWidget {
  final String? vehicleId;

  BookingPage({this.vehicleId});

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  TextEditingController _pickupLocationController = TextEditingController();
  TextEditingController _dropoffLocationController = TextEditingController();
  String? _pickupLocation;
  String? _dropoffLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _pickupLocationController,
                decoration: InputDecoration(labelText: 'Pickup Location'),
                onChanged: (value) {
                  setState(() {
                    _pickupLocation = value;
                  });
                },
              ),
              TextField(
                controller: _dropoffLocationController,
                decoration: InputDecoration(labelText: 'Dropoff Location'),
                onChanged: (value) {
                  setState(() {
                    _dropoffLocation = value;
                  });
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickupLocation?.isEmpty == true || _dropoffLocation?.isEmpty == true
                    ? null
                    : () {
                  final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
                  bookingProvider.bookTransport(
                    vehicleId: widget.vehicleId!,
                    pickupLocation: _pickupLocation!,
                    dropoffLocation: _dropoffLocation!,
                  );
                },
                child: Text('Book Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
