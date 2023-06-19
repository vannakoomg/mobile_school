import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccreditationPage extends StatefulWidget {
  const AccreditationPage({Key? key}) : super(key: key);

  @override
  _AccreditationPageState createState() => _AccreditationPageState();
}

class _AccreditationPageState extends State<AccreditationPage> {
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accreditation"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    TextSpan(
                        text: '     ICS International School (ICSIS)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' has been awarded International Centre status by the University of Cambridge International Examinations (CIE). As a '),
                    TextSpan(
                        text: 'Cambridge International Centre (CIC KH008), ICSIS',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                        ' has over 10,000 educational partners in 160 countries and also offers students in Cambodia internationally renowned qualifications, recognised by universities, educational service providers and employers around the world. '),
                    TextSpan(
                        text: 'ICSIS',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                        ' provides its students with the opportunities, resources, instructions and environment to pursue academic and personal excellence through international and national curricular. '),
                    TextSpan(
                        text: 'ICSIS',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                        ' encourages them to have enquiring minds, the basic tools of learning and acquiring knowledge. Thus they will become lifelong learners, productive and involved citizens in a changing, global society. Our programmes prepare our students to meet all requirements set by the University of Cambridge International Examinations (CIE), the United Kingdom (UK), and by the Ministry of Education, Youth and Sport (MOEYS), Cambodia.'),
                  ],
                ),
              ),
            ),
            _space,
            Container(
              width: 35.w,
              child: Image.asset(
                'assets/icons/about_us_icon/Ministry_of_Education.png', fit: BoxFit.cover,
              ),
            ),
            _space,
            _space,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 8.h,
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
                    'assets/icons/about_us_icon/Logo_IELTS.jpg', fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 8.h,
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
                    'assets/icons/about_us_icon/Logo_Cambridge_Assessment.jpg', fit: BoxFit.cover,
                  ),
                ),
              ],
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
              child: InteractiveViewer(
                child: Image.asset(
                  'assets/icons/about_us_icon/resizex1.jpg', fit: BoxFit.cover,
                ),
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
              child: InteractiveViewer(
                child: Image.asset(
                  'assets/icons/about_us_icon/resizex2.jpg', fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
