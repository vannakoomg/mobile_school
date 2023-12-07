import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/student_report/controller/student_report_controller.dart';
import 'package:school/modules/student_report/screens/flowchat.dart';
import 'package:school/utils/widgets/blank_screen.dart';
import 'package:sizer/sizer.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({Key? key}) : super(key: key);

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

final controller = Get.put(StudentController());

class _StudentReportScreenState extends State<StudentReportScreen> {
  @override
  void initState() {
    controller.getSummery().then((value) {
      controller.getStudentReport(termname: "Term ${controller.term.value}");
    });
    super.initState();
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
                                  "School Year : ${controller.studentReport.value.data!.schoolyear}",
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
                                      "Taught in English Language",
                                      style: TextStyle(
                                          fontSize: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 18
                                              : 16,
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        for (int i = 0;
                                            i <
                                                controller.summayReport.value
                                                    .data!.en!.length;
                                            ++i)
                                          GestureDetector(
                                            onTap: () {
                                              debugPrint("i ====$i");
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
                                Column(
                                  children: [
                                    Container(
                                      width: 100.w,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: controller
                                            .studentReport.value.data!.en!
                                            .asMap()
                                            .entries
                                            .map((element) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: element.key == 0
                                                      ? Colors.transparent
                                                      : Colors.grey,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${element.value.subject}",
                                                    style: TextStyle(
                                                      color:
                                                          AppColor.primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: SizerUtil
                                                                  .deviceType ==
                                                              DeviceType.tablet
                                                          ? 16
                                                          : 13,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  child: Text(
                                                    "${element.value.totalwithletter}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: SizerUtil
                                                                    .deviceType ==
                                                                DeviceType
                                                                    .tablet
                                                            ? 16
                                                            : 13,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.only(left: 20, right: 20),
                                    //   height:
                                    //       SizerUtil.deviceType == DeviceType.tablet
                                    //           ? 50
                                    //           : 40,
                                    //   width: double.infinity,
                                    //   decoration: BoxDecoration(
                                    //       color: AppColor.mainColor,
                                    //       borderRadius: BorderRadius.circular(50)),
                                    //   child: Row(children: [
                                    //     Text(
                                    //       "Total",
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: SizerUtil.deviceType ==
                                    //                 DeviceType.tablet
                                    //             ? 17
                                    //             : 15,
                                    //       ),
                                    //     ),
                                    //     Spacer(),
                                    //     Text(
                                    //       "${controller.studentReport.value.data!.language!.total!.en ?? ''}",
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: SizerUtil.deviceType ==
                                    //                 DeviceType.tablet
                                    //             ? 17
                                    //             : 15,
                                    //       ),
                                    //     ),
                                    //   ]),
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                              if (controller.studentReport.value.data!.kh !=
                                  null)
                                Column(
                                  children: [
                                    Text(
                                      "Taught in Khmer Language",
                                      style: TextStyle(
                                          fontSize: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 18
                                              : 16,
                                          color: AppColor.primaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      width: 100.w,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: controller
                                            .studentReport.value.data!.kh!
                                            .asMap()
                                            .entries
                                            .map((element) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 8, bottom: 8),
                                            decoration: BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: element.key == 0
                                                      ? Colors.transparent
                                                      : Colors.grey,
                                                  width: 0.5,
                                                ),
                                              ),
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "${element.value.subject}",
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: SizerUtil
                                                                    .deviceType ==
                                                                DeviceType
                                                                    .tablet
                                                            ? 16
                                                            : 13,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                                Container(
                                                  // width: 60,
                                                  child: Text(
                                                    "${element.value.totalwithletter}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: SizerUtil
                                                                    .deviceType ==
                                                                DeviceType
                                                                    .tablet
                                                            ? 16
                                                            : 13,
                                                        color: Colors.black
                                                            .withOpacity(0.8)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Container(
                                    //   padding: EdgeInsets.only(left: 10, right: 10),
                                    //   height:
                                    //       SizerUtil.deviceType == DeviceType.tablet
                                    //           ? 50
                                    //           : 40,
                                    //   width: double.infinity,
                                    //   decoration: BoxDecoration(
                                    //       color: AppColor.mainColor,
                                    //       borderRadius: BorderRadius.circular(50)),
                                    //   child: Row(children: [
                                    //     Text(
                                    //       "Total",
                                    //       style: TextStyle(
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: SizerUtil.deviceType ==
                                    //                 DeviceType.tablet
                                    //             ? 17
                                    //             : 15,
                                    //       ),
                                    //     ),
                                    //     Spacer(),
                                    //     Text(
                                    //       "${controller.studentReport.value.data!.language!.total!.kh}",
                                    //       style: TextStyle(
                                    //           fontWeight: FontWeight.w600,
                                    //           fontSize: SizerUtil.deviceType ==
                                    //                   DeviceType.tablet
                                    //               ? 17
                                    //               : 15,
                                    //           overflow: TextOverflow.ellipsis),
                                    //     ),
                                    //   ]),
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                  ],
                                )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
            : Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              ),
      ),
    );
  }
}
