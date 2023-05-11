import 'package:get/get.dart';
import 'package:google_maps_basics/models/PropertyModel.dart';
import 'package:google_maps_basics/models/resquestModel.dart';

import '../model/vehicle.dart';

class HotelOwnerController extends GetxController {
  RxList<Property> propertyList = <Property>[].obs;
  RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
  RxList<RequestModel> hotelOwnerRequestList = <RequestModel>[].obs;
  RxMap dataList = {}.obs;
}
