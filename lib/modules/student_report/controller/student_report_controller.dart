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
      debugPrint("get summery status Code : ${response.data["status"]}");
      if (response.data["status"] == 200 && response.data["data"] != []) {
        isNoData.value = false;
        summayReport.value = SummeryReport.fromJson(response.data);
        items.clear();
        term.value = summayReport.value.data!.en == null
            ? summayReport.value.data!.kh!.length
            : summayReport.value.data!.en!.length;
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
              summayReport.value.data!.kh != null
                  ? summayReport.value.data!.kh![i].total == null
                      ? 0
                      : double.parse(summayReport.value.data!.kh![i].total!) /
                          10
                  : 0.0,
            ),
          );
        }
        isloadingSummary.value = false;
      } else {
        isNoData.value = true;
      }
      isloadingSummary.value = false;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloadingSummary.value = false;
      isNoData.value = true;
      debugPrint("you have been catched2222 $errorMessage");
    }
  }

  Future<void> getStudentReport(
      {required String termname, bool isreload = true}) async {
    debugPrint("term :: $termname");
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
      isloading.value = false;
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloading.value = false;
      isNoData.value = true;
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
