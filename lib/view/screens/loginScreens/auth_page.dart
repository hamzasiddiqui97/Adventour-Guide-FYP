import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/mainController.dart';
import 'package:google_maps_basics/view/screens/loginScreens/login.dart';
import 'package:google_maps_basics/view/screens/loginScreens/signUp.dart';
// import 'package:google_maps_basics/view/screens/loginScreens/signUp.dart';
// import 'package:google_maps_basics/view/screens/loginScreens/signUp.dart';
// import 'package:google_maps_basics/view/screens/loginScreens/signUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  int? signUpIndex;

  @override
  void initState() {
    selectSignUp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLogin
      ? SignIn(
          onClickSignUp: toggle,
        )
      : signUpIndex == 0
          ? SignUp(
              onClickSignIn: toggle,
            )
          : signUpIndex == 1
              ? HotelOwnerSignUp(onClickSignIn: toggle)
              : signUpIndex == 2
                  ? TransportOwnerSignUp(onClickSignIn: toggle)
                  : const Scaffold();

  void toggle() => setState(() {
        isLogin = !isLogin;
      });

  void selectSignUp() => setState(() {
        final MainController mainController = Get.put(MainController());
        if (mainController.role.value == "Tourist") {
          setState(() {
            signUpIndex = 0;
          });
        }
        if (mainController.role.value == "Hotel Owner") {
          setState(() {
            signUpIndex = 1;
          });
        }
        if (mainController.role.value == "Transport Owner") {
          setState(() {
            signUpIndex = 2;
          });
        }
        // print("getted value of role is "+mainController.role.value+signUpIndex.toString());
        // isLogin = !isLogin;
      });
}
