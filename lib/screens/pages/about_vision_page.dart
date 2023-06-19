import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VisionPage extends StatefulWidget {
  const VisionPage({Key? key}) : super(key: key);

  @override
  _VisionPageState createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vision and Mission"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _space,
            Container(
              width: 65.w,
              child: Image.asset(
                'assets/icons/about_us_icon/vision.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            _space,
            Container(
              child: Text(
                "Vision",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _fontSize + 3,
                  color: Color(0xff1d1a56),
                  decoration: TextDecoration.underline,
                ),
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
                    TextSpan(
                        text: '     ICS International School',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' is committed to providing an educational environment where students are encouraged towards being effective life-long learners, critical thinkers,  proficient communicators, socially adept individuals, emotionally and physically healthy people, and international citizens. Our vision is to be'),
                    TextSpan(text: ' the best provider of  educational and training services', style: TextStyle(fontStyle: FontStyle.italic)),
                    TextSpan(text: ' in the Kingdom of Cambodia.'),
                  ],
                ),
              ),
            ),
            _space,
            Container(
              child: Text(
                "Mission",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: _fontSize + 3,
                  color: Color(0xff1d1a56),
                  decoration: TextDecoration.underline,
                ),
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
                    TextSpan(
                        text: '     ICS International School',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ' will encourage all students to actively seek out their full potentials in pursuit of academic excellence through curricula that meet national and international standards.'),
                  ],
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
