import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:school/config/url.dart';

Future downloadImage({required String url}) async {
  await ImageDownloader.downloadImage(
    url,
  ).then((value) {
    debugPrint("value $value");
  });
}

void tracking(String action) async {
  try {
    var response = await Dio(BaseOptions(headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    })).post('$baseUrlSchool' + 'api/tracking', data: {'name': action});
    debugPrint("tracking statusCode : ${response.statusCode}");
  } catch (value) {
    debugPrint("you have catch $value");
  }
}
