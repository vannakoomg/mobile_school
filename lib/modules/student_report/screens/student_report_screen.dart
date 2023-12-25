import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/student_report/controller/student_report_controller.dart';
import 'package:school/modules/student_report/screens/flowchat.dart';
import 'package:school/modules/student_report/screens/report_table.dart';
import 'package:school/utils/widgets/blank_screen.dart';
import 'package:sizer/sizer.dart';

import '../../../utils/function/function.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({Key? key}) : super(key: key);

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

final controller = Get.put(StudentController());

class _StudentReportScreenState extends State<StudentReportScreen> {
  @override
  void initState() {
    disablescreenShot();
    controller.getSummery().then((value) {
      controller.getStudentReport(termname: "Term ${controller.term.value}");
    });
    super.initState();
  }

  void dispose() {
    ablescreenShot();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
          title: Text(
        "Report Card",
      )),
      body: Obx(
        () => controller.isloading.value == false &&
                controller.isloadingSummary.value == false
            ? controller.isNoData.value
                ? BlankPage()
                : Stack(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          margin: SizerUtil.deviceType == DeviceType.tablet
                              ? EdgeInsets.only(left: 20, right: 20, top: 20)
                              : EdgeInsets.only(left: 10, right: 10, top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "School Year  ${controller.studentReport.value.data!.schoolyear}",
                                  style: TextStyle(
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 20
                                          : 18,
                                      color: AppColor.primaryColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Flowchat(),
                              Container(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                width: 100.w,
                                child: Row(
                                  children: [
                                    Text(
                                      "Term ",
                                      style: TextStyle(
                                          fontSize: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 18
                                              : 16,
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        for (int i = 0;
                                            i <
                                                controller.summayReport.value
                                                    .data!.en!.length;
                                            ++i)
                                          GestureDetector(
                                            onTap: () {
                                              controller.changeTerm(i);
                                            },
                                            child: Container(
                                              margin: EdgeInsets.only(left: 10),
                                              height: SizerUtil.deviceType ==
                                                      DeviceType.tablet
                                                  ? 40
                                                  : 30,
                                              width: SizerUtil.deviceType ==
                                                      DeviceType.tablet
                                                  ? 40
                                                  : 30,
                                              decoration: BoxDecoration(
                                                color:
                                                    controller.term.value - 1 ==
                                                            i
                                                        ? Color(0xff2a9d8f)
                                                        : Colors.transparent,
                                                border: Border.all(
                                                    color: Color(0xff2a9d8f)),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "${i + 1}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: controller.term
                                                                      .value -
                                                                  1 ==
                                                              i
                                                          ? Colors.white
                                                          : Color(0xff274c77),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              if (controller.studentReport.value.data!.en !=
                                  null)
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: 20,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: controller
                                        .studentReport.value.data!.en!
                                        .asMap()
                                        .entries
                                        .map((element) {
                                      return CustomReportTable(
                                          title: "Taught in English Language",
                                          color: Color(0xff012a4a),
                                          index: element.key,
                                          subject: element.value.subject ?? "",
                                          totalwithletter:
                                              element.value.totalwithletter ??
                                                  "");
                                    }).toList(),
                                  ),
                                ),
                              if (controller.studentReport.value.data!.kh !=
                                  null)
                                Container(
                                  margin: EdgeInsets.only(
                                    bottom: 10,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    children: controller
                                        .studentReport.value.data!.kh!
                                        .asMap()
                                        .entries
                                        .map((element) {
                                      return CustomReportTable(
                                          title: "Taught in Khmer Language",
                                          color: Color(0xff468faf),
                                          index: element.key,
                                          subject: element.value.subject ?? "",
                                          totalwithletter:
                                              element.value.totalwithletter ??
                                                  "");
                                    }).toList(),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
            : Center(
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              ),
      ),
    );
  }
}
