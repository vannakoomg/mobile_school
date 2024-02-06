// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:sizer/sizer.dart';

import '../controller/student_report_controller.dart';

class TotalWidget extends StatelessWidget {
  String total;
  String letterGrade;
  TotalWidget({Key? key, required this.letterGrade, required this.total})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: AppColor.primaryColor),
        ),
      ),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Total",
              style: TextStyle(
                color: AppColor.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: SizerUtil.deviceType == DeviceType.tablet ? 16 : 13,
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: SizerUtil.deviceType == DeviceType.tablet
                          ? EdgeInsets.only(left: 20)
                          : EdgeInsets.only(left: 15),
                      child: Text(
                        "$letterGrade",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 16
                              : 14,
                          color: controller.colorByGrand("$letterGrade"),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    "$total%",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            SizerUtil.deviceType == DeviceType.tablet ? 16 : 13,
                        color: AppColor.primaryColor.withOpacity(0.8)),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
