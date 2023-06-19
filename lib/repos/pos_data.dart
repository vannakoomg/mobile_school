import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart';
import 'package:school/models/posDB.dart';
import '../models/PosOrderHistoryDB.dart';
import '../models/PosUserDB.dart';
import '../models/TopUpHistoryDB.dart';
import '../screens/widgets/exceptions.dart';
import '../config/url.dart';

final storage = GetStorage();
late PosDb posDb;
late PosUserDb posUserDb;
late PosOrderHistoryDb posOrderHistoryDb;
late TopUpHistoryDb topUpHistoryDb;

Future fetchPos({String route = "products"}) async {
  Map<String, dynamic> data = {};
  if (route == "products")
    data = {
      "params": {"route": "products", "campus": storage.read("campus")}
    };
  else if (route == "user")
    data = {
      "params": {"route": "user", "student_id": storage.read('isActive')}
    };
  else if (route == "order_history")
    data = {
      "params": {
        "route": "order_history",
        "student_id": storage.read('isActive')
      }
    };
  else if (route == "top_up_history")
    data = {
      "params": {
        "route": "top_up_history",
        "student_id": storage.read('isActive')
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

    if (route == "products") {
      posDb = PosDb.fromMap(response.data);
      return posDb;
    } else if (route == "user") {
      posUserDb = PosUserDb.fromMap(response.data);
      return posUserDb;
    } else if (route == "order_history") {
      posOrderHistoryDb = PosOrderHistoryDb.fromMap(response.data);
      return posOrderHistoryDb;
    } else if (route == "top_up_history") {
      topUpHistoryDb = TopUpHistoryDb.fromMap(response.data);
      return topUpHistoryDb;
    }
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
