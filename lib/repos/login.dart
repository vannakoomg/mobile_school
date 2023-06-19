import 'package:school/models/LoginDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Dio _dio = Dio();

Future userLogin(String email, String password,String firebaseToken) async {
  FormData formData = FormData.fromMap({
    'email': email,
    'password': password,
    'firebase_token': firebaseToken,
  });

  try{
    String fullUrl = baseUrl_school + login;
    var response = await _dio.post(fullUrl, data: formData);
    LoginDb loginDb = LoginDb.fromMap(response.data);
    return loginDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
