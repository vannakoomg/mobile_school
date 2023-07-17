import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/student_report/controller/student_report_controller.dart';
import 'package:school/modules/student_report/screens/flowchat.dart';
import 'package:sizer/sizer.dart';

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({Key? key}) : super(key: key);

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  final controller = Get.put(StudentController());
  @override
  void initState() {
    controller.initState();
    super.initState();
  }

  @override
  void dispose() {
    controller.disposeFuntion();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: AppColor.backgroundColor,
          appBar: AppBar(title: Text("Student Report")),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
<<<<<<< HEAD
                        child: Text(
                          "School year : 2022-2023",
                          textAlign: TextAlign.center,
                        ),
                      ),
=======
                        child: Text("School Year : 2022-2023"),
                      ),
                      Text(""),
>>>>>>> 97c454a8e6f5409928e630f1efccbc44aa3acb90
                      SizedBox(
                        height: 20,
                      ),
                      Flowchat(),
                      Container(
                        height: 50,
                        width: 100.w,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 15,
                              child: Text(
                                "Taught in English Language",
                                style: TextStyle(
                                    color: AppColor.primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (controller.listOfTerm.length > 1)
                              Stack(
                                children: [
                                  for (int i = controller.listOfTerm.length;
                                      i > 0;
                                      --i)
                                    AnimatedPositioned(
                                      duration: Duration(milliseconds: 200),
                                      right: 10 +
                                          35.0 *
                                              (controller.listOfTerm.length -
                                                  i +
                                                  1) *
                                              controller.isTapOnTerm.value,
                                      top: 10,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.term.value =
                                              controller.listOfTerm[i - 1];
                                          controller.tapTerm();
                                          debugPrint(
                                              "value ${controller.listOfTerm[i - 1]}");
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                            color: Color(0xff274c77),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "${controller.listOfTerm[i - 1]}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  overflow:
                                                      TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: GestureDetector(
                                onTap: () {
                                  controller.tapTerm();
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: Color(0xff274c77),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      "T${controller.term}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.ontapEnglish();
                            },
                            child: Container(
                              width: 100.w,
                              child: Stack(
                                children: [
                                  Container(
                                    width: 100.w,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: SingleChildScrollView(
                                      controller:
                                          controller.scrollerEnglish.value,
                                      scrollDirection: Axis.horizontal,
                                      child: Column(
                                        children: controller.studentReport
                                            .asMap()
                                            .entries
                                            .map((element) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 7, bottom: 7),
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
                                                Container(
                                                  width: 100.w - 40 - 60,
                                                  child: Text(
                                                    "${element.value.subject}",
                                                    style: TextStyle(
                                                        color: AppColor
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        overflow: TextOverflow
                                                            .ellipsis),
                                                  ),
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Text(
                                                    "A (${element.value.score}.45)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 13,
                                                        color: controller
                                                            .generateColorByPoint(
                                                                double.parse(
                                                                    element
                                                                        .value
                                                                        .score!))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: (100.w -
                                                          60 * 4 -
                                                          40 -
                                                          35) /
                                                      3,
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Text(
                                                    "A (${element.value.score}.45)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: (100.w -
                                                          60 * 4 -
                                                          40 -
                                                          35) /
                                                      3,
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Text(
                                                    "A (${element.value.score}.45)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: (100.w -
                                                          60 * 4 -
                                                          40 -
                                                          35) /
                                                      3,
                                                ),
                                                Container(
                                                  width: 60,
                                                  child: Text(
                                                    "A (${element.value.score}.45)",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontSize: 13,
                                                        color: controller
                                                            .generateColorByPoint(
                                                                double.parse(
                                                                    element
                                                                        .value
                                                                        .score!))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  AnimatedPositioned(
                                    top: 12,
                                    left:
                                        controller.sortEnglish.value ? 10 : -40,
                                    duration: Duration(milliseconds: 300),
                                    child: Container(
                                      child: Column(
                                          children: controller.studentReport
                                              .map((element) {
                                        return Container(
                                          height: 25,
                                          width: 25,
                                          margin: EdgeInsets.only(bottom: 6),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColor.primaryColor,
                                          ),
                                          child: Center(
                                              child: Text(
                                            "${element.subject![0]}${element.subject![1]}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11,
                                            ),
                                          )),
                                        );
                                      }).toList()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Taught in Khmer Language",
                        style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: controller.studentReport
                                .asMap()
                                .entries
                                .map((element) {
                              return Container(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
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
                                    Container(
                                      width: 100.w - 40 - 60,
                                      child: Text(
                                        "${element.value.subject}",
                                        style: TextStyle(
                                            color: AppColor.primaryColor,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "A (${element.value.score}.45)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis,
                                            color:
                                                controller.generateColorByPoint(
                                                    double.parse(
                                                        element.value.score!))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: (100.w - 60 * 4 - 40) / 3,
                                    ),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "A (${element.value.score}.45)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    SizedBox(
                                      width: (100.w - 60 * 4 - 40) / 3,
                                    ),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "A (${element.value.score}.45)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                    SizedBox(
                                      width: (100.w - 60 * 4 - 40) / 3,
                                    ),
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "A (${element.value.score}.45)",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 11.w,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: AppColor.mainColor,
                            borderRadius: BorderRadius.circular(50)),
                        child: Row(children: [
                          Text("Total"),
                          Spacer(),
                          Text(
                            "A (232.45)",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        children: [],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
