import 'package:get_storage/get_storage.dart';
import 'package:school/models/NotificationDetailDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchNotificationDetail({required String trId}) async {
  Map<String, String> parameters = {
    'trid': trId,
  };

  try {
    String fullUrl = baseUrlSchool + getNotificationDetail;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl, queryParameters: parameters);
    NotificationDetailDb notificationDetailDb =
        NotificationDetailDb.fromMap(response.data);
    return notificationDetailDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
