import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/mainController.dart';
import 'package:google_maps_basics/view/screens/loginScreens/auth_page.dart';
import 'package:lottie/lottie.dart';

class RoleSelection extends StatefulWidget {
  RoleSelection({Key? key}) : super(key: key);

  @override
  State<RoleSelection> createState() => _RoleSelectionState();
}

class _RoleSelectionState extends State<RoleSelection> {
  String? radioValue="Tourist";

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.put(MainController());

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Lottie.asset('assets/splash_screen_animation/selectRole.json'),
            Container(
              height: 52,
              width: 360,
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    15,
                  ),
                ),
              ),
              child: const Center(
                child: Text(
                  "Please Select Any of the Roles",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 280,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Tourist",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // SizedBox(width: 10,),
                      const SizedBox(
                        width: 5,
                      ),

                      Radio(
                          // fillColor: MaterialStateColor
                          //     .resolveWith((states) =>
                          // AppColors.mainColor),
                          value: "Tourist",
                          groupValue: radioValue,
                          onChanged: (value) {
                            setState(() {
                              radioValue = value as String?;
                              print(radioValue);
                            });
                            // selected value
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Hotel Owner",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Radio(
                          // fillColor: MaterialStateColor
                          //     .resolveWith((states) =>
                          // AppColors.mainColor),
                          value: "Hotel Owner",
                          groupValue: radioValue,
                          onChanged: (value) {
                            setState(() {
                              radioValue = value as String?;
                              print(radioValue);
                            });
                            // selected value
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Transport Owner",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Radio(
                          // fillColor: MaterialStateColor
                          //     .resolveWith((states) =>
                          // AppColors.mainColor),
                          value: "Transport Owner",
                          groupValue: radioValue,
                          onChanged: (value) {
                            setState(() {
                              radioValue = value as String?;
                              print(radioValue);
                            });
                            // selected value
                          }),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: (){
                // Get.to(()=>const AuthPage());
                mainController.role.value=radioValue!;
                print(mainController.role.value);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                );
              },
              child: Container(
                height: 45,
                width: 180,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
