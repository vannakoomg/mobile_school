import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final isShowProfile = false.obs;
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
}

class Menu {
  String title, route;
  Widget icon;
  Menu({required this.title, required this.route, required this.icon}) {}
}
