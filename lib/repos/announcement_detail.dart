import 'package:school/models/AnnouncementDetailDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Dio _dio = Dio();
Future fetchAnnouncementDetail({required String announcementID}) async {
  Map<String, String> parameters = {
    'announcement_id': announcementID,
  };
  try{
    String fullUrl = baseUrl_school + getAnnouncementDetail;
    var response = await _dio.get(fullUrl, queryParameters: parameters);
    AnnouncementDetailDb announcementDetailDb = AnnouncementDetailDb.fromMap(response.data);
    return announcementDetailDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
