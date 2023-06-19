import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TeacherHomeworksAdd extends StatefulWidget {
  const TeacherHomeworksAdd({Key? key}) : super(key: key);

  @override
  _TeacherHomeworksAddState createState() => _TeacherHomeworksAddState();
}

class _TeacherHomeworksAddState extends State<TeacherHomeworksAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Homework'),
      ),
      body: Column(
        children: [
          _buildTextField(hintText: 'First Name'),
          SizedBox(
            height: 20,
          ),
          _buildTextField(hintText: 'Last Name'),
        ],
      ),
    );
  }

  Widget _buildTextField({required String hintText}) {
    return Container(
      //Type TextField
      width: 100.w * 0.8,
      height: 100.h * 0.053,
      color: Colors.blueGrey,
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10.0),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: hintText, // pass the hint text parameter here
          hintStyle: TextStyle(color: Colors.white),
        ),
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
