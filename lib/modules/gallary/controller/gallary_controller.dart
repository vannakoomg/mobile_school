import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';

class GallaryController extends GetxController {
  final islist = false.obs;
  List<String> listOfImage = [
    "https://media.istockphoto.com/id/1077185594/photo/happy-students-throwing-papers-while-celebrating-the-end-of-a-school-year-in-the-classroom.jpg?s=170667a&w=0&k=20&c=eGfkjim8mW_CDIfQ7reIv4KL4LGXVLJ6CmHVs_cNcvo=",
    "https://gdb.voanews.com/51CB82F4-70B8-4886-B9BC-D0E58469D0E4_cx0_cy6_cw0_w1200_r1.jpg",
    "https://www.schooleducationgateway.eu/files/jpg11/adobestock_277896487_edited.jpeg",
    "https://www.reigate-school.surrey.sch.uk/ckfinder/userfiles/images/Reigate_School_Home_1.jpg",
    "https://media-assets-ggwp.s3.ap-southeast-1.amazonaws.com/2021/10/profil-onic-ladies-4.jpg",
    "https://m.phnompenhpost.com/sites/default/files/field/image/students_at_siem_reap_towns_wat_bo_primary_school_line_up_in_the_morning_to_sing_the_national_anthem_and_recite_a_list_of_moral_and_social_values._wat_bo_primary_school.jpg"
  ].obs;
  final oldColor = 0.obs;
  final tagId = ''.obs;
  final urlImage = ''.obs;
  int getflex() {
    return Random().nextInt(3) + 1;
  }

  void downloadImage({required String url}) async {
    var imageId = await ImageDownloader.downloadImage(url).then((value) {
      debugPrint("value $value");
    });
  }

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

  Color getColor() {
    int i = Random().nextInt(8);
    if (oldColor.value == i) {
      i = Random().nextInt(8);
      if (oldColor.value == i) {
        i = Random().nextInt(8);
      }
    }
    oldColor.value = i;
    if (i == 0) {
      return Color(0xff012a4a);
    }
    if (i == 1) {
      return Color(0xffa3cef1);
    }
    if (i == 2) {
      return Color(0xffef476f);
    }
    if (i == 3) {
      return Color(0xffd5896f);
    }
    if (i == 4) {
      return Color(0xff48cae4);
    }
    if (i == 5) {
      return Color(0xffffafcc);
    }
    if (i == 6) {
      return Color(0xff70a288);
    }
    if (i == 7) {
      return Color(0xff2c7da0);
    }
    return Color(0xff2c7da0);
  }
}
