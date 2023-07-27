import 'package:get/get.dart';
import 'package:google_maps_basics/model/resquestModel.dart';

import '../model/PropertyModel.dart';
import '../model/vehicle.dart';

class HotelOwnerController extends GetxController {
  RxList<Property> propertyList = <Property>[].obs;
  RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
  RxList<RequestModel> hotelOwnerRequestList = <RequestModel>[].obs;
  RxMap dataList = {}.obs;
}
