import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/mainController.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
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
      body: SingleChildScrollView(
        child: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [


              const SizedBox(
                height: 40,
              ),


              Lottie.asset('assets/splash_screen_animation/selectRole.json'),
              Container(
                height: 52,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: const BoxDecoration(
                  color: ColorPalette.secondaryColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      6,
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    "Please Select Any of the Roles",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
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
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width /1.2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
                    backgroundColor: ColorPalette.secondaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                  ),

                  onPressed: (){
                    // Get.to(()=>const AuthPage());
                    mainController.role.value=radioValue!;
                    if (kDebugMode) {
                      print(mainController.role.value);
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AuthPage()),
                    );
                  },
                  child: const Text(
                  "Next",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20),
                ),

                  // child: ElevatedButton(
                  //   onPressed: () {},
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: ColorPalette.secondaryColor,
                  //     foregroundColor: Colors.white,
                  //     minimumSize: const Size(double.infinity, 40),
                  //   ),
                  //   child: const Text('Sign In'),
                  // ),
                  //
                  // child: Container(
                  //   height: 45,
                  //   width: 180,
                  //   decoration: const BoxDecoration(
                  //       color: ColorPalette.secondaryColor,
                  //       borderRadius: BorderRadius.all(Radius.circular(10))),
                  //   child: const Center(
                  //     child: Text(
                  //       "Next",
                  //       style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           color: Colors.white,
                  //           fontSize: 20),
                  //     ),
                  //   ),
                  // ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
