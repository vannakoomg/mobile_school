import 'package:get_storage/get_storage.dart';
import 'package:school/models/FeedbackCategoryDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchFeedbackCategory() async {
  try {
    String fullUrl = baseUrl_school + getFeedbackCategory;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer ${storage.read('user_token')}"}))
        .get(fullUrl);
    FeedbackCategoryDb feedbackCategoryDb = FeedbackCategoryDb.fromMap(response.data);
    return feedbackCategoryDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
