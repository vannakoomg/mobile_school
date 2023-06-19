import 'package:get_storage/get_storage.dart';
import 'package:school/models/MarkAskReadDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future notificationMarkAsRead() async {
  try{
    String fullUrl = baseUrl_school + addNotificationMarkAsReadAll;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer ${storage.read('user_token')}"}))
        .get(fullUrl);
    MarkAsReadDb notificationMarkAsReadDb = MarkAsReadDb.fromMap(response.data);
    return notificationMarkAsReadDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
