import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get_storage/get_storage.dart';
import 'package:school/models/FeedbackDB.dart';
import 'package:school/server/Server.dart';
import 'package:dio/dio.dart';
import '../screens/widgets/exceptions.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

final storage = GetStorage();
late File? _file;

String convertBase64ToString(Uint8List byteFile) {
  return base64Encode(byteFile);
}

Future sendFeedback(
    {File? file, required String category, required String question}) async {
  final dir = Directory.systemTemp;
  final targetPath = dir.absolute.path + "/temp.jpg";
  String? fileName = file != null ? file.path.split("/").last : null;
  _file = file != null ? await testCompressAndGetFile(file, targetPath) : null;

  FormData formData = FormData.fromMap({
    'category': category,
    'question': question,
    "file": file != null
        ? await MultipartFile.fromFile(_file!.path, filename: fileName)
        : null,
  });

  try {
    String fullUrl = baseUrl_school + addFeedback;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).post(fullUrl, data: formData);
    FeedbackDb feedbackDb = FeedbackDb.fromMap(response.data);

    return feedbackDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}

Future<File> testCompressAndGetFile(File file, String targetPath) async {
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, targetPath,
    quality: 40,
    // rotate: 180,
  );

  print(file.lengthSync());
  print(result!.lengthSync());

  return result;
}
