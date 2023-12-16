import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/student_report/controller/student_report_controller.dart';
import 'package:sizer/sizer.dart';

class CustomReportTable extends StatelessWidget {
  final int index;
  final String subject;
  final String totalwithletter;
  final Color color;
  const CustomReportTable(
      {Key? key,
      required this.index,
      required this.subject,
      required this.totalwithletter,
      required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(StudentController());
    return Column(
      children: [
        if (index == 0)
          Container(
            padding: EdgeInsets.all(12),
            color: color,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Taught in English Language",
                    style: TextStyle(
                      color: AppColor.mainColor,
                      fontWeight: FontWeight.w500,
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 17 : 13.5,
                    ),
                  ),
                ),
                Text(
                  "Percentage",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 16 : 13,
                      color: AppColor.mainColor),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Grade",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 16 : 13,
                      color: AppColor.mainColor),
                ),
              ],
            ),
          ),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: index == 0 ? Colors.transparent : Colors.grey,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "$subject",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize:
                        SizerUtil.deviceType == DeviceType.tablet ? 16 : 13,
                  ),
                ),
              ),
              Text(
                "${totalwithletter.replaceRange(0, 2, '')}",
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize:
                        SizerUtil.deviceType == DeviceType.tablet ? 16 : 13,
                    color: AppColor.primaryColor.withOpacity(0.8)),
              ),
              Container(
                margin: SizerUtil.deviceType == DeviceType.tablet
                    ? EdgeInsets.only(left: 35, right: 20)
                    : EdgeInsets.only(left: 30, right: 12),
                child: Text(
                  "${totalwithletter[0]}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize:
                        SizerUtil.deviceType == DeviceType.tablet ? 16 : 14,
                    color: controller
                        .colorByGrand("${totalwithletter[0].toUpperCase()}"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
