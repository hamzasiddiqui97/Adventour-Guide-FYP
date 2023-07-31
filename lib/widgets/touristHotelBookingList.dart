import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/hotelOwnerController.dart';
import 'package:google_maps_basics/model/firebase_reference.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TouristHotelBookingList extends StatelessWidget {
  const TouristHotelBookingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HotelOwnerController hotelOwnerController =
        Get.put(HotelOwnerController());
    for( var i = 0 ; i < hotelOwnerController.propertyRequestList.length; i++ ) {
      // factorial *= i ;
      AddPlacesToFirebaseDb.getHotelTitleByUid(
          hotelOwnerController.propertyRequestList[i].uid);
    }
    return Obx(() {
      return ListView.builder(
          padding: const EdgeInsets.all(15),
          shrinkWrap: true,
          itemCount: hotelOwnerController.propertyRequestList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Center(
                  child: Container(
                    // height: 10.h,
                    width: 95.w,
                    padding: EdgeInsets.all(
                      15.sp,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          20,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0, // soften the shadow
                          spreadRadius: 1.0, //extend the shadow
                          offset: Offset(
                            0.0, // Move to right 5  horizontally
                            2.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                    ),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 5.w,
                        ),
                        // SizedBox(
                        //   width: 50.w,
                        //   child: Text(
                        //   hotelOwnerController.titleList[index],
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.w700, fontSize: 22),
                        //   ),
                        // ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Container(
                          height: 5.h,
                          width: 10.w,
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Container(
                          height: 5.h,
                          width: 10.w,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.cancel,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            );
          });
    });
  }
}
