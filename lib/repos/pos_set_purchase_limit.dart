import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import '../models/PurchaseLimitDB.dart';
import '../screens/widgets/exceptions.dart';
import '../server/Server.dart';

final storage = GetStorage();
late PurchaseLimitDb purchaseLimitDb;

Future posPurchaseLimit({required double purchaseLimit}) async {
  Map<String, dynamic> data = {};
  data = {
    "params": {
      "route": "purchase_limit",
      "student_id": storage.read('isActive'),
      "purchase_limit": purchaseLimit
    }
  };

  try {
    // print("fetchPos");
    // String fullUrl = "http://202.62.45.129:8069/ics_canteen";
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    })).post(baseUrl_odoo, data: data);
    // print("response.data=${response.data}");
    purchaseLimitDb = PurchaseLimitDb.fromMap(response.data);
    return purchaseLimitDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
