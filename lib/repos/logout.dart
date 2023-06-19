import 'package:get_storage/get_storage.dart';
import 'package:school/models/LogoutDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future userLogout() async {
  FormData formData = FormData.fromMap({
    'firebasekey': storage.read('device_token'),
  });

  try {
    String fullUrl = baseUrlSchool + logout;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).post(fullUrl, data: formData);
    LogoutDb logoutDb = LogoutDb.fromMap(response.data);
    return logoutDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
