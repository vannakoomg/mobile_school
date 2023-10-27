import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/student_report/models/student_model.dart';
import 'package:school/screens/widgets/exceptions.dart';
import 'package:sizer/sizer.dart';

import '../../../config/url.dart';
import '../models/summery_report.dart';

class StudentController extends GetxController {
  final isTapOnTerm = 0.obs;
  final isloading = false.obs;
  final isloadingSummary = false.obs;
  final term = 0.obs;
  final sortEnglish = false.obs;
  final studentReport = StudentReportModel().obs;
  final summayReport = SummeryReport().obs;
  final rawBarGroups = <BarChartGroupData>[].obs;
  final touchedGroupIndex = 0.obs;
  final items = <BarChartGroupData>[].obs;
  void changeTerm(int index) {
    term.value = index - 1;
    getStudentReport(termname: 'Term $index', isreload: false);
  }

  Future<void> getSummery() async {
    var response;
    try {
      isloadingSummary.value = true;
      response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).post('${baseUrlOpensis}getReportCardSummary.php?id=IS201931');
      isloadingSummary.value = false;
      summayReport.value = SummeryReport();
      summayReport.value = SummeryReport.fromJson(response.data);
      items.clear();
      term.value = summayReport.value.data!.en!.length - 1;
      for (int i = 0; i < summayReport.value.data!.en!.length; ++i) {
        items.add(makeGroupData(
            i,
            double.parse(summayReport.value.data!.en![i].total!) / 10,
            double.parse(summayReport.value.data!.kh![i].total!) / 10));
      }
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloadingSummary.value = false;
      debugPrint("you have been catched $errorMessage");
    }
  }

  Future<void> getStudentReport(
      {required String termname, bool isreload = true}) async {
    isloading.value = isreload;
    var response;
    try {
      response = await Dio(BaseOptions(headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      })).post('${baseUrlOpensis}getReportCard.php?id=IS201931&term=$termname');
      isloading.value = false;
      studentReport.value = StudentReportModel();
      studentReport.value = StudentReportModel.fromJson(response.data);

      debugPrint("data 12313123 ${studentReport.value.data!.term}");
    } on DioError catch (e) {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      isloading.value = false;
      debugPrint("you have been catched $errorMessage");
    }
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
