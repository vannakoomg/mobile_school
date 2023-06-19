import 'package:get_storage/get_storage.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../models/UpdateVersionDB.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future updateCurrentVersion({required String version}) async {
  Map<String, String> parameters = {
    'version': version,
    'token': storage.read('device_token')
  };

  try {
    String fullUrl = baseUrlSchool + updateVersion;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).post(fullUrl, queryParameters: parameters);
    UpdateVersionDb updateVersionDb = UpdateVersionDb.fromMap(response.data);
    return updateVersionDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
