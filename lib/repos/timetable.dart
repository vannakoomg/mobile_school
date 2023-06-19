import 'package:get_storage/get_storage.dart';
import 'package:school/models/TimetableDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchTimetable(String dayOfWeek, String type) async {
  Map<String, String> parameters = {
    'week_of_day': dayOfWeek,
    'type': type,
  };

  try {
    String fullUrl = baseUrlSchool + getTimetableList;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl, queryParameters: parameters);
    TimetableDb timetableDb = TimetableDb.fromMap(response.data);
    return timetableDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
