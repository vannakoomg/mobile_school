import 'package:get_storage/get_storage.dart';
import 'package:school/models/FeedbackListDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchFeedback({String pageNo = '1'}) async {
  Map<String, String> parameters = {
    'page': pageNo,
  };

  try{
    String fullUrl = baseUrl_school + getFeedback;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).get(fullUrl, queryParameters: parameters);
    FeedbackListDb feedbackListDb = FeedbackListDb.fromMap(response.data);
    return feedbackListDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
