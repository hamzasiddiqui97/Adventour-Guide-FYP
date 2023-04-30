import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/view/screens/loginScreens/auth_page.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';

import 'view/screens/loginScreens/roleSelection.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      initialRoute: '/splashScreen',
      routes: {
        '/splashScreen': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // User is authenticated, show NavigationPage
              return NavigationPage(uid: snapshot.data!.uid);
            } else {
              // User is not authenticated, show sign in screen
              return RoleSelection();
            }
          },
        ),
        '/signIn': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'),);
            } else if (snapshot.hasData) {
              return NavigationPage(uid: snapshot.data!.uid);
            } else {
              return const AuthPage();
            }
          },
        ),
        '/home': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return NavigationPage(uid: snapshot.data!.uid);
            } else {
              return RoleSelection();
            }
          },
        ),
      },
      title: 'Adventour',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.hasData){
            return NavigationPage(uid: snapshot.data!.uid);
          } else{
            return RoleSelection();
          }
        },
      ),
    );
  }
}
