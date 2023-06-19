class AboutUs {
  String img, title, route;

  AboutUs({required this.img, required this.title, required this.route});
}

List<AboutUs> aboutUsList = [
  AboutUs(
      title: 'Introduction',
      img: 'assets/icons/about_us_icon/introduction.png',
      route: 'introduction'),
  AboutUs(
      title: 'School History',
      img: 'assets/icons/about_us_icon/school_history.png',
      route: 'school_history'),
  AboutUs(
      title: 'Vision and Mission',
      img: 'assets/icons/about_us_icon/vision_mission.png',
      route: 'vision'),
  AboutUs(
      title: 'Core Beliefs',
      img: 'assets/icons/about_us_icon/core_beliefs_icon.png',
      route: 'core_beliefs'),
  AboutUs(
      title: 'Accreditation',
      img: 'assets/icons/about_us_icon/accreditation.png',
      route: 'accreditation'),
  AboutUs(
      title: 'Campuses',
      img: 'assets/icons/about_us_icon/campus.jpg',
      route: 'campuses'),
  // AboutUs(title: 'Faculties', img: 'assets/icons/home_screen_icon/temp_image.png', route: ''),
];
