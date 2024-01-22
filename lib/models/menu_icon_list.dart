class Menu {
  String img, title, route;
  bool isAuthorize;

  Menu({
    required this.img,
    required this.title,
    required this.route,
    required this.isAuthorize,
  });
}

List<Menu> menuIconList = [
  Menu(
      img: "assets/icons/home_screen_icon_one_color/announcement.png",
      title: "Pick Up",
      route: 'pick_up_card',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/attendance.png",
      title: "Attendance",
      route: 'attendance_calendar',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/timetable.png",
      title: "Timetables",
      route: 'timetable',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/exam_schedule.png",
      title: "Schedules",
      route: 'exam_schedule',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/canteen.png",
      title: "Canteen",
      route: 'canteen',
      isAuthorize: false),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/assignment_result.png",
      title: "Assignment",
      route: 'class_results',
      isAuthorize: false),
];
List<Menu> menuSubIconList = [
  Menu(
      img: "assets/icons/home_screen_icon_one_color/announcement.png",
      title: "News",
      route: "announcement",
      isAuthorize: true),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/attendance.png",
      title: "Student Report",
      route: "student_report",
      isAuthorize: true),
  Menu(
    img: "assets/icons/home_screen_icon_one_color/event.png",
    title: "Events",
    route: 'events',
    isAuthorize: false,
  ),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/e_learning.png",
      title: "E-Learning",
      route: 'e_learning',
      isAuthorize: false),
  Menu(
    img: "assets/icons/home_screen_icon_one_color/feedback.png",
    title: "Gallary",
    route: 'gallary',
    isAuthorize: false,
  ),
  Menu(
      img: "assets/icons/home_screen_icon_one_color/feedback.png",
      title: "Feedback",
      route: 'feedback',
      isAuthorize: false),
];

class Canteen {
  String img, title, subtitle, route, color;

  Canteen(
      {required this.img,
      required this.title,
      required this.subtitle,
      required this.route,
      required this.color});
}

List<Canteen> menuCanteenList = [
  Canteen(
    img: 'assets/icons/canteen/foods_drinks.png',
    title: 'Pre-Order (For Lunch Only)',
    subtitle: 'Please make pre-orders before 10:00AM',
    route: 'pos_order',
    color: "0xff2a9d8f",
  ),
  Canteen(
    img: 'assets/icons/canteen/top_up.png',
    title: 'Top Up',
    subtitle:
        'The amount will be transferred to your iWallet within 1 working day',
    route: 'top_up',
    color: "0xffffc300",
  ),
  Canteen(
    img: 'assets/icons/canteen/iwallet_card.png',
    title: 'iWallet',
    subtitle: 'History of pre-oders and top ups',
    route: 'i_wallet',
    color: "0xff219ebc",
  ),
  Canteen(
    img: 'assets/icons/canteen/limit_purchase.png',
    title: 'Purchase Limit',
    subtitle: 'Set a daily purchase limit',
    route: 'limit_purchase',
    color: "0xfffb8500",
  ),
  Canteen(
    img: 'assets/icons/canteen/term_condition.png',
    title: 'Terms & Conditions',
    subtitle: 'Rules and Guidelines',
    route: 'terms_conditions',
    color: "0xffc1121f",
  ),
];
