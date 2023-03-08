import 'package:flutter/material.dart';
import 'package:google_maps_basics/view/screens/loginScreens/login.dart';
import 'package:google_maps_basics/view/screens/loginScreens/signUp.dart';


class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  bool isLogin = true;

  @override
  Widget build(BuildContext context) =>
      isLogin ?
      SignIn(onClickSignUp: toggle,)
          : SignUp(onClickSignIn: toggle);

  void toggle() => setState(() {
    isLogin = !isLogin;
  });
}
