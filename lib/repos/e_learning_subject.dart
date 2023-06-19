import 'package:get_storage/get_storage.dart';
import 'package:school/models/eLearningSubjectDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchELearningSubject() async {
  try{
    String fullUrl = baseUrl_school + getCourseList;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer ${storage.read('user_token')}"}))
        .get(fullUrl);
    ELearningSubjectDb eLearningSubjectDb = ELearningSubjectDb.fromMap(response.data);
    return eLearningSubjectDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
