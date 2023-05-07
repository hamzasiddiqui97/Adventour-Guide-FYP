// lib/models/booking.dart



class Booking {
  final String id;
  final String userId;
  final String vehicleId;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime bookingDate;

  Booking({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.bookingDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'vehicleId': vehicleId,
      'pickupLocation': pickupLocation,
      'dropoffLocation': dropoffLocation,
      'bookingDate': bookingDate.toIso8601String(),
    };
  }

  factory Booking.fromMap({required String id, required Map<String, dynamic> data}) {
    return Booking(
      id: id,
      userId: data['userId'],
      vehicleId: data['vehicleId'],
      pickupLocation: data['pickupLocation'],
      dropoffLocation: data['dropoffLocation'],
      bookingDate: DateTime.parse(data['bookingDate']),
    );
  }
}
