import 'package:dio/dio.dart';
import '../config/url.dart';
import '../modules/announcement/models/announcment_model.dart';
import '../screens/widgets/exceptions.dart';

Future fetchAnnouncement({String pageNo = '1'}) async {
  Map<String, String> parameters = {
    'page': pageNo,
  };
  try {
    String fullUrl = '${baseUrlSchool}api/getannouncementlist';
    var response = await Dio(BaseOptions(
            receiveDataWhenStatusError: true,
            connectTimeout: 15000,
            receiveTimeout: 15000))
        .get(fullUrl, queryParameters: parameters);
    AnnouncementDb announcementListDb = AnnouncementDb.fromMap(response.data);
    return announcementListDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
