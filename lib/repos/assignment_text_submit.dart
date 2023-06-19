import 'package:get_storage/get_storage.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../models/AssignmentTextSubmitDB.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future assignmentTextSubmit(
    {required String remark, required String resultId}) async {
  Map<String, String> parameters = {
    'resultid': resultId,
    'remark': remark,
  };
  try {
    String fullUrl = baseUrlSchool + assignmentText;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).post(fullUrl, queryParameters: parameters);
    AssignmentTextSubmitDb assignmentTextSubmitDb =
        AssignmentTextSubmitDb.fromMap(response.data);
    return assignmentTextSubmitDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
