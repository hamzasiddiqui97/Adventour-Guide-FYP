// lib/pages/profile_page.dart

import 'package:flutter/material.dart';
import 'package:google_maps_basics/model/transport_owner.dart';
import 'package:google_maps_basics/model/user.dart' as AppUser;
import 'package:google_maps_basics/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final AppUser.User? currentUser = authProvider.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authProvider.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: currentUser == null
            ? CircularProgressIndicator()
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email: ${currentUser.email ?? ''}'),
            Text('Transport owner: ${currentUser.isTransportOwner ?? false}'),
            if (currentUser is TransportOwner) ...[
              Text('Company name: ${(currentUser as TransportOwner).companyName}'),
              Text('Contact number: ${(currentUser as TransportOwner).contactNumber}'),
            ],
          ],
        ),
      ),
    );
  }
}
