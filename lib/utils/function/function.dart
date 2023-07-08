import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';

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

Future downloadImage({required String url}) async {
  await ImageDownloader.downloadImage(url,
          destination: AndroidDestinationType.custom(directory: "adsfasd"))
      .then((value) {
    debugPrint("value $value");
  });
}

Future<void> downloadImage02() async {
  Dio dio = Dio();

  try {
    var pathInStorage = await getApplicationDocumentsDirectory();
    await dio.download(
      "https://upload.wikimedia.org/wikipedia/commons/thumb/7/73/Tent_camping_along_the_Sulayr_trail_in_La_Taha%2C_Sierra_Nevada_National_Park_%28DSCF5147%29.jpg/1200px-Tent_camping_along_the_Sulayr_trail_in_La_Taha%2C_Sierra_Nevada_National_Park_%28DSCF5147%29.jpg",
      '${pathInStorage.path}/sampleimage.jpg',
      onReceiveProgress: (count, total) {
        // it'll get the current and total progress value
        var progressValue =
            'Downloading: ${((count / total) * 100).toStringAsFixed(0)}%';
        debugPrint("ksk $progressValue");
        if (count == total) {
          progressValue = 'Downloading Completed';
        }
      },
    );
  } catch (e) {
    print(e.toString());
  }
}
