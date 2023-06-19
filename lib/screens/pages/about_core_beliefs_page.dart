import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CoreBeliefsPage extends StatefulWidget {
  const CoreBeliefsPage({Key? key}) : super(key: key);

  @override
  _CoreBeliefsPageState createState() => _CoreBeliefsPageState();
}

class _CoreBeliefsPageState extends State<CoreBeliefsPage> {
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Core Beliefs"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _space,
            Container(
              width: 80.w,
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
                'assets/icons/about_us_icon/core_beliefs.jpeg', fit: BoxFit.cover,
              ),
            ),
            Container(alignment: Alignment.centerLeft, padding: EdgeInsets.only(top: 10, left: 10),child: Text('We believe:', style: TextStyle(fontSize: _fontSize + 3, fontWeight: FontWeight.bold),)),
            Container(
              alignment: Alignment.centerLeft, padding: EdgeInsets.only(top: 10, left: 20, right: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('Every person is valuable and has dignity.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('Every student can learn, succeed and achieve.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('Education shapes life-long learning and is essential to the development of the whole person.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('In nurturing the well-being, growth and development of each student individually.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('That education is a shared responsibility of the student, family, school and community. Learning requires the active participation of the learner. The first priority of a student is to learn and the first priority of a teacher is to get students to learn whereas a major responsibility of the family is to nurture the desire to learn.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('The school\'s responsibility is to promote creative and analytical thinking and to foster a lifelong desire to learn.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('There is a common body of knowledge, skills, and values which all students should learn.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('We can achieve academic excellence in an environment that respects diversity.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('Academic excellence requires challenges.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                  _space,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("- ", style: TextStyle(fontSize: _fontSize + 3)),
                      Expanded(
                        child: Text('The benefits of a quality education exceed the cost.', style: TextStyle(fontSize: _fontSize)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _space => const SizedBox(height: 10);
}
