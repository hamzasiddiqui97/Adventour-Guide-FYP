// lib/services/booking_service.dart

import 'dart:convert';
import 'package:firebase_database/firebase_database.dart' show DataSnapshot, FirebaseDatabase, DatabaseReference;
//import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_basics/model/booking.dart';
import 'package:google_maps_basics/model/user.dart';

class BookingService {
  final _dbRef = FirebaseDatabase.instance.reference();

  Future<void> createBooking(User user, String vehicleId, String pickupLocation, String dropoffLocation) async {
    final newBookingRef = _dbRef.child('bookings').push();
    final newBooking = Booking(
      id: newBookingRef.key!,
      userId: user.id,
      vehicleId: vehicleId,
      pickupLocation: pickupLocation,
      dropoffLocation: dropoffLocation,
      bookingDate: DateTime.now(),
    );

    await newBookingRef.set(newBooking.toMap());
  }

  Future<List<Booking>> getBookingsByUserId(String userId) async {
    final snapshot = await _dbRef.child('bookings').orderByChild('userId').equalTo(userId).get();
    if (snapshot.value != null) {
      final bookingsData = Map<String, dynamic>.from(snapshot.value as Map<String, dynamic>);
      final bookings = bookingsData.entries.map((entry) {
        final id = entry.key;
        final data = Map<String, dynamic>.from(entry.value);
        return Booking.fromMap(id: id, data: data);
      }).toList();
      return bookings;
    } else {
      return [];
    }
  }

// Add any other methods you may need for your app
}
