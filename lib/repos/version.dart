import 'package:school/models/SettingDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Future fetchVersion() async {
  try {
    String fullUrl = baseUrlSchool + version;
    var response = await Dio(BaseOptions(
            receiveDataWhenStatusError: true,
            connectTimeout: 15000,
            receiveTimeout: 15000))
        .get(fullUrl);
    VersionDb versionDb = VersionDb.fromMap(response.data);
    return versionDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
