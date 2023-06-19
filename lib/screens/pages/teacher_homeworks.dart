import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/screens/pages/teacher_homeworks_add.dart';
import 'package:sizer/sizer.dart';

class TeacherHomeworks extends StatefulWidget {
  const TeacherHomeworks({Key? key}) : super(key: key);

  @override
  _TeacherHomeworksState createState() => _TeacherHomeworksState();
}

class _TeacherHomeworksState extends State<TeacherHomeworks> {
  // late Map<String, dynamic> _mapTeacherHomework = {
  //   'classLevel': '7A',
  //   'data': [
  //     Subject(
  //         course: 'Python Basics',
  //         description: 'Intro to Computer Science',
  //         type: 'Assignment')
  //   ],
  // };

  //  final List<String> _homework = [
  //    (classLevel: '7A', data: [Subject(course: 'Python Basics', description: 'Intro to Computer Science', type: 'Assignment')])
  //  ];

  final list = const [
    {
      'Year': '2020',
      'Subject': [
        {
          'id': 1,
        }
      ],
    },
  ];

  final map = [
    {
      "name": "my name",
      "date": "14 Feb 2020",
      "days": ['5'],
    }
  ];

  @override
  void initState() {
    super.initState();
    print("list=${map[0]['days']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homework"),
      ),
      body: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          physics: PageScrollPhysics(),
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                Container(
                  // alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 10),
                  height: 50.0,
                  color: Colors.teal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.book_outlined, color: Colors.white),
                      Padding(padding: const EdgeInsets.only(right: 5.0)),
                      Text('',
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.white)),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) => Container(
                    // width: 100.w,
                    child: InkWell(
                      onTap: () {
                        // Get.to(() => TeacherHomeworksAdd());
                      },
                      child: Card(
                          // color: Colors.blue,
                          child: Row(
                        children: [
                          SizedBox(
                            height: 10.h,
                            width: 1.5.w,
                            child: const DecoratedBox(
                              decoration: const BoxDecoration(
                                  color: Colors.deepPurpleAccent),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: 95.w,
                            height: 11.h,
                            // color: Colors.yellow,
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Python Basics'),
                                    Text('65%'),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: 60.w,
                                        child: Text(
                                          'Intro to Computer Science Intro to Computer Science Intro to Computer Science Intro to Computer Science ',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                    Container(
                                        width: 30.w,
                                        alignment: Alignment.centerRight,
                                        child: Text('10:10PM')),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Assignment'),
                                    Text('Tue, Sep 7'),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                  ),
                ),
                // new SizedBox(height: 20.0),
              ],
            );
          },
        ),
      ),
      floatingActionButton: _bottomButtons(),
    );
  }

  Widget? _bottomButtons() {
    return FloatingActionButton(
        shape: StadiumBorder(),
        onPressed: () {
          Get.to(() => TeacherHomeworksAdd());
        },
        backgroundColor: Colors.teal,
        child: Icon(
          Icons.add,
          size: 20.0,
        ));
  }
}
