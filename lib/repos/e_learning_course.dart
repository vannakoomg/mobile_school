import 'package:get_storage/get_storage.dart';
import 'package:school/models/eLearningCourseDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchELearningCourse(
    {String pageNo = '1',
    required String courseId,
    required String category}) async {
  Map<String, String> parameters = {
    'course_id': courseId,
    'category': category,
    'page': pageNo,
  };

  try {
    String fullUrl = baseUrlSchool + getVideoCourseList;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl, queryParameters: parameters);
    ELearningCourseDb eLearningCourseDb =
        ELearningCourseDb.fromMap(response.data);
    return eLearningCourseDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
