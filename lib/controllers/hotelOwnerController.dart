import 'package:get/get.dart';
import 'package:google_maps_basics/models/PropertyModel.dart';

class HotelOwnerController extends GetxController {
  RxList<Property> propertyList = <Property>[].obs;
  RxList<VehicleModel> vehicleList = <VehicleModel>[].obs;
  RxMap dataList = {}.obs;
}
