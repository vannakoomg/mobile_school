import 'package:get_storage/get_storage.dart';
import 'package:school/models/ChangePasswordDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future userChangePassword(String _oldPassword, String _newPassword) async {
  FormData formData = FormData.fromMap({
    'old_password': _oldPassword,
    'new_password': _newPassword,
    'confirm_password': _newPassword,
  });

  try {
    String fullUrl = baseUrlSchool + changePassword;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}",
      "connectTimeout": 10 * 1000, // 10 seconds
      "receiveTimeout": 10 * 1000
    })).post(fullUrl, data: formData);
    ChangePasswordDb changePasswordDb = ChangePasswordDb.fromMap(response.data);
    return changePasswordDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
