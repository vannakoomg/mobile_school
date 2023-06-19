import 'package:school/models/DateTimeDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

Future fetchDateTime() async {
  try{
    String fullUrl = baseUrl_school + getDateTime;
    var response = await Dio(BaseOptions(receiveDataWhenStatusError: true, connectTimeout: 15000, receiveTimeout: 15000))
        .get(fullUrl);
    DateTimeDb dateTimeDb = DateTimeDb.fromMap(response.data);
    return dateTimeDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
