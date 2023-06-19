import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/screens/pages/homeworks_page.dart';
import 'package:school/screens/pages/teacher_homeworks.dart';

class HomeworksPortal extends StatefulWidget {
  const HomeworksPortal({Key? key}) : super(key: key);

  @override
  State<HomeworksPortal> createState() => _HomeworksPortalState();
}

class _HomeworksPortalState extends State<HomeworksPortal> {
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return storage.read('isName') != 'Teacher' ? TeacherHomeworks() : HomeworksPage();
  }
}
