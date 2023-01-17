import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_basics/view/screens/loginScreens/login.dart';
import 'package:google_maps_basics/view/screens/loginScreens/login_main_page.dart';
import 'package:google_maps_basics/view/screens/loginScreens/onboarding_screen.dart';
import 'package:google_maps_basics/view/screens/loginScreens/sign_up.dart';
import 'package:google_maps_basics/view/screens/loginScreens/splash_screen.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:google_maps_basics/view/screens/views/news_view.dart';

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
        '/splashScreen': (context) => SplashScreen(),
        '/onBoardingScreen': (context) => const OnboardingScreen(),
        '/loginMainPage':  (context) => LoginScreen(),
        '/signIn': (context) => SignIn(),
        '/signUp': (context) => SignupPage(),
        '/home': (context) => const NavigationPage(),
      },
      title: 'Adventour',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: const OnboardingScreen(),
      // home: NewsScreen(),
    );

  }
}
