import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_basics/core/constant/color_constants.dart';
import 'package:google_maps_basics/model/firebase_reference.dart';
import 'package:google_maps_basics/snackbar_utils.dart';
import 'package:google_maps_basics/view/screens/pages/home_view.dart';
import 'package:google_maps_basics/view/screens/pages/main_page.dart';
import 'package:intl/intl.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class BookNow extends StatefulWidget {
  const BookNow({Key? key, required this.hotelOwnerUID, required this.isTransport}) : super(key: key);
  final String hotelOwnerUID;
  final bool isTransport;

  @override
  State<BookNow> createState() => _BookNowState(hotelOwnerUID,isTransport);
}

class _BookNowState extends State<BookNow> {
  final String hotelOwnerUID;
  String selectedDate = '';
  String dateCount = '';
  String range = '';
  String rangeCount = '';
  final bool isTransport;

  _BookNowState(this.hotelOwnerUID, this.isTransport);

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
            // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
        // print("selected"+range);
      } else if (args.value is DateTime) {
        selectedDate = args.value.toString();
        // print("selected"+selectedDate);
      } else if (args.value is List<DateTime>) {
        dateCount = args.value.length.toString();
      } else {
        rangeCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(18.0), // set the border radius to 10.0
      ),
      child: Container(
        height: 56.h,
        width: 80.w,
        decoration: const BoxDecoration(
          // color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(
              20,
            ),
          ),
        ),
        padding: const EdgeInsets.only(
          top: 16,
        ),
        child: Center(
          child: SizedBox(
            height: 50.h,
            width: 70.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pick The Date",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SfDateRangePicker(
                  onSelectionChanged: onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                      DateTime.now().subtract(const Duration(days: 4)),
                      DateTime.now().add(const Duration(days: 3))),
                ),
                InkWell(
                  onTap: () {
                    print(range);
                    if (range != '') {
                      Get.back();
                      Utils.showSnackBar(
                          "Request Sent! Wait for the response.", true);
                      String uid = FirebaseAuth.instance.currentUser!.uid;
                      isTransport==true? AddPlacesToFirebaseDb().sendTransportBookingRequest(
                          hotelOwnerUID, uid, range):
                      AddPlacesToFirebaseDb().sendHotelBookingRequest(
                          hotelOwnerUID, uid, range);
                      Get.offAll( NavigationPage(uid: uid,));
                    }
                    if (range == '') {
                      Get.back();
                      Utils.showSnackBar("Select a valid date!", false);
                    }
                  },
                  child: Container(
                    height: 35,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: ColorPalette.secondaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          15,
                        ),
                      ),
                    ),
                    child: Center(child: Text("Confirm")),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
