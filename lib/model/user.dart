// lib/models/user.dart

import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String email;
  final bool isTransportOwner;

  User({
    required this.id,
    required this.email,
    required this.isTransportOwner,
  });

  factory User.fromMap(String id, Map<String, dynamic> data) {
    return User(
      id: id,
      email: data['email'],
      isTransportOwner: data['isTransportOwner'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'isTransportOwner': isTransportOwner,
    };
  }
}
