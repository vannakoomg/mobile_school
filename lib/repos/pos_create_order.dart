import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../models/PosCreateOrderDB.dart';
import '../screens/widgets/exceptions.dart';
import '../config/url.dart';

final storage = GetStorage();
late PosCreateOrderDb posCreateOrderDb;

Future posCreateOrder(
    {required List<Map<String, dynamic>> lines,
    required String type,
    required double amountPaid,
    required String pickUp,
    required String comment,
    required double topUpAmount,
    required String statePreOrder,
    required String imageEncode}) async {
  Map<String, dynamic> data = {};
  data = {
    "params": {
      "route": "create_order",
      "type": type,
      "student_id": storage.read('isActive'),
      "amount_paid": amountPaid,
      "lines": lines,
      "campus": storage.read("campus"),
      "pick_up": pickUp,
      "comment": comment,
      "top_up": topUpAmount,
      "state_pre_order": statePreOrder,
      "image_encode": imageEncode
    }
  };
  try {
    // print("fetchPos");
    // String fullUrl = "http://202.62.45.129:8069/ics_canteen";
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    })).post(baseUrlOdoo, data: data);
    // print("response.data=${response.data}");
    posCreateOrderDb = PosCreateOrderDb.fromMap(response.data);
    return posCreateOrderDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
