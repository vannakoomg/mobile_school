import 'package:get_storage/get_storage.dart';
import 'package:school/models/AssignmentDetailDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchAssignmentDetail({required String id}) async {
  Map<String, String> parameters = {
    'homeworkid': id,
  };

  try {
    String fullUrl = baseUrlSchool + assignmentDetail;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).post(fullUrl, queryParameters: parameters);
    AssignmentDetailDb assignmentDetailDb =
        AssignmentDetailDb.fromMap(response.data);
    return assignmentDetailDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
