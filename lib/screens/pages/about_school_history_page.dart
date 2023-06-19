import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SchoolHistoryPage extends StatefulWidget {
  const SchoolHistoryPage({Key? key}) : super(key: key);

  @override
  _SchoolHistoryPageState createState() => _SchoolHistoryPageState();
}

class _SchoolHistoryPageState extends State<SchoolHistoryPage> {
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("School History"),
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
                    TextSpan(text: '     In 1993, '),
                    TextSpan(
                        text: 'ICS Group',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text:
                            ', a joint venture between Cambodian and Singaporean individuals dedicated to educational excellence, founded the Information Computer School ('),
                    TextSpan(
                        text: 'ICS',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: '), the first and leading IT training center in the Kingdom of Cambodia. Among thousands of its graduates, some have come from the public sector while others are from international organizations and NGOs. In 1999, an English Language Institute, specializing in teaching practical ways to speak English correctly and easily, was added to our operations. Finally, in response to the growing needs of parents interested in getting quality education for their children at an affordable price, the '),
                    TextSpan(
                        text: 'ICS International School',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' opened its doors in 2005.',),
                  ],
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
              child: Image.asset(
                'assets/icons/about_us_icon/main_campus_small.jpeg', fit: BoxFit.cover,
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
                'assets/icons/about_us_icon/oldoldbuilding1.jpeg', fit: BoxFit.cover,
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
                'assets/icons/about_us_icon/oldoldbuilding2.jpeg', fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
