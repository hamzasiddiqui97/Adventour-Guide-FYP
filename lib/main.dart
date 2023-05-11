import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/pages/transport_owner_dashboard_page.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/transport_owner_dummy_screen.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'hotel_owner_dummy_screen.dart';
import 'model/firebase_reference.dart';
import 'view/screens/loginScreens/roleSelection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        scaffoldMessengerKey: Utils.messengerKey,
        navigatorKey: navigatorKey,
        initialRoute: '/home',
        routes: {
          '/home': (context) => StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder<String>(
                      future: AddPlacesToFirebaseDb()
                          .getUserRole(snapshot.data!.uid),
                      builder: (context, roleSnapshot) {
                        if (roleSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (roleSnapshot.hasError ||
                            roleSnapshot.data == null) {
                          return const Center(
                              child: Text('Something went wrong'));
                        } else {
                          String role = roleSnapshot.data!;
                          if (kDebugMode) {
                            print('role:::::::    $role');
                          }
                          if (role == 'Tourist') {
                            return NavigationPage(uid: snapshot.data!.uid);
                          } else if (role == 'Hotel Owner') {
                            return HotelOwnerPage(uid: snapshot.data!.uid);
                          } else if (role == 'Transport Owner') {
                            return TransportationOwnerPage(
                                uid: snapshot.data!.uid);
                          } else {
                            return RoleSelection();
                          }
                        }
                      },
                    );
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
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FutureBuilder<String>(
                future: AddPlacesToFirebaseDb().getUserRole(snapshot.data!.uid),
                builder: (context, roleSnapshot) {
                  if (roleSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (roleSnapshot.hasError ||
                      roleSnapshot.data == null) {
                    return const Center(child: Text('Something went wrong'));
                  } else {
                    String role = roleSnapshot.data!; //
                    if (role == 'Tourist') {
                      return NavigationPage(uid: snapshot.data!.uid);
                    } else if (role == 'Hotel Owner') {
                      return HotelOwnerPage(uid: snapshot.data!.uid);
                    } else if (role == 'Transport Owner') {
                      return TransportationOwnerPage(uid: snapshot.data!.uid);
                    } else {
                      return RoleSelection();
                    }
                  }
                },
              );
            } else {
              return RoleSelection();
            }
          },
        ),
      );
    });
  }
}
