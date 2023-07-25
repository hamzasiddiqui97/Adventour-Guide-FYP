// lib/models/transport_owner.dart

import 'package:google_maps_basics/model/user.dart';

class TransportOwner extends User {
  final String companyName;
  final String contactNumber;

  TransportOwner({
    required String id,
    required String email,
    required this.companyName,
    required this.contactNumber,
  }) : super(id: id, email: email, isTransportOwner: true);

  factory TransportOwner.fromMap(String id, Map<String, dynamic> data) {
    return TransportOwner(
      id: id,
      email: data['email'],
      companyName: data['companyName'],
      contactNumber: data['contactNumber'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'companyName': companyName,
      'contactNumber': contactNumber,
    };
  }
}
