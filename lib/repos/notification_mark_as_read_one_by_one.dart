import 'package:get_storage/get_storage.dart';
import 'package:school/models/MarkAskReadOneByOneDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future notificationMarkAsReadOneByOne({required String trId}) async {
  Map<String, String> parameters = {
    'trid': trId,
  };

  try{
    String fullUrl = baseUrl_school + addNotificationMarkAsReadOneByOne;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer ${storage.read('user_token')}"}))
        .get(fullUrl, queryParameters: parameters);
    MarkAskReadOneByOne notificationMarkAsReadDb = MarkAskReadOneByOne.fromMap(response.data);
    return notificationMarkAsReadDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
