import 'package:get/get.dart';
import 'package:google_maps_basics/models/PropertyModel.dart';
import 'package:google_maps_basics/models/resquestModel.dart';

class HotelOwnerController extends GetxController {
  RxList<Property> propertyList = <Property>[].obs;
  RxList<RequestModel> hotelOwnerRequestList = <RequestModel>[].obs;
  RxMap dataList = {}.obs;
}
