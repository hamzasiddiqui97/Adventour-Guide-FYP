import 'package:get/get.dart';
import 'package:google_maps_basics/model/hotelBookingRequestModel.dart';

import '../model/vehicle.dart';

class TransportOwnerController extends GetxController {
  RxList<VehicleModel> vehiclePostList = <VehicleModel>[].obs;
  RxList<HotelBookingRequestModel> transportRequestList = <HotelBookingRequestModel>[].obs;

}
