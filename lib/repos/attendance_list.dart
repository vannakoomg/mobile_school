import 'package:get_storage/get_storage.dart';
import 'package:school/models/AttendanceDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchAttendance({String pageNo = '1'}) async {
  Map<String, String> parameters = {
    'student_id': '${storage.read('isActive')}',
    'page': pageNo,
  };
  try {
    String fullUrl = baseUrlSchool + getAttendanceList;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl, queryParameters: parameters);
    AttendanceDb attendanceListDb = AttendanceDb.fromMap(response.data);
    return attendanceListDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
