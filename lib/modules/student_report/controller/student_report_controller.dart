import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/student_report/models/subject_detail.dart';
import 'package:school/repos/aba.dart';
import 'package:school/screens/widgets/exceptions.dart';
import 'package:sizer/sizer.dart';

import '../../../config/url.dart';
import '../models/summery_report.dart';

class StudentController extends GetxController {
  final isTapOnTerm = 0.obs;
  final isloading = true.obs;
  final isloadingSummary = true.obs;
  final term = 0.obs;
  final sortEnglish = false.obs;
  final studentReport = StudentReportModel().obs;
  final summayReport = SummeryReport().obs;
  final rawBarGroups = <BarChartGroupData>[].obs;
  final touchedGroupIndex = 0.obs;
  final items = <BarChartGroupData>[].obs;
  final isNoData = false.obs;
  final listOfTerm = ["One", "Two", "Three", "Four"];
  Color colorByGrand(String g) {
    if (g.toUpperCase() == "A") {
      return Color.fromARGB(255, 0, 185, 89);
    } else if (g.toUpperCase() == "B") {
      return Color.fromARGB(255, 151, 238, 0);
    } else if (g.toUpperCase() == "C") {
      return Color.fromARGB(255, 227, 201, 3);
    } else if (g.toUpperCase() == "D") {
      return Color.fromARGB(255, 200, 94, 6);
    } else if (g.toUpperCase() == "E") {
      return Color.fromARGB(255, 35, 104, 194);
    }
    return Color.fromARGB(255, 194, 3, 3);
  }

  void changeTerm(int index) {
    term.value = index + 1;
    getStudentReport(termname: 'Term ${term.value}', isreload: false);
  }

  Future<void> getSummery() async {
    var response;
    try {
      isloadingSummary.value = true;
      response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).post(
          '${baseUrlOpensis}getReportCardSummary.php?id=${storage.read("isActive")}');
      summayReport.value = SummeryReport();
      if (response.data["status"] == 200 && response.data["data"] != []) {
        debugPrint("khmer sl khmer");
        isNoData.value = false;
        summayReport.value = SummeryReport.fromJson(response.data);
        items.clear();
        if (summayReport.value.data!.kh != null &&
            summayReport.value.data!.en != null) {
          term.value = summayReport.value.data!.kh!.length >
                  summayReport.value.data!.en!.length
              ? summayReport.value.data!.kh!.length
              : summayReport.value.data!.en!.length;
        } else {
          if (summayReport.value.data!.kh == null) {
            term.value = summayReport.value.data!.en!.length;
          } else {
            term.value = summayReport.value.data!.kh!.length;
          }
        }

        // check the last term of each term is already or not
        getStudentReport(termname: "Term ${term.value}").then((value) {
          if ((studentReport.value.data!.en!
                      .any((element) => element.totalwithletter == null) ||
                  studentReport.value.data!.en == null) &&
              (studentReport.value.data!.kh!
                      .any((element) => element.totalwithletter == null) ||
                  studentReport.value.data!.kh == null)) {
            term.value = term.value - 1;
          }
          for (int i = 0; i < term.value; ++i) {
            items.add(
              makeGroupData(
                i,
                summayReport.value.data!.en != null
                    ? summayReport.value.data!.en![i].total == null
                        ? 0
                        : double.parse(summayReport.value.data!.en![i].total!) /
                            10
                    : 0.0,
                summayReport.value.data!.kh != null &&
                        i <= summayReport.value.data!.kh!.length - 1
                    ? double.parse(summayReport.value.data!.kh![i].total!) / 10
                    : 0.0,
              ),
            );
          }
          getStudentReport(termname: "Term ${term.value}");
          isloadingSummary.value = false;
        });
      } else {
        isNoData.value = true;
      }
      isloadingSummary.value = false;
    } on DioError catch (e) {
      isloadingSummary.value = false;
      isloading.value = false;
      isNoData.value = true;
      final errorMessage = DioExceptions.fromDioError(e).toString();
      debugPrint("you have been b sl soy catched $errorMessage");
    }
  }

  Future<void> getStudentReport(
      {required String termname, bool isreload = true}) async {
    debugPrint(
        "term :: ${baseUrlOpensis}getReportCard.php?id=${storage.read("isActive")}&term=$termname");
    isloading.value = isreload;
    var response;
    try {
      response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).post(
          '${baseUrlOpensis}getReportCard.php?id=${storage.read("isActive")}&term=$termname');
      studentReport.value = StudentReportModel();
      studentReport.value = StudentReportModel.fromJson(response.data);
      debugPrint("value ${studentReport.value.data}");
      isloading.value = false;
    } on DioError catch (e) {
      isloading.value = false;
      isNoData.value = true;
      final errorMessage = DioExceptions.fromDioError(e).toString();

      debugPrint("you have been catched111333 $errorMessage");
    }
  }
}

BarChartGroupData makeGroupData(int x, double englishPoint, double khmerPoint) {
  return BarChartGroupData(
    barsSpace: 0,
    x: x,
    barRods: [
      if (englishPoint != 0.0)
        BarChartRodData(
          borderRadius: BorderRadius.circular(0),
          toY: englishPoint,
          color: Color(0xff012a4a),
          width: 7.w,
        ),
      if (khmerPoint != 0.0)
        BarChartRodData(
          borderRadius: BorderRadius.circular(0),
          toY: khmerPoint,
          color: Color(0xff468faf),
          width: 7.w,
        ),
    ],
  );
}
