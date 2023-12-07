import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/url.dart';
import 'package:school/models/ExamScheduleDB.dart';
import 'package:school/modules/canteen/models/menu_model.dart';
import 'package:school/repos/pos_data.dart';

class CanteenController extends GetxController {
  final Dio _dio = Dio();
  final isMuteCanteen = 1.obs;
  final isShowMenu = false.obs;
  final isNoMenu = false.obs;
  final menu = MenuModel().obs;
  final now = DateTime.now();
  Future<void> fetchMenu() async {
    isNoMenu.value = true;
    String date = DateFormat('yyyy/MM/dd').format(now);
    try {
      await _dio
          .get(
        '${baseUrlSchool}api/menu?date=$date',
      )
          .then((value) {
        if (value.data['status'] == 200) {
          isNoMenu.value = false;
          menu.value = MenuModel.fromJson(value.data);
        } else {
          isNoMenu.value = true;
        }
      });
    } catch (e) {
      debugPrint('you have catch on fetchMenu: $e');
    }
  }

  void ontapMenu() {
    debugPrint("ddd");
    isShowMenu.value = !isShowMenu.value;
  }

  Future<void> updateNotificationMenu({required value}) async {
    debugPrint("user ${storage.read('isActive')}");
    value ? isMuteCanteen.value = 1 : isMuteCanteen.value = 0;
    debugPrint("data ${isMuteCanteen.value} : ${storage.read('isActive')}");
    try {
      await _dio.post(
        '${baseUrlSchool}api/menu',
        data: {
          'user': storage.read('isActive'),
          'mute': isMuteCanteen.value,
        },
      );
      debugPrint("update Notification menu to user Done");
    } catch (e) {
      debugPrint('you have been on catch: $e');
    }
  }
}
