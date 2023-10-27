import 'package:flutter/material.dart';

class Menu {
  String img, title, route, description;
  bool isAuthorize;
  GlobalKey globalKey;
  Menu({
    required this.img,
    required this.title,
    required this.route,
    required this.description,
    required this.isAuthorize,
    required this.globalKey,
  });
}

List<Menu> menuIconList = [
  Menu(
      img: "assets/icons/home_screen_icon_one_color/attendance.png",
      title: "Student Report",
      route: "student_report",
      isAuthorize: true),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/announcement.png",
      title: "News",
      route: 'announcement',
      isAuthorize: true),
  Menu(
      description: '',
      globalKey: GlobalKey(),
      img: "assets/icons/home_screen_icon_one_color/attendance.png",
      title: "Attendance",
      route: 'attendance_calendar',
      isAuthorize: false),
  Menu(
      description: '',
      globalKey: GlobalKey(),
      img: "assets/icons/home_screen_icon_one_color/timetable.png",
      title: "Timetables",
      route: 'timetable',
      isAuthorize: false),
  Menu(
      description: '',
      globalKey: GlobalKey(),
      img: "assets/icons/home_screen_icon_one_color/exam_schedule.png",
      title: "Exam Schedules",
      route: 'exam_schedule',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/assignment.png",
      title: "Assignments",
      route: 'homeworks',
      isAuthorize: false),
  Menu(
      description: '',
      globalKey: GlobalKey(),
      img: "assets/icons/home_screen_icon_one_color/assignment_result.png",
      title: "Assignment Results",
      route: 'class_results',
      isAuthorize: false),
];
List<Menu> menuSubIconList = [
  Menu(
      img: "assets/icons/home_screen_icon_one_color/attendance.png",
      title: "Student Report",
      route: "student_report",
      isAuthorize: true),
  Menu(
    img: "assets/icons/home_screen_icon_one_color/feedback.png",
    title: "Events",
    route: 'events',
    isAuthorize: true,
  ),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/e_learning.png",
      title: "E-Learning",
      route: 'e_learning',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/canteen.png",
      title: "Canteen",
      route: 'canteen',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/pickup_card.png",
      title: "Pick Up\nVirtual Card",
      route: 'pick_up_card',
      isAuthorize: false),
  Menu(
      description: '',
      globalKey: GlobalKey(),
      img: "assets/icons/home_screen_icon_one_color/feedback.png",
      title: "Feedback",
      route: 'feedback',
      isAuthorize: false),
  Menu(
    img: "assets/icons/home_screen_icon_one_color/feedback.png",
    title: "Events",
    route: 'events',
    isAuthorize: true,
  ),
  Menu(
    img: "assets/icons/home_screen_icon_one_color/feedback.png",
    title: "Gallary",
    route: 'gallary',
    isAuthorize: true,
  ),
];

class Canteen {
  String img, title, subtitle, route;

  Canteen(
      {required this.img,
      required this.title,
      required this.subtitle,
      required this.route});
}

List<Canteen> menuCanteenList = [
  Canteen(
      img: 'assets/icons/canteen/foods_drinks.png',
      title: 'Pre-Order (For Lunch Only)',
      subtitle: 'Please make pre-orders before 10:00AM',
      route: 'pos_order'),
  Canteen(
      img: 'assets/icons/canteen/top_up.png',
      title: 'Top Up',
      subtitle:
          'The amount will be transferred to your iWallet within 1 working day',
      route: 'top_up'),
  Canteen(
      img: 'assets/icons/canteen/iwallet_card.png',
      title: 'iWallet',
      subtitle: 'History of pre-oders and top ups',
      route: 'i_wallet'),
  Canteen(
      img: 'assets/icons/canteen/limit_purchase.png',
      title: 'Purchase Limit',
      subtitle: 'Set a daily purchase limit',
      route: 'limit_purchase'),
  Canteen(
      img: 'assets/icons/canteen/term_condition.png',
      title: 'Terms & Conditions',
      subtitle: 'Rules and Guidelines',
      route: 'terms_conditions'),
];
