import 'package:get_storage/get_storage.dart';
import 'package:school/models/CollectionCardDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';

final storage = GetStorage();

Future fetchCollectionCard({required String userToken}) async {
  try{
    String fullUrl = baseUrl_school + getCollectionCard;
    var response = await Dio(BaseOptions(headers: {"Accept":
    "application/json", "Authorization" : "Bearer $userToken"}))
        .get(fullUrl);
    CollectionCardDb collectionCardDb = CollectionCardDb.fromMap(response.data);
    return collectionCardDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
