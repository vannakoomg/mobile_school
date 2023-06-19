import 'package:get_storage/get_storage.dart';
import 'package:school/models/CalendarAttendanceDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchCalendarAttendance(
    {required String month, required String year}) async {
  Map<String, String> parameters = {
    'month': month,
    'year': year,
  };
  try {
    String fullUrl = baseUrlSchool + getCalendarAttendance;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl, queryParameters: parameters);
    CalendarAttendanceDb calendarAttendanceDb =
        CalendarAttendanceDb.fromMap(response.data);
    return calendarAttendanceDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
