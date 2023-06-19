import 'package:get_storage/get_storage.dart';
import 'package:school/models/ExamScheduleDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchExamSchedule({String pageNo = '1'}) async {
  Map<String, String> parameters = {
    'page': pageNo,
  };
  try {
    String fullUrl = baseUrlSchool + getExamSchedule;
    var response = await Dio(BaseOptions(
            headers: {
          "Accept": "application/json",
          "Authorization": "Bearer ${storage.read('user_token')}"
        },
            receiveDataWhenStatusError: true,
            connectTimeout: 15000,
            receiveTimeout: 15000))
        .get(fullUrl, queryParameters: parameters);
    ExamScheduleDb examScheduleDb = ExamScheduleDb.fromMap(response.data);
    return examScheduleDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
