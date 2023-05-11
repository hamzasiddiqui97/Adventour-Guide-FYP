import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/controllers/hotelOwnerController.dart';
import 'package:google_maps_basics/model/firebase_reference.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HotelOwnerHistory extends StatefulWidget {
  const HotelOwnerHistory({Key? key}) : super(key: key);

  @override
  State<HotelOwnerHistory> createState() => _HotelOwnerHistoryState();
}

class _HotelOwnerHistoryState extends State<HotelOwnerHistory> {
  @override
  void initState() {
    // TODO: implement initState
    String uid = FirebaseAuth.instance.currentUser!.uid;
    AddPlacesToFirebaseDb.getHotelOwnerHistory(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final HotelOwnerController hotelOwnerController =
        Get.put(HotelOwnerController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Your History"),
      ),
      body: Obx(() {
        return ListView.builder(
            padding: EdgeInsets.all(15),
            shrinkWrap: true,
            itemCount: hotelOwnerController.hotelOwnerRequestList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  String uid = FirebaseAuth.instance.currentUser!.uid;
                  AddPlacesToFirebaseDb.getHotelOwnerHistory(uid);
                },
                child: Column(
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
                            Text(
                              hotelOwnerController
                                  .hotelOwnerRequestList[index].date
                                  .toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                            Container(
                              height: 5.h,
                              width: 10.w,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
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
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
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
                ),
              );
            });
      }),
    );
  }
}
