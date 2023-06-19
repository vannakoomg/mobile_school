import 'package:get_storage/get_storage.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../models/AssignmentListDB.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchAssignment() async {
   try{
    String fullUrl = baseUrl_school + assignmentList;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer ${storage.read('user_token')}"}))
        .post(fullUrl);
    AssignmentListDb assignmentListDb = AssignmentListDb.fromMap(response.data);
    return assignmentListDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
