class ContactUs {
  String img, title, launch;
  bool directApp;

  ContactUs(
      {required this.img,
      required this.title,
      required this.launch,
      required this.directApp});
}

List<ContactUs> mainCampusList = [
  ContactUs(
      img: 'assets/icons/contact_us_icon/cellcard.png',
      title: '099 509 998',
      launch: 'tel://099509998',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/smart.png',
      title: '016 929 985',
      launch: 'tel://016929985',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/facebook.png',
      title: 'ICS International School, Main Campus',
      launch: '836813176377920',
      directApp: true),
  ContactUs(
      img: 'assets/icons/contact_us_icon/messenger.png',
      title: 'Messenger',
      launch: 'http://m.me/836813176377920',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/telegram.png',
      title: 'Telegram',
      launch: 'https://telegram.me/icsismc',
      directApp: false),
  // ContactUs(img: 'assets/icons/contact_us_icon/telegram.png', title: 'Telegram Channel (ICSIS-Kindergarten)', launch: 'https://telegram.me/joinchat/hug8aPcEkCk5MThl', directApp: false),
  // ContactUs(img: 'assets/icons/contact_us_icon/telegram.png', title: 'Telegram Channel (ICSIS-Primary)', launch: 'https://telegram.me/joinchat/GyujXnbVjwM0OWY1', directApp: false),
  // ContactUs(img: 'assets/icons/contact_us_icon/telegram.png', title: 'Telegram Channel (ICSIS-Secondary)', launch: 'https://telegram.me/joinchat/oygKFAPlCshkYjJl', directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/email.png',
      title: 'Send E-mail',
      launch: 'mailto:info@ics.edu.kh',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/website.png',
      title: 'Website',
      launch: 'http://www.ics.edu.kh/',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/GoogleMaps.png',
      title: 'Google Maps',
      launch:
          'https://www.google.com/maps/place/ICS+International+School/@11.5611053,104.9240103,17z/data=!3m1!4b1!4m5!3m4!1s0x31095139c214cfe1:0x2def7adf627bfdbc!8m2!3d11.5611001!4d104.926199',
      directApp: false),
];

List<ContactUs> calmetteCampusList = [
  ContactUs(
      img: 'assets/icons/contact_us_icon/cellcard.png',
      title: '099 509 997',
      launch: 'tel://099509997',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/smart.png',
      title: '016 929 975',
      launch: 'tel://016929975',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/facebook.png',
      title: 'ICS International School, Calmette Campus',
      launch: '477852005691509',
      directApp: true),
  ContactUs(
      img: 'assets/icons/contact_us_icon/messenger.png',
      title: 'Messenger',
      launch: 'http://m.me/477852005691509',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/telegram.png',
      title: 'Telegram',
      launch: 'https://telegram.me/icsiscc',
      directApp: false),
  // ContactUs(img: 'assets/icons/contact_us_icon/telegram.png', title: 'Telegram Channel (ICSIS-Kindergarten)', launch: 'https://telegram.me/joinchat/hug8aPcEkCk5MThl', directApp: false),
  // ContactUs(img: 'assets/icons/contact_us_icon/telegram.png', title: 'Telegram Channel (ICSIS-Primary)', launch: 'https://telegram.me/joinchat/GyujXnbVjwM0OWY1', directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/email.png',
      title: 'Send E-mail',
      launch: 'mailto:info@ics.edu.kh',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/website.png',
      title: 'Website',
      launch: 'http://www.ics.edu.kh/',
      directApp: false),
  ContactUs(
      img: 'assets/icons/contact_us_icon/GoogleMaps.png',
      title: 'Google Maps',
      launch:
          'https://www.google.com/maps/place/ICS+Calmett+Campus/@11.582241,104.9164326,19.15z/data=!4m12!1m6!3m5!1s0x31095139c214cfe1:0x2def7adf627bfdbc!2sICS+International+School!8m2!3d11.5611001!4d104.926199!3m4!1s0x3109515e74d88fed:0xd8d2066e59cd4aeb!8m2!3d11.5823708!4d104.9170562',
      directApp: false),
];
