import 'package:get_storage/get_storage.dart';
import 'package:school/models/NotificationListDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchNotification({String pageNo = '1', String read = '1'}) async {
  Map<String, String> parameters = {
    'read': read,
    'page': pageNo,
    'firebasekey': storage.read('device_token'),
  };

  try{
    String fullUrl = baseUrl_school + getNotificationList;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer ${storage.read('user_token')}"}))
        .get(fullUrl, queryParameters: parameters);
    NotificationListDb notificationListDb = NotificationListDb.fromMap(response.data);
    return notificationListDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
