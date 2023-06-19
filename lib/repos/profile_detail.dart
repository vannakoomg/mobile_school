import 'package:school/models/ProfileDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Future fetchProfile({required String apiKey}) async {
  try {
    String fullUrl = baseUrlSchool + getProfile;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer $apiKey"
    })).get(fullUrl);
    // print("response.data=${response.data}");
    ProfileDb profileDb = ProfileDb.fromMap(response.data);
    return profileDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
