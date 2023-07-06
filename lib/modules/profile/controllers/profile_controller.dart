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
        title: "Setting",
        route: 'setting',
        icon: Icon(
          Icons.settings,
          color: Colors.grey,
        ))
  ];
}

class Menu {
  String title, route;
  Widget icon;
  Menu({required this.title, required this.route, required this.icon}) {}
}
