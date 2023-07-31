import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/tranportOwnerController.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TouristTransportBookingList extends StatelessWidget {
  const TouristTransportBookingList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TransportOwnerController transportOwnerController =
    Get.put(TransportOwnerController());
    return ListView.builder(
        padding: const EdgeInsets.all(15),
        shrinkWrap: true,
        itemCount: transportOwnerController.transportRequestList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Center(
                child: Container(
                  height: 10.h,
                  width: 95.w,
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
                      const Text(
                        "Name",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 22),
                      ),
                      SizedBox(
                        width: 45.w,
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
  }
}
