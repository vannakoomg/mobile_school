import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';

double getHigh() {
  int i = Random().nextInt(4);
  if (i == 0) {
    return 300;
  }
  if (i == 1) {
    return 150;
  }
  if (i == 2) {
    return 180;
  }
  if (i == 3) {
    return 220;
  }
  return 0;
}

void downloadImage({required String url}) async {
  await ImageDownloader.downloadImage(url).then((value) {
    debugPrint("value $value");
  });
}
