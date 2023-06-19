import 'package:school/models/AnnouncementDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Future fetchAnnouncement({String pageNo = '1'}) async {
  Map<String, String> parameters = {
    'page': pageNo,
  };
  try{
    String fullUrl = baseUrl_school + getAnnouncementList;
    var response = await Dio(BaseOptions(receiveDataWhenStatusError: true, connectTimeout: 15000, receiveTimeout: 15000))
        .get(fullUrl, queryParameters: parameters);
    AnnouncementDb announcementListDb = AnnouncementDb.fromMap(response.data);
    return announcementListDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
