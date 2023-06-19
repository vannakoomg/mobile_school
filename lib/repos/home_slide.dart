import 'package:school/models/SettingDB.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Future fetchHomeSlide() async {
  try {
    String fullUrl = baseUrlSchool + getHomeSlide;
    var response = await Dio(BaseOptions(
            receiveDataWhenStatusError: true,
            connectTimeout: 15000,
            receiveTimeout: 15000))
        .get(fullUrl);
    HomeSlideDb homeSlideDb = HomeSlideDb.fromMap(response.data);
    return homeSlideDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
