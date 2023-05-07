// lib/providers/booking_provider.dart

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:google_maps_basics/model/booking.dart';

class BookingProvider with ChangeNotifier {
  Map<String, Booking> _bookings = {};

  Map<String, Booking> get bookings {
    return {..._bookings};
  }

  // Add the bookTransport method
  void bookTransport({
    required String vehicleId,
    required String pickupLocation,
    required String dropoffLocation,
  }) {
    final newBooking = Booking(
      id: Random().nextInt(1000000).toString(),
      userId: 'someUserId', // Replace with the actual user ID
      vehicleId: vehicleId,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      bookingDate: DateTime.now(),
    );

    _bookings.putIfAbsent(newBooking.id, () => newBooking);
    notifyListeners();
  }
}
