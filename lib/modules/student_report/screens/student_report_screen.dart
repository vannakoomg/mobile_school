import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/student_report/controller/student_report_controller.dart';
import 'package:school/modules/student_report/screens/flowchat.dart';
import 'package:school/modules/student_report/screens/report_table.dart';
import 'package:school/modules/student_report/widgets/total.dart';
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
    // disablescreenShot();
    controller.getSummery();
    super.initState();
  }

  void dispose() {
    ablescreenShot();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 223, 223),
      appBar: AppBar(
          title: Text(
        "Report Card",
      )),
      body: Obx(
        () => controller.isloading.value == false &&
                controller.isloadingSummary.value == false
            ? controller.isNoData.value
                ? BlankPage()
                : SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(
                        left:
                            SizerUtil.deviceType == DeviceType.tablet ? 20 : 10,
                        right:
                            SizerUtil.deviceType == DeviceType.tablet ? 20 : 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 20, top: 20),
                            child: Center(
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
                                        i < controller.term.value;
                                        ++i)
                                      GestureDetector(
                                        onTap: () {
                                          controller.changeTerm(i);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(left: 10),
                                          height: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 45
                                              : 35,
                                          width: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 45
                                              : 35,
                                          decoration: BoxDecoration(
                                            color:
                                                controller.term.value - 1 == i
                                                    ? Color(0xff2a9d8f)
                                                    : Colors.transparent,
                                            border: Border.all(
                                                color: Color(0xff2a9d8f)),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${controller.listOfTerm[i]}",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: controller.term.value -
                                                              1 ==
                                                          i
                                                      ? Colors.white
                                                      : Color(0xff274c77),
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (controller.studentReport.value.data!.en != null &&
                              !controller.studentReport.value.data!.en!.any(
                                  (element) => element.totalwithletter == null))
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: controller
                                        .studentReport.value.data!.en!
                                        .asMap()
                                        .entries
                                        .map((element) {
                                      return element.value.totalwithletter !=
                                              null
                                          ? CustomReportTable(
                                              title: "International Programme",
                                              color: Color(0xff012a4a),
                                              index: element.key,
                                              subject:
                                                  element.value.subject ?? "",
                                              totalwithletter: element
                                                      .value.totalwithletter ??
                                                  "")
                                          : SizedBox();
                                    }).toList(),
                                  ),
                                  TotalWidget(
                                      letterGrade:
                                          "${controller.summayReport.value.data!.en![controller.term.value - 1].letter_grade}",
                                      total:
                                          "${controller.summayReport.value.data!.en![controller.term.value - 1].total}")
                                ],
                              ),
                            ),
                          if (controller.studentReport.value.data!.kh != null &&
                              !controller.studentReport.value.data!.kh!.any(
                                  (element) => element.totalwithletter == null))
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: controller
                                        .studentReport.value.data!.kh!
                                        .asMap()
                                        .entries
                                        .map((element) {
                                      return CustomReportTable(
                                        title: "National Programme",
                                        color: Color(0xff468faf),
                                        index: element.key,
                                        subject: element.value.subject ?? "",
                                        totalwithletter:
                                            element.value.totalwithletter ?? "",
                                      );
                                    }).toList(),
                                  ),
                                  TotalWidget(
                                      letterGrade:
                                          "${controller.summayReport.value.data!.kh![controller.term.value - 1].letter_grade}",
                                      total:
                                          "${controller.summayReport.value.data!.kh![controller.term.value - 1].total}")
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
            : Center(
                child: CircularProgressIndicator(color: AppColor.primaryColor),
              ),
      ),
    );
  }
}
