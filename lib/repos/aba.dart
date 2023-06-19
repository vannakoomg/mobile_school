import 'package:get_storage/get_storage.dart';
import 'package:school/models/ABAQRDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchABA() async {
  try {
    String fullUrl = baseUrlSchool + getAbaList;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl);
    AbaQrDb abaDb = AbaQrDb.fromMap(response.data);
    return abaDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
