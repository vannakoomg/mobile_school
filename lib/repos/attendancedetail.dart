import 'package:get_storage/get_storage.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../models/AttendanceDetailDB.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchAttendanceDetail({required String date}) async {
  Map<String, String> parameters = {'date': date};

  try {
    String fullUrl = baseUrlSchool + getAttendanceDetail;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl, queryParameters: parameters);
    print("response.data=${response.data}");
    AttandanceDetailDb attendanceDetailDb =
        AttandanceDetailDb.fromMap(response.data);
    return attendanceDetailDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
