import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/student_report/models/student_model.dart';
import 'package:sizer/sizer.dart';

class StudentController extends GetxController {
  final isTapOnTerm = 0.obs;
  final listOfTerm = [1, 2, 3, 4].obs;
  final term = 0.obs;
  final sortEnglish = false.obs;
  final isDoubleTapEnglish = false.obs;
  final scrollerEnglish = ScrollController().obs;
  final studentReport = [
    StudentReport(
      score: "50",
      subject: "Mathematics",
    ),
    StudentReport(score: "60", subject: "Reading"),
    StudentReport(score: "80", subject: "Information Communicaition Technolo"),
    StudentReport(score: "90", subject: "Social Studies"),
    StudentReport(score: "67", subject: "Khmer "),
    StudentReport(score: "70", subject: "Pysiy"),
    StudentReport(score: "76", subject: "English as a Second landuage"),
  ].obs;
  void tapTerm() {
    isTapOnTerm.value == 0 ? isTapOnTerm.value = 1 : isTapOnTerm.value = 0;
  }

  final rawBarGroups = <BarChartGroupData>[].obs;
  final showingBarGroups = <BarChartGroupData>[].obs;
  final touchedGroupIndex = 0.obs;
  final title = ['Term1', 'Term2', 'Term3'].obs;
  final items = [
    makeGroupData(0, 5.5, 6),
    makeGroupData(1, 1, 3),
    makeGroupData(2, 8, 9),
  ].obs;

  // function
  Color generateColorByPoint(double point) {
    if (point < 50) {
      return Color(0xff0d1321);
    }
    if (point >= 50 && point < 60) {
      return Color(0xff778da9);
    }
    if (point >= 60 && point < 70) {
      return Color(0xff2d6a4f);
    }
    if (point >= 70 && point < 80) {
      return Color(0xffbc6c25);
    }
    if (point >= 80 && point < 90) {
      return Color(0xffbc4749);
    }
    return Color(0xffff206e);
  }

  initState() {
    term.value = listOfTerm.length;
    scrollerEnglish.value.addListener(() {
      if (scrollerEnglish.value.position.pixels > 100.w - 40 - 60 - 100) {
        sortEnglish.value = true;
      } else {
        sortEnglish.value = false;
      }
    });
  }

  ontapEnglish() {
    isDoubleTapEnglish.value = !isDoubleTapEnglish.value;
    if (isDoubleTapEnglish.value) {
      scrollerEnglish.value.animateTo(100.w - 40 - 60,
          duration: Duration(milliseconds: 600), curve: Curves.ease);
    } else {
      scrollerEnglish.value.animateTo(0,
          duration: Duration(milliseconds: 600), curve: Curves.ease);
    }
  }

  disposeFuntion() {
    // scrollerEnglish.value.dispose();
  }
}

BarChartGroupData makeGroupData(int x, double englishPoint, double khmerPoint) {
  return BarChartGroupData(
    barsSpace: 0,
    x: x,
    barRods: [
      BarChartRodData(
        borderRadius: BorderRadius.circular(0),
        toY: englishPoint,
        color: Color(0xff012a4a),
        width: 7.w,
      ),
      BarChartRodData(
        borderRadius: BorderRadius.circular(0),
        toY: khmerPoint,
        color: Color(0xff468faf),
        width: 7.w,
      ),
    ],
  );
}
