import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class TransportationOwnerPage extends StatefulWidget {
  final String uid;
  const TransportationOwnerPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<TransportationOwnerPage> createState() => _TransportationOwnerPageState();
}

class _TransportationOwnerPageState extends State<TransportationOwnerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TransportationOwnerPage'),
      ),
      body: Column(
        children: [
          Text('Welcome, tranport owner! Your UID: ${widget.uid}'),

          ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: const Text('Sign Out', ))

        ],
      ),
    );
  }
}
