import 'dart:io';
import 'dart:typed_data';

import 'package:multi_image_picker2/multi_image_picker2.dart';

Future fetchMultipleImagesNetwork({required List<Asset> listImage}) async {
  if (listImage.isNotEmpty) {
    ByteData bytesData = await listImage.first.getByteData();
    List<int> bytes = bytesData.buffer
        .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes)
        .cast<int>();
    //get the extension jpeg, png, jpg
    print("listImage.first.name=${listImage.first.name}");
    String extension = (listImage.first.name ?? '').split('.').last;
    print("extension=$extension");

    final dir = Directory.systemTemp;
    final targetPath = dir.absolute.path + "/temp.jpg";
    // String? fileName = file != null ? file.path.split("/").last : null;

    //get path to the temporaryDirector

    //get the path to the chosen directory

    //create a temporary file to the specified path
    //you can use the path to this file for the API
    // File file = File('$directoryPath/myImage.$extension');
    File file = File(targetPath);

    //write the bytes to the image
    file.writeAsBytesSync(bytes, mode: FileMode.write);
    print("file==$file");
    //just for path: file.path -> will return a String with the path
    return file;
  }

  //listImage is your list assets.
  // for (int i = 0; i < listImage.length; i++) {
  //   var path = await FlutterAbsolutePath.getAbsolutePath(listImage[i].identifier);
  //   multipart.add(await MultipartFile.fromFile(path, filename: 'myfile.jpg'));
  // }
  // FormData imageFormData = FormData.fromMap({"files": multipart,});
}

Future<File> getImageFileFromAsset(String path) async {
  final file = File(path);
  return file;
}
