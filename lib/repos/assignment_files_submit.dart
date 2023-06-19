import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_storage/get_storage.dart';
import 'package:school/config/url.dart';
import 'package:dio/dio.dart';
import '../models/AssignmentFilesSubmitDB.dart';
import '../screens/widgets/exceptions.dart';
import 'feedback.dart';

final storage = GetStorage();
late File? _file;

String convertBase64ToString(Uint8List byteFile) {
  return base64Encode(byteFile);
}

Future assignmentFilesSubmit(
    {File? file, required String resultId, required String doc}) async {
  final dir = Directory.systemTemp;
  final targetPath = dir.absolute.path + "/temp.jpg";
  String? fileName = file != null ? file.path.split("/").last : null;
  if (doc == "Image")
    _file =
        file != null ? await testCompressAndGetFile(file, targetPath) : null;
  else
    _file = file ?? null;

  print("_file=$_file");

  FormData formData = FormData.fromMap({
    'resultid': resultId,
    'file': file != null
        ? await MultipartFile.fromFile(_file!.path, filename: fileName)
        : null,
  });
  try {
    String fullUrl = baseUrlSchool + assignmentFiles;
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Authorization": "Bearer ${storage.read('user_token')}"
    })).post(fullUrl, data: formData);
    AssignmentFilesSubmitDb assignmentFilesSubmitDb =
        AssignmentFilesSubmitDb.fromMap(response.data);
    return assignmentFilesSubmitDb;
  } on DioError catch (e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    return errorMessage;
  }
}
