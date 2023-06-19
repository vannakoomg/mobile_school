import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Introduction"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _space,
            Container(
              width: 65.w,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, // Set border color
                      width: 1.0), // Set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(4.0)), // Set rounded corner radius
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(1, 3))
                  ] // Make rounded corner of border
                  ),
              child: Image.asset(
                'assets/icons/about_us_icon/introx_small.jpeg',
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  // Note: Styles for TextSpans must be explicitly defined.
                  // Child text spans will inherit styles from parent
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: '     Welcome to '),
                    TextSpan(
                        text: 'ICS International School (ICSIS).',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' Our school is staffed by an outstanding team of educators and provides a broad, challenging and dynamic environment for students to grow and develop in the pursuit of their future.'),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '     ICS International School (ICSIS) ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'has been awarded International Centre status by the University of Cambridge International Examinations (CIE). As a Cambridge International Centre (CIC KH008), ICSIS has over 10,000 educational partners in 160 countries and also offers students in Cambodia internationally renowned qualifications, recognised by universities, educational service providers and employers around the world.'),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text: '     ICSIS ',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            'provides its students with the opportunities, resources, instructions and environment to pursue academic and personal excellence through international and national curricular. ICSIS encourages them to have enquiring minds, the basic tools of learning and acquiring knowledge. Thus they will become lifelong learners, productive, and involved citizens in a changing, global society.'),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: _fontSize,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                        text:
                            '     Our programmes prepare our students to meet all requirements set by the University of Cambridge International Examinations (CIE), the United Kingdom (UK), and by the Ministry of Education, Youth and Sport (MOEYS), Cambodia.'),
                  ],
                ),
              ),
            ),
            Container(
              child: Text(
                'Our emphasis is on EDUCATION NOT RECREATION.',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: _fontSize + 1),
              ),
            ),
            _space,
            Container(
              width: 95.w,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, // Set border color
                      width: 3.0), // Set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0)), // Set rounded corner radius
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(1, 3))
                  ] // Make rounded corner of border
                  ),
              child: Image.asset(
                'assets/icons/about_us_icon/main_campus_small.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            _space,
            Container(
              width: 95.w,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, // Set border color
                      width: 3.0), // Set border width
                  borderRadius: BorderRadius.all(
                      Radius.circular(5.0)), // Set rounded corner radius
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        color: Colors.black,
                        offset: Offset(1, 3))
                  ] // Make rounded corner of border
                  ),
              child: Image.asset(
                'assets/icons/about_us_icon/calmette_campus_small.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            _space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: 20.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.shade300, // Set border color
                          width: 3.0), // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)), // Set rounded corner radius
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.white,
                            offset: Offset(1, 3))
                      ] // Make rounded corner of border
                  ),
                  child: Image.asset(
                    'assets/icons/about_us_icon/Ministry_of_Education.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 40.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.shade300, // Set border color
                          width: 3.0), // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)), // Set rounded corner radius
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.white,
                            offset: Offset(1, 3))
                      ] // Make rounded corner of border
                  ),
                  child: Image.asset(
                    'assets/icons/about_us_icon/Logo_Cambridge_Assessment.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  width: 35.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.grey.shade300, // Set border color
                          width: 3.0), // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)), // Set rounded corner radius
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.white,
                            offset: Offset(1, 3))
                      ] // Make rounded corner of border
                  ),
                  child: Image.asset(
                    'assets/icons/about_us_icon/Logo_IELTS.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
