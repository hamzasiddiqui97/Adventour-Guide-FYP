import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/hotelOwnerController.dart';
import 'package:google_maps_basics/controllers/mainController.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/hotel_owner_dummy_screen.dart';
import 'package:google_maps_basics/model/firebase_reference.dart';
import 'package:google_maps_basics/models/PropertyModel.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/view/screens/pages/home_view.dart';
import 'package:google_maps_basics/widgets/customButton.dart';
import 'package:google_maps_basics/widgets/iconButton.dart';
import 'package:google_maps_basics/widgets/myContainer.dart';
import 'package:google_maps_basics/widgets/myTextField.dart';
import 'package:google_maps_basics/widgets/roundBackButton.dart';
import 'package:google_maps_basics/widgets/topWithBackButton.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class PropertyAdd extends StatefulWidget {
  String title;

  PropertyAdd({Key? key, this.title = 'List'}) : super(key: key);

  @override
  _PropertyAddState createState() => _PropertyAddState();
}

String? tap;
String? ac, quarters, parking, kitchen;

class _PropertyAddState extends State<PropertyAdd>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    setState(() {
      tap = null;
      ac = null;
      quarters = null;
    });
    super.initState();
  }

  var floorArea, price;

  final search = TextEditingController();
  final priceController = TextEditingController();
  final title = TextEditingController();
  final desc = TextEditingController();

  String? realEstate;
  var realEstateType = [
    'Commercial Properties',
    'Residential Properties',
    'Industrial Properties',
    'Land'
  ];

  String type = 'Rent';
  String? bedrooms;
  var bedroomQuan = ['2', '3', '4', '5', '6', '7'];

  String? washrooms;
  var washroomsQuan = ['1', '2', '3', '4', '5', '6', '7'];

  // bool? parking;

  // var isParking = ['1', '2', '3', '4'];

  // bool? kitchens;

  // var kitchensQuan = ['1', '2', '3', '4', '5'];

  List<int> floor = [1000, 1500, 1800, 2000, 2200];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(children: [
                    RoundBackButton(),
                    SizedBox(width: 10),
                    Text(
                      "${widget.title} Your Property",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ]),
                  SizedBox(height: 7),
                  Text(
                    "Select Category",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  // SizedBox(height: 5),
                  // // Row(
                  // //   children: [
                  // //     Expanded(
                  // //       child: Button(
                  // //         radius: 10,
                  // //         text: 'Rent',
                  // //         onTap: () {
                  // //           setState(() {
                  // //             type = 'Rent';
                  // //           });
                  // //         },
                  // //         color: type == 'Rent'
                  // //             ? AppColors.kWhite
                  // //             : AppColors.welcomeTwiddle,
                  // //         buttonColor: type == 'Rent'
                  // //             ? AppColors.mainColor
                  // //             : AppColors.mainColor.withOpacity(0.15),
                  // //       ),
                  // //     ),
                  // //     SizedBox(
                  // //       width: 2.w,
                  // //     ),
                  // //     Expanded(
                  // //       child: Button(
                  // //         radius: 10,
                  // //         text: 'Sale',
                  // //         onTap: () {
                  // //           setState(() {
                  // //             type = 'Sale';
                  // //           });
                  // //         },
                  // //         color: type == 'Sale'
                  // //             ? AppColors.kWhite
                  // //             : AppColors.welcomeTwiddle,
                  // //         buttonColor: type == 'Sale'
                  // //             ? AppColors.mainColor
                  // //             : AppColors.mainColor.withOpacity(0.15),
                  // //       ),
                  // //     ),
                  // //     SizedBox(
                  // //       width: 2.w,
                  // //     ),
                  // //     Expanded(
                  // //       child: Button(
                  // //         radius: 10,
                  // //         text: 'Short Stay',
                  // //         onTap: () {
                  // //           setState(() {
                  // //             type = 'Short Stay';
                  // //           });
                  // //         },
                  // //         color: type == 'Short Stay'
                  // //             ? AppColors.kWhite
                  // //             : AppColors.welcomeTwiddle,
                  // //         buttonColor: type == 'Short Stay'
                  // //             ? AppColors.mainColor
                  // //             : AppColors.mainColor.withOpacity(0.15),
                  // //       ),
                  // //     ),
                  // //   ],
                  // // ),
                  // SizedBox(height: 2.h),
                  // Container(
                  //   width: Get.width,
                  //   height: 36,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(4),
                  //     boxShadow: [
                  //       BoxShadow(
                  //         blurRadius: 10,
                  //         color: ColorPalette.secondaryColor,
                  //         offset: Offset(0, 5),
                  //       )
                  //     ],
                  //     color: ColorPalette.textColor,
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(8.0),
                  //     child: Text(
                  //       'Select Real Estate Type',
                  //       style: TextStyle(
                  //           color: ColorPalette.textColor,
                  //           fontSize: 14.sp,
                  //           fontFamily: "PoppinsMedium"),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 1),
                  // Container(
                  //   width: Get.width,
                  //   height: 36,
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(4),
                  //       color: Colors.black12,
                  //       boxShadow: [
                  //         BoxShadow(
                  //             blurRadius: 10,
                  //             color: ColorPalette.secondaryColor,
                  //             offset: Offset(0, 3))
                  //       ]),
                  //   child: DropdownButtonHideUnderline(
                  //     child: DropdownButton(
                  //       icon: const Icon(
                  //         Icons.keyboard_arrow_down,
                  //         color: ColorPalette.secondaryColor,
                  //       ),
                  //       isExpanded: true,
                  //       items: realEstateType
                  //           .map((value) => DropdownMenuItem(
                  //                 value: value,
                  //                 child: Padding(
                  //                   padding:
                  //                       EdgeInsets.symmetric(horizontal: 2.w),
                  //                   child: Text(
                  //                     value,
                  //                     style: TextStyle(
                  //                         fontSize: 14.sp,
                  //                         fontWeight: FontWeight.w500),
                  //                   ),
                  //                 ),
                  //               ))
                  //           .toList(),
                  //       onChanged: (val) {
                  //         setState(() {
                  //           realEstate = val as String?;
                  //         });
                  //       },
                  //       value: realEstate,
                  //       hint: Padding(
                  //         padding: EdgeInsets.symmetric(horizontal: 8.w),
                  //         child: Text(
                  //           'Commercial',
                  //           style: TextStyle(
                  //               fontSize: 12.sp, fontWeight: FontWeight.w500),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 3.h,
                  // ),
                  Expanded(
                      child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 1.h),
                        Text(
                          "INCLUDE SOME DETAILS",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 2.h),
                        const Text('Property Ad Title'),
                        SizedBox(height: 2.h),
                        MyTextField(
                          contentPadding: EdgeInsets.all(12),
                          height: 4.h,
                          width: 10.w,
                          borderColor: Colors.black,
                          controller: title,
                          hint: 'Add Title',
                          color: Colors.black12,
                          radius: 5,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  "Mention the key features of your item (e.g. brand, model, age, type)",
                                  style: TextStyle(
                                      color: Colors.black12, fontSize: 13.sp)),
                            ),
                            SizedBox(
                              width: 1.5.w,
                            ),
                            Text("0/20")
                          ],
                        ),
                        SizedBox(height: 2.5.h),
                        const Text('Description'),
                        SizedBox(height: 2.h),
                        MyTextField(
                          contentPadding: const EdgeInsets.all(12),
                          // height: 20.h,
                          borderColor: ColorPalette.textColor,
                          controller: desc,
                          hint: 'Add Description',
                          color: Colors.black12,
                          radius: 5,
                          maxLines: 4,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  "Include condition, features and reason for selling",
                                  style: TextStyle(
                                      color: Colors.black12, fontSize: 13.sp)),
                            ),
                            Text("0/400")
                          ],
                        ),
                        SizedBox(height: 2.5.h),
                        Text('Specifications'),
                        SizedBox(height: 2.h),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Bedrooms",
                                        style: TextStyle(fontSize: 14.5.sp),
                                      ),
                                      SizedBox(height: 2.h),
                                      MyContainer(
                                        borderColor: ColorPalette.textColor,
                                        radius: 5,
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              icon: Column(
                                                children: const [
                                                  Icon(
                                                      Icons.arrow_drop_up_sharp,
                                                      size: 20),
                                                  Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                      size: 20),
                                                ],
                                              ),
                                              isExpanded: true,
                                              items: bedroomQuan
                                                  .map((value) =>
                                                      DropdownMenuItem(
                                                        value: value,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3.w),
                                                          child: Text(
                                                            value,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: (selectedAccountType) {
                                                setState(() {
                                                  bedrooms = selectedAccountType
                                                      as String?;
                                                });
                                              },
                                              value: bedrooms,
                                              hint: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w),
                                                child: const Text(
                                                  'Bedrooms',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Washrooms",
                                      style: TextStyle(fontSize: 14.5.sp),
                                    ),
                                    SizedBox(height: 2.h),
                                    MyContainer(
                                        borderColor: ColorPalette.textColor,
                                        radius: 5,
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton(
                                              icon: Column(
                                                children: const [
                                                  Icon(
                                                      Icons.arrow_drop_up_sharp,
                                                      size: 20),
                                                  Icon(
                                                      Icons
                                                          .arrow_drop_down_sharp,
                                                      size: 20),
                                                ],
                                              ),
                                              isExpanded: true,
                                              items: washroomsQuan
                                                  .map((value) =>
                                                      DropdownMenuItem(
                                                        value: value,
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      3.w),
                                                          child: Text(
                                                            value,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList(),
                                              onChanged: (selectedAccountType) {
                                                setState(() {
                                                  washrooms =
                                                      selectedAccountType
                                                          as String?;
                                                });
                                              },
                                              value: washrooms,
                                              hint: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 3.w),
                                                child: const Text(
                                                  'Washrooms',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ]),
                        SizedBox(height: 2.5.h),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Car Parking"),
                                SizedBox(height: 2.h),
                                Row(children: [
                                  Button(
                                    width: 80.w,
                                    height: 5.h,
                                    radius: 5,
                                    text: "Yes",
                                    color: parking == "Yes"
                                        ? ColorPalette.primaryColor
                                        : ColorPalette.secondaryColor,
                                    buttonColor: parking == "Yes"
                                        ? ColorPalette.secondaryColor
                                        : ColorPalette.primaryColor,
                                    onTap: () {
                                      setState(() {
                                        parking = "Yes";
                                      });
                                    },
                                  ),
                                  SizedBox(width: 5.w),
                                  Button(
                                    width: 80.w,
                                    height: 5.h,
                                    radius: 5,
                                    text: "No",
                                    buttonColor: parking == "No"
                                        ? ColorPalette.secondaryColor
                                        : Colors.white54,
                                    color: parking == "No"
                                        ? ColorPalette.primaryColor
                                        : ColorPalette.secondaryColor,
                                    onTap: () {
                                      setState(() {
                                        parking = "No";
                                      });
                                    },
                                  ),
                                ])
                                // MyContainer(
                                //     borderColor: ColorPalette.textColor,
                                //     radius: 5,
                                //     child: Center(
                                //       child: DropdownButtonHideUnderline(
                                //         child: DropdownButton(
                                //           icon: Column(
                                //             children: const [
                                //               Icon(Icons
                                //                   .arrow_drop_up_sharp,
                                //                   size: 20),
                                //               Icon(
                                //                   Icons
                                //                       .arrow_drop_down_sharp,
                                //                   size: 20),
                                //             ],
                                //           ),
                                //           isExpanded: true,
                                //           // items: isParking
                                //           //     .map(
                                //           //         (value) =>
                                //           //         DropdownMenuItem(
                                //           //           value: value,
                                //           //           child: Padding(
                                //           //             padding: EdgeInsets
                                //           //                 .symmetric(
                                //           //                 horizontal:
                                //           //                 3.w),
                                //           //             child: Text(
                                //           //               value,
                                //           //               style: const TextStyle(
                                //           //                   fontWeight:
                                //           //                   FontWeight
                                //           //                       .w500),
                                //           //             ),
                                //           //           ),
                                //           //         ))
                                //           //     .toList(),
                                //           // onChanged: (
                                //           //     selectedAccountType) {
                                //           //   setState(() {
                                //           //     parking =
                                //           //     selectedAccountType
                                //           //     as String?;
                                //           //   });
                                //           // },
                                //           value: parking,
                                //           hint: Padding(
                                //               padding: EdgeInsets
                                //                   .symmetric(
                                //                   horizontal: 3.w),
                                //               child: const Text(
                                //                 'Car Parking',
                                //                 style: TextStyle(
                                //                     fontWeight:
                                //                     FontWeight.w500),
                                //               )),
                                //         ),
                                //       ),
                                //     )),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Kitchens"),
                                  SizedBox(height: 2.h),
                                  Row(children: [
                                    Button(
                                      width: 80.w,
                                      height: 5.h,
                                      radius: 5,
                                      text: "Yes",
                                      color: kitchen == "Yes"
                                          ? ColorPalette.primaryColor
                                          : ColorPalette.secondaryColor,
                                      buttonColor: kitchen == "Yes"
                                          ? ColorPalette.secondaryColor
                                          : ColorPalette.primaryColor,
                                      onTap: () {
                                        setState(() {
                                          kitchen = "Yes";
                                        });
                                      },
                                    ),
                                    SizedBox(width: 5.w),
                                    Button(
                                      width: 80.w,
                                      height: 5.h,
                                      radius: 5,
                                      text: "No",
                                      buttonColor: kitchen == "No"
                                          ? ColorPalette.secondaryColor
                                          : Colors.white54,
                                      color: kitchen == "No"
                                          ? ColorPalette.primaryColor
                                          : ColorPalette.secondaryColor,
                                      onTap: () {
                                        setState(() {
                                          kitchen = "No";
                                        });
                                      },
                                    ),
                                  ])
                                  // MyContainer(
                                  //   borderColor: ColorPalette.textColor,
                                  //   radius: 5,
                                  //   child: Center(
                                  //       child: DropdownButtonHideUnderline(
                                  //         child: DropdownButton(
                                  //           icon: Column(
                                  //             children: const [
                                  //               Icon(Icons
                                  //                   .arrow_drop_up_sharp,
                                  //                   size: 20),
                                  //               Icon(Icons
                                  //                   .arrow_drop_down_sharp,
                                  //                   size: 20),
                                  //             ],
                                  //           ),
                                  //           isExpanded: true,
                                  //           items: kitchensQuan
                                  //               .map((value) =>
                                  //               DropdownMenuItem(
                                  //                 value: value,
                                  //                 child: Padding(
                                  //                   padding:
                                  //                   EdgeInsets.symmetric(
                                  //                       horizontal: 3.w),
                                  //                   child: Text(
                                  //                     value,
                                  //                     style: const TextStyle(
                                  //                         fontWeight:
                                  //                         FontWeight
                                  //                             .w500),
                                  //                   ),
                                  //                 ),
                                  //               ))
                                  //               .toList(),
                                  //           onChanged: (
                                  //               selectedAccountType) {
                                  //             setState(() {
                                  //               kitchens =
                                  //               selectedAccountType
                                  //               as String?;
                                  //               // print(kitchens);
                                  //             });
                                  //           },
                                  //           value: kitchens,
                                  //           hint: Padding(
                                  //             padding: EdgeInsets
                                  //                 .symmetric(
                                  //                 horizontal: 3.w),
                                  //             child: const Text(
                                  //               'Kitchens',
                                  //               style: TextStyle(
                                  //                   fontWeight: FontWeight
                                  //                       .w500),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       )),
                                  // ),
                                ])
                          ],
                        ),
                        SizedBox(height: 3.h),
                        const Text("Area Unit"),
                        SizedBox(height: 2.h),
                        Button(
                          text: 'Square Meter',
                          width: 110.w,
                          radius: 5,
                          height: 6.5.h,
                        ),
                        SizedBox(height: 3.h),
                        const Text("Floor Area"),
                        SizedBox(height: 2.5.h),
                        MyContainer(
                            borderColor: ColorPalette.textColor,
                            radius: 5,
                            child: Row(
                              children: [
                                SizedBox(width: 5.w),
                                Text(
                                  '㎡',
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(width: 5.w),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: ColorPalette.textColor,
                                ),
                                SizedBox(width: 6.w),
                                Expanded(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      icon: Column(
                                        children: const [
                                          Icon(Icons.arrow_drop_up_sharp,
                                              size: 20),
                                          Icon(Icons.arrow_drop_down_sharp,
                                              size: 20),
                                        ],
                                      ),
                                      isExpanded: true,
                                      items: floor
                                          .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8.w),
                                                  child: Text(
                                                    value.toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (selectedAccountType) {
                                        setState(() {
                                          floorArea =
                                              selectedAccountType as int?;
                                        });
                                      },
                                      value: floorArea,
                                      hint: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        child: const Text(
                                          'Floor Area',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 3.h),
                        const Text("Tap Available"),
                        SizedBox(height: 2.h),
                        Row(children: [
                          Button(
                            width: 80.w,
                            height: 5.h,
                            radius: 5,
                            text: "Yes",
                            color: tap == "Yes"
                                ? ColorPalette.primaryColor
                                : ColorPalette.secondaryColor,
                            buttonColor: tap == "Yes"
                                ? ColorPalette.secondaryColor
                                : ColorPalette.primaryColor,
                            onTap: () {
                              setState(() {
                                tap = "Yes";
                              });
                            },
                          ),
                          SizedBox(width: 5.w),
                          Button(
                            width: 80.w,
                            height: 5.h,
                            radius: 5,
                            text: "No",
                            buttonColor: tap == "No"
                                ? ColorPalette.secondaryColor
                                : Colors.white54,
                            color: tap == "No"
                                ? ColorPalette.primaryColor
                                : ColorPalette.secondaryColor,
                            onTap: () {
                              setState(() {
                                tap = "No";
                              });
                            },
                          ),
                        ]),
                        SizedBox(height: 3.h),
                        const Text("Air Conditioner Available?"),
                        SizedBox(
                          height: 2.h,
                        ),
                        Row(children: [
                          Button(
                            width: 80.w,
                            height: 5.h,
                            radius: 5,
                            text: "Yes",
                            color: ac == "Yes"
                                ? ColorPalette.primaryColor
                                : ColorPalette.secondaryColor,
                            buttonColor: ac == "Yes"
                                ? ColorPalette.secondaryColor
                                : ColorPalette.primaryColor,
                            onTap: () {
                              setState(() {
                                ac = "Yes";
                              });
                            },
                          ),
                          SizedBox(width: 5.w),
                          Button(
                            width: 80.w,
                            height: 5.h,
                            radius: 5,
                            text: "No",
                            buttonColor: ac == "No"
                                ? ColorPalette.secondaryColor
                                : Colors.white54,
                            color: ac == "No"
                                ? ColorPalette.primaryColor
                                : ColorPalette.secondaryColor,
                            onTap: () {
                              setState(() {
                                ac = "No";
                              });
                            },
                          ),
                        ]),
                        SizedBox(height: 3.h),
                        const Text("Quarters Available?"),
                        SizedBox(height: 2.h),
                        Row(children: [
                          Button(
                            width: 80.w,
                            height: 5.h,
                            radius: 5,
                            text: "Yes",
                            color: quarters == "Yes"
                                ? ColorPalette.primaryColor
                                : ColorPalette.secondaryColor,
                            buttonColor: quarters == "Yes"
                                ? ColorPalette.secondaryColor
                                : ColorPalette.primaryColor,
                            onTap: () {
                              setState(() {
                                quarters = "Yes";
                              });
                            },
                          ),
                          SizedBox(width: 5.w),
                          Button(
                            width: 80.w,
                            height: 5.h,
                            radius: 5,
                            text: "No",
                            buttonColor: quarters == "No"
                                ? ColorPalette.secondaryColor
                                : Colors.white54,
                            color: quarters == "No"
                                ? ColorPalette.primaryColor
                                : ColorPalette.secondaryColor,
                            onTap: () {
                              setState(() {
                                quarters = "No";
                              });
                            },
                          ),
                        ]),
                        SizedBox(height: 3.h),
                        MyContainer(
                          height: 137.h,
                          radius: 10,
                          color: Colors.white12,
                          horizontalPadding: 5,
                          verticalPadding: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Set a Price",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  "Price",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.sp),
                                ),
                                SizedBox(height: 1.h),
                                MyTextField(
                                  onEditingComplete: () {
                                    setState(() {
                                      price = int.parse(priceController.text);
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  // height: 50.h,
                                  radius: 5,
                                  controller: priceController,
                                  color: Colors.black12,
                                  hint: 'Enter Amount',
                                  icon: const Text('    PKR |'),
                                )
                              ]),
                        ),
                        SizedBox(height: 5.h),
                        Button(
                          height: 6.h,
                          text: "Next",
                          onTap: () {
                            if (title.text.isNotEmpty &&
                                desc.text.isNotEmpty &&
                                priceController.text.isNotEmpty) {
                              if (bedrooms == null &&
                                  kitchen == null &&
                                  washrooms == null &&
                                  parking == null &&
                                  realEstate == null &&
                                  ac == null &&
                                  tap == null &&
                                  quarters == null &&
                                  floorArea == null &&
                                  type == null) {
                                Fluttertoast.showToast(
                                    msg: 'Please give all requirements');
                              } else {
                                Get.to(() => AddPostScreen(
                                      title: title.text,
                                      desc: desc.text,
                                      price: price,
                                      bedroom: bedrooms,
                                      washroom: washrooms,
                                      parking: parking,
                                      kitchen: kitchen,
                                      tap: tap,
                                      ac: ac,
                                      quarters: quarters,
                                      floorArea: floorArea,
                                      type: type,
                                      realEstateType: realEstate,
                                      property: widget.title,
                                    ));

                                // print(
                                //   '${title.text} ${desc.text} ${price} ${bedrooms}'
                                //   '${washrooms} ${parking} ${kitchens} ${tap}'
                                //       '${ac} ${quarters} ${floorArea} ${type}'
                                //       '${realEstate}'
                                // );
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: 'Please give all requirements');
                            }
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ));
  }
}

class AddPostScreen extends StatefulWidget {
  String? title;
  int price;
  String? desc;
  String? type;
  String? bedroom;
  String? washroom;
  String? parking;
  String? kitchen;
  int floorArea;
  String? tap;
  String? ac;
  String? quarters;
  String? realEstateType;
  String? property;

  AddPostScreen(
      {Key? key,
      this.title,
      this.desc,
      this.washroom,
      this.parking,
      this.kitchen,
      this.floorArea = 0,
      this.tap = "Yes",
      this.ac = "Yes",
      this.quarters = "Yes",
      this.bedroom,
      this.price = 0,
      this.type,
      this.realEstateType,
      this.property})
      : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool value1 = false;
  bool value2 = false;
  final houseNo = TextEditingController();
  final streetName = TextEditingController();
  final fullAddress = TextEditingController();

  // final occupationName = TextEditingController();
  // final occupationContact = TextEditingController();
  File? coverImageFile;
  File? ImageFile1;
  File? ImageFile2;
  File? ImageFile3;
  File? ImageFile4;
  File? ImageFile5;
  File? ImageFile6;
  String coverImage = '';
  String imageUrl1 = '';
  String imageUrl2 = '';
  String imageUrl3 = '';
  String imageUrl4 = '';
  String imageUrl5 = '';
  String imageUrl6 = '';

  // VideoPlayerController? _videoPlayerController;

  // VideoPlayerController? _cameraVideoPlayerController;
  // File? _video;
  final picker = ImagePicker();

// This funcion will helps you to pick a Video File
//   pickVideo() async {
//     PickedFile? pickedFile = await picker.getVideo(source: ImageSource.gallery);
//     _video = File(pickedFile!.path);
//     _videoPlayerController = VideoPlayerController.file(_video!)
//       ..initialize().then((_) {
//         setState(() {});
//         _videoPlayerController!.play();
//       });
//     if (pickedFile != null) {
//       String? imagePath = pickedFile.path;
//       imagePath = await VideoThumbnail.thumbnailFile(
//           video: pickedFile.path, maxHeight: 10, maxWidth: 30);
//       setState(() {});
//     }
//   }

  getCoverFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        coverImageFile = File(pickedFile.path);
      });
    }
    if (coverImageFile == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          coverImageFile!.path,
        ),
      );
      //Success: get the download URL
      coverImage = await referenceImageToUpload.getDownloadURL();
      print(coverImage);
    } catch (error) {
      //Some error occurred
    }
  }

  getImg1FromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        ImageFile1 = File(pickedFile.path);
      });
    }
    if (ImageFile1 == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          ImageFile1!.path,
        ),
      );
      //Success: get the download URL
      imageUrl1 = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
  }

  getImg2FromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        ImageFile2 = File(pickedFile.path);
      });
    }
    if (ImageFile2 == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          ImageFile2!.path,
        ),
      );
      //Success: get the download URL
      imageUrl2 = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
  }

  getImg3FromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        ImageFile3 = File(pickedFile.path);
      });
    }
    if (ImageFile3 == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          ImageFile3!.path,
        ),
      );
      //Success: get the download URL
      imageUrl3 = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
  }

  getImg4FromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        ImageFile4 = File(pickedFile.path);
      });
    }
    if (ImageFile2 == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          ImageFile4!.path,
        ),
      );
      //Success: get the download URL
      imageUrl4 = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
  }

  getImg5FromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        ImageFile5 = File(pickedFile.path);
      });
    }
    if (ImageFile5 == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          ImageFile5!.path,
        ),
      );
      //Success: get the download URL
      imageUrl5 = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
  }

  getImg6FromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        ImageFile6 = File(pickedFile.path);
      });
    }
    if (ImageFile6 == null) return;
    //Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    /*Step 2: Upload to Firebase storage*/
    //Install firebase_storage
    //Import the library

    //Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    //Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    //Handle errors/success
    try {
      //Store the file
      await referenceImageToUpload.putFile(
        File(
          ImageFile6!.path,
        ),
      );
      //Success: get the download URL
      imageUrl6 = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      //Some error occurred
    }
  }

  @override
  Widget build(BuildContext context) {
    final MainController mainController = Get.put(MainController());
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            TopWithBackButton(text: 'Ad Post'),
            SizedBox(height: 4.h),
            Padding(
              padding: EdgeInsets.only(left: 5.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Upload Cover Image",
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Type: jpg and png. Dimensions 333px x 163px - 999px x 489px',
                    style:
                        TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 4.h),
                  GestureDetector(
                    onTap: () {
                      getCoverFromGallery();
                      // captureImage();
                      // print(image1!.path);
                    },
                    child: MyContainer(
                      // onTap: (){},
                      height: 66.h,
                      width: 80.w,
                      radius: 10,
                      borderColor: ColorPalette.textColor,
                      child: coverImageFile == null
                          ? Icon(Icons.add_a_photo_outlined, size: 30)
                          : Image.file(
                              coverImageFile!,
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  //   : Container(
                  //       height: 66.h,
                  //       width: 80.w,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         border: Border.all(
                  //             color: AppColors.welcomeTwiddle, width: 1),
                  //         ),
                  // child: Image.file(coverImageFile!),
                  //       ),

                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'Maximum size 2mb.',
                    style: TextStyle(color: Colors.red, fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    'Upload Upto 6 Photos',
                    style: TextStyle(fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    'Type: jpg and png.',
                    style: TextStyle(fontSize: 13.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImg1FromGallery();
                            // captureImage();
                            // print(image1!.path);
                          },
                          child: MyContainer(
                            // onTap: (){},
                            height: 66.h,
                            width: 80.w,
                            radius: 10,
                            borderColor: ColorPalette.textColor,
                            child: ImageFile1 == null
                                ? Icon(Icons.add_a_photo_outlined, size: 30)
                                : Image.file(
                                    ImageFile1!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getImg2FromGallery();
                            // captureImage();
                            // print(image1!.path);
                          },
                          child: MyContainer(
                            // onTap: (){},
                            height: 66.h,
                            width: 80.w,
                            radius: 10,
                            borderColor: ColorPalette.textColor,
                            child: ImageFile2 == null
                                ? Icon(Icons.add_a_photo_outlined, size: 30)
                                : Image.file(
                                    ImageFile2!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getImg3FromGallery();
                            // captureImage();
                            // print(image1!.path);
                          },
                          child: MyContainer(
                            // onTap: (){},
                            height: 66.h,
                            width: 80.w,
                            radius: 10,
                            borderColor: ColorPalette.textColor,
                            child: ImageFile3 == null
                                ? Icon(Icons.add_a_photo_outlined, size: 30)
                                : Image.file(
                                    ImageFile3!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        )
                      ]),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getImg4FromGallery();
                            // captureImage();
                            // print(image1!.path);
                          },
                          child: MyContainer(
                            // onTap: (){},
                            height: 66.h,
                            width: 80.w,
                            radius: 10,
                            borderColor: ColorPalette.textColor,
                            child: ImageFile4 == null
                                ? Icon(Icons.add_a_photo_outlined, size: 30)
                                : Image.file(
                                    ImageFile4!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getImg5FromGallery();
                            // captureImage();
                            // print(image1!.path);
                          },
                          child: MyContainer(
                            // onTap: (){},
                            height: 66.h,
                            width: 80.w,
                            radius: 10,
                            borderColor: ColorPalette.textColor,
                            child: ImageFile5 == null
                                ? Icon(Icons.add_a_photo_outlined, size: 30)
                                : Image.file(
                                    ImageFile5!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getImg6FromGallery();
                            // captureImage();
                            // print(image1!.path);
                          },
                          child: MyContainer(
                            // onTap: (){},
                            height: 66.h,
                            width: 80.w,
                            radius: 10,
                            borderColor: ColorPalette.textColor,
                            child: ImageFile6 == null
                                ? Icon(Icons.add_a_photo_outlined, size: 30)
                                : Image.file(
                                    ImageFile6!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        )
                      ]),
                  SizedBox(height: 3.h),
                  Text(
                    'Maximum size 2mb.',
                    style: TextStyle(color: Colors.red, fontSize: 13.sp),
                  ),
                  SizedBox(height: 3.h),
                  // Text(
                  //   'Upload Upto One 360 View Image',
                  //   style: TextStyle(fontSize: 15.sp),
                  // ),
                  // SizedBox(height: 3.h),
                  // MyContainer(
                  //   height: 66.h,
                  //   width: 80.w,
                  //   radius: 10,
                  //   borderColor: ColorPalette.textColor,
                  //   child: Center(
                  //     child: MyContainer(
                  //       width: 40.w,
                  //       height: 40.h,
                  //       child:
                  //       // Image.asset(
                  //       //   AppAssets.threeSixtyIcon,
                  //       // ),
                  //       SizedBox(),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 2.h),
                  // Text(
                  //   'Maximum size 2mb.',
                  //   style: TextStyle(color: Colors.red, fontSize: 13.sp),
                  // ),
                  SizedBox(height: 3.h),
                  // Text(
                  //   'Upload Upto One Video',
                  //   style: TextStyle(fontSize: 15.sp),
                  // ),
                  // SizedBox(height: 3.h),
                  // GestureDetector(
                  //     onTap: () {
                  //       pickVideo();
                  //       _videoPlayerController!.value;
                  //     },
                  //     child: MyContainer(
                  //         height: 66.h,
                  //         width: 80.w,
                  //         radius: 10,
                  //         borderColor: ColorPalette.textColor,
                  //         child: Icon(Icons.video_call_outlined, size: 30))),

                  // SizedBox(height: 2.h),
                  // Text(
                  //   'Maximum size 10mb.',
                  //   style: TextStyle(color: Colors.red, fontSize: 13.sp),
                  // ),
                  // Text(
                  //   'For the cover picture we recommend using the landscape mode.',
                  //   style: TextStyle(fontSize: 13.sp),
                  // ),
                  // SizedBox(
                  //   height: 4.h,
                  // ),
                  Text(
                    'PROPERTY DETAILS FORM',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.secondaryColor),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  const Text('House Number'),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyTextField(
                    contentPadding: EdgeInsets.all(12),
                    height: 50,
                    borderColor: ColorPalette.textColor,
                    hint: '',
                    color: Colors.black12,
                    radius: 5,
                    controller: houseNo,
                  ),
                  SizedBox(height: 3.h),
                  Text('Street Name'),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyTextField(
                    contentPadding: EdgeInsets.all(12),
                    height: 50,
                    borderColor: ColorPalette.textColor,
                    hint: '',
                    color: Colors.black12,
                    radius: 5,
                    controller: streetName,
                  ),
                  SizedBox(height: 3.h),
                  Text('Full Address'),
                  SizedBox(
                    height: 2.h,
                  ),
                  MyTextField(
                    contentPadding: EdgeInsets.all(12),

                    // height: 50,
                    // width: 120.w,
                    borderColor: ColorPalette.textColor,
                    hint: '',
                    color: Colors.black12,
                    radius: 10,
                    controller: fullAddress,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    "Location of property identified through Google Map",
                    style: TextStyle(
                      color: Colors.black12,
                      fontSize: 13.sp,
                    ),
                  ),
                  // SizedBox(height: 2.h),
                  // Text(
                  //   " PROPERTY DOCUMENTATION COPY",
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // Iconbutton(
                  //   width: 35.w,
                  //   height: 40.h,
                  //   icon: Icons.add_a_photo,
                  //   text: 'Upload',
                  //   buttonColor: Color(0xff1492E6),
                  //   radius: 10,
                  // ),
                  // SizedBox(
                  //   height: 2.h,
                  // ),
                  // Text(
                  //   'Property Documentation Copy Upload Pdf Or Image* E.G. Copy Of Site Plan, Photo Of House Number Label, Bank Statement Or A Utility Bill, That Bears The Name Of Property Owner, Etc.',
                  //   style: TextStyle(
                  //     fontSize: 13.sp,
                  //     color: Colors.black12,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 3.h,
                  // ),
                  Row(children: [
                    Checkbox(
                      checkColor: Colors.black12,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return ColorPalette.primaryColor;
                        }
                        return ColorPalette.secondaryColor;
                      }),
                      value: value1,
                      onChanged: (value) {
                        setState(() {
                          value1 = !value1;
                        });
                      },
                    ),
                    SizedBox(width: 3),
                    Text(
                      "Letter Of Consent Agreement",
                      style: TextStyle(decoration: TextDecoration.underline),
                    )
                  ]),
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Checkbox(
                      value: value2,
                      checkColor: Colors.black12,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return ColorPalette.primaryColor;
                        }
                        return ColorPalette.secondaryColor;
                      }),
                      onChanged: (value) {
                        setState(() {
                          value2 = !value2;
                        });
                      },
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    const Expanded(
                        child: Text(
                            'Must Agree To A 4% Mediation Fees To Twiddle Through Funders.'))
                  ]),
                  SizedBox(height: 4.h),
                  Button(
                      height: 6.h,
                      width: 320.w,
                      text: "Post",
                      onTap: () async {
                        if (houseNo.text.isNotEmpty &&
                                streetName.text.isNotEmpty &&
                                fullAddress.text.isNotEmpty
                            // occupationName.text.isNotEmpty &&
                            // occupationContact.text.isNotEmpty
                            ) {
                          if (value1 == true && value2 == true) {
                            final HotelOwnerController hotelOwnerController =
                                Get.put(HotelOwnerController());
                            // final MainController mainController =
                            //     Get.put(MainController());
                            hotelOwnerController.propertyList.add(Property(
                              title: widget.title!,
                              description: widget.desc!,
                              bedroom: widget.bedroom!,
                              washroom: widget.washroom!,
                              carParking: widget.parking!,
                              kitchen: widget.kitchen!,
                              // areaUnit: widget.ac!,
                              floorArea: widget.floorArea,
                              tapAvailable: widget.tap!,
                              airConditioner: widget.ac!,
                              quarterAvailable: widget.quarters!,
                              price: widget.price,
                              coverImage: coverImage,
                              file1: imageUrl1,
                              file2: imageUrl2,
                              file3: imageUrl3,
                              file4: imageUrl4,
                              file5: imageUrl5,
                              file6: imageUrl6,
                              // video: _video!.path,
                              streetName: streetName.text,
                              fullAddress: fullAddress.text,
                            ));
                            String uid = FirebaseAuth.instance.currentUser!.uid;
                            AddPlacesToFirebaseDb addPlacesToFirebaseDb =
                                AddPlacesToFirebaseDb();
                            String userRole =
                                await addPlacesToFirebaseDb.getUserRole(uid);
                            print(userRole);
                            print(mainController.role.value);
                            // if (userRole != mainController.role.value) {
                            //   Utils.showSnackBar(
                            //       "You are signed in as a $userRole. Please sign in from the correct page.",
                            //       false);
                            //   return;
                            // }
                            // print(mainController.role.value);
                            // else {
                            AddPlacesToFirebaseDb().saveHotelOwnerPost(
                              mainController.role.value,
                              uid,
                              widget.title!,
                              widget.desc!,
                              widget.bedroom!,
                              widget.washroom!,
                              widget.parking!,
                              widget.kitchen!,
                              widget.floorArea,
                              widget.tap!,
                              widget.ac!,
                              widget.quarters!,
                              widget.price,
                              coverImage,
                              imageUrl1,
                              imageUrl2,
                              imageUrl3,
                              imageUrl4,
                              imageUrl5,
                              imageUrl6,
                              streetName.text,
                              fullAddress.text,
                            );
                            Get.offAll(
                              HotelOwnerPage(
                                uid: uid,
                              ),
                            );
                            Utils.showSnackBar("Successfully Posted", true);
                            //
                            // .showToaFluttertoastst(
                            //     msg: 'Post Successfully Posted!');
                            // }
                            print(hotelOwnerController.propertyList.length);
                            if (widget.property == 'Update') {
                              // final HotelOwnerController hotelOwnerController =
                              //     Get.put(HotelOwnerController());
                              // hotelOwnerController.propertyList.add(Property(
                              //   title: widget.title!,
                              //   description: widget.desc!,
                              //   bedroom: widget.bedroom!,
                              //   washroom: widget.washroom!,
                              //   carParking: widget.parking!,
                              //   kitchen: widget.kitchen!,
                              //   // areaUnit: widget.ac!,
                              //   floorArea: widget.floorArea,
                              //   tapAvailable: widget.tap!,
                              //   airConditioner: widget.ac!,
                              //   quarterAvailable: widget.quarters!,
                              //   price: widget.price,
                              //   coverImage: coverImageFile!.path,
                              //   file1: ImageFile1!.path,
                              //   file2: ImageFile2!.path,
                              //   file3: ImageFile3!.path,
                              //   file4: ImageFile4!.path,
                              //   file5: ImageFile5!.path,
                              //   file6: ImageFile6!.path,
                              //   // video: _video!.path,
                              //   streetName: streetName.text,
                              //   fullAddress: fullAddress.text,
                              // ));
                              print(hotelOwnerController.propertyList.length);
                            } else {
                              // addProperty(
                              //     '${widget.title}',
                              //     widget.desc,
                              //     widget.bedroom,
                              //     widget.washroom,
                              //     widget.parking,
                              //     widget.kitchen,
                              //     widget.tap,
                              //     widget.ac,
                              //     widget.quarters,
                              //     widget.type,
                              //     houseNo.text,
                              //     occupationName.text,
                              //     occupationContact.text.trim(),
                              //     streetName.text,
                              //     gpsAddress.text,
                              //     widget.price,
                              //     widget.floorArea);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: 'Accept terms & policies');
                          }
                        } else {
                          Fluttertoast.showToast(msg: 'Enter all fields');
                        }
                      }),
                  SizedBox(height: 4.h)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//   captureImage() async {
//     final _picked = ImagePicker();
//     PickedFile? image;
//
//     /// Check Permissions
//     await Permission.phone.request();
//
//     var permissionStatus = await Permission.photos.status;
//
//     if (permissionStatus.isGranted) {
//       /// Select Image
//       image = await _picked.getImage(source: ImageSource.camera);
//
//       var file = File(image.path);
//       //String fileName = Uuid().v1();
//
//       if (file != null) {
//         setState(() {
//           image1 = file;
//         });
//         print(image1);
//         return image1;
//       } else {
//         Fluttertoast.showToast(msg: 'No image received');
//       }
//     } else {
//       Fluttertoast.showToast(msg: 'Grant Permissions and try again');
//     }
//   }
//
//   getImage(File image) async {
//     final _picked = ImagePicker();
//     PickedFile? _image;
//
//     /// Check Permissions
//     await Permission.phone.request();
//
//     var permissionStatus = await Permission.photos.status;
//
//     if (permissionStatus.isGranted) {
//       /// Select Image
//       _image = await _picked.getImage(source: ImageSource.gallery);
//
//       var file = File(_image!.path);
//       //String fileName = Uuid().v1();
//
//       if (file != null) {
//         setState(() {
//           image = file;
//         });
//         print(image);
//         return image;
//       } else {
//         Fluttertoast.showToast(msg: 'No image received');
//       }
//     } else {
//       Fluttertoast.showToast(msg: 'Grant Permissions and try again');
//     }
//   }
// }

  Widget MyIconContainer(IconData icon, double size) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xff707070), width: 1),
          borderRadius: BorderRadius.circular(13)),
      child: Icon(icon, size: size),
    );
  }
}
