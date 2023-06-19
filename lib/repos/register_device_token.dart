import 'package:school/models/registerDeviceTokenDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Dio _dio = Dio();

Future fetchRegisterDeviceToken(String firebaseToken, String model,String osType) async {
  Map<String, String> parameters = {
    'firebase_token': firebaseToken,
    'model': model,
    'os_type': osType,
  };

  try{
    String fullUrl = baseUrl_school + registerFirebase;
    var response = await _dio.get(fullUrl, queryParameters: parameters);
    RegisterDeviceTokenDb registerDeviceTokenDb = RegisterDeviceTokenDb.fromMap(response.data);
    return registerDeviceTokenDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
