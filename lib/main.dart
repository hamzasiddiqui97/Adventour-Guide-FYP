import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
// import 'package:google_maps_basics/view/screens/loginScreens/onboarding_screen.dart';
import 'package:google_maps_basics/view/screens/loginScreens/auth_page.dart';
// import 'package:google_maps_basics/view/screens/loginScreens/splash_screen.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';


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

    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      navigatorKey: navigatorKey,
      initialRoute: '/splashScreen',
      routes: {
        '/splashScreen': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return SplashScreen();
            // }
            if (snapshot.hasData) {
              // User is authenticated, show NavigationPage
              return const NavigationPage();
            } else {
              // User is not authenticated, show sign in screen
              return const AuthPage();
            }
          },
        ),
        // '/onBoardingScreen': (context) => const OnboardingScreen(),
        // '/loginMainPage':  (context) => LoginScreen(),
        '/signIn': (context) => StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong'),);
            } else if (snapshot.hasData) {
              return const NavigationPage();
            } else {
              return const AuthPage();
            }
          },
        ),
        // '/signUp': (context) => SignupPage(),
        '/home': (context) => const NavigationPage(),
      },
      title: 'Adventour',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const NavigationPage(),
    );
  }
}
