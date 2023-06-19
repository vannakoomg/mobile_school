// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future getImageNetwork({ImageSource imageSource = ImageSource.gallery}) async {
  late File _file;
  final picker = ImagePicker();
  final pickedImage = await picker.getImage(source: imageSource);
  if (pickedImage != null) {
    _file = File(pickedImage.path);
    return _file;
  } else {
    print("No Image selected");
  }
}
