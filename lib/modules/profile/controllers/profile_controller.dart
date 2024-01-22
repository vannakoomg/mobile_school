import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/utils/function/function.dart';

import '../../../repos/logout.dart';
import '../../../screens/pages/switch_account.dart';

class ProfileController extends GetxController {
  final isShowProfile = false.obs;
  void ontaplist({required String route, required track}) {
    tracking(campus: "", menuName: route, userName: "");
    Get.toNamed("${route}");
  }

  List<Menu> menuProfile = [
    Menu(
        title: "Student Information",
        route: 'student_info',
        icon: Icon(
          Icons.person,
          color: Colors.grey,
        )),
    Menu(
        title: "Contact Us",
        route: 'contact_us',
        icon: Icon(
          Icons.contact_page,
          color: Colors.grey,
        )),
    Menu(
      title: "About Us",
      route: 'about_us',
      icon: Icon(
        Icons.info_rounded,
        color: Colors.grey,
      ),
    ),
    Menu(
        title: "Switch Account",
        route: 'switch_accountPage',
        icon: Icon(
          Icons.settings,
          color: Colors.grey,
        ))
  ];
  String helloFromIcs() {
    int time = DateTime.now().hour;
    debugPrint("hour ${time}");
    if (time > 3 && time < 12) {
      return "Good Morning";
    } else if (time > 12 && time < 17) {
      return "Good Afternoon";
    } else if (time >= 17 && time < 19) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  late Map<String, dynamic> _mapUser;
  final storage = GetStorage();
  void logout() {
    _mapUser = storage.read('mapUser');
    bool isValue = false;
    userLogout().then((value) {
      try {
        storage.remove('exam_schedule_badge');
        storage.remove('notification_badge');
        storage.remove('assignment_badge');
        if (_mapUser.length > 1) {
          for (dynamic type in _mapUser.keys) {
            if (type == storage.read('isActive')) {
              _mapUser.remove(type);
              storage.write('mapUser', _mapUser);
              storage.remove('user_token');
              storage.remove('isActive');
              storage.remove('isName');
              storage.remove('isClassId');
              storage.remove('isUserId');
              storage.remove('isGradeLevel');
              storage.remove('isPassword');
              storage.remove('isPhoto');
              isValue = true;
              Get.offAll(() => SwitchAccountPage());
              break;
            }
          }
        }
        if (isValue == false) {
          storage.remove('user_token');
          storage.remove('isActive');
          storage.remove('isName');
          storage.remove('mapUser');
          storage.remove('isPhoto');
        }
        isShowProfile.value = false;
      } catch (err) {
        Get.defaultDialog(
          title: "Error",
          middleText: "$value",
          barrierDismissible: false,
        );
      }
    });
  }
}

class Menu {
  String title, route;
  Widget icon;
  Menu({required this.title, required this.route, required this.icon}) {}
}
