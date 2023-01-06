import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_basics/view/screens/onboarding_screen.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:google_maps_basics/view/screens/sign_up.dart';
import 'package:google_maps_basics/view/screens/splash_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splashScreen',
      routes: {
        '/onBoardingScreen': (context) => const OnboardingScreen(),
        '/signUp': (context) => SignupPage(),
        '/splashScreen': (context) => SplashScreen(),
        '/home': (context) => const NavigationPage(),
      },
      title: 'Adventour',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
    );
  }
}
