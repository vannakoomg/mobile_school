import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/student_report/controller/student_report_controller.dart';
import 'package:sizer/sizer.dart';

class Flowchat extends StatefulWidget {
  Flowchat();
  @override
  State<StatefulWidget> createState() => FlowchatState();
}

class FlowchatState extends State<Flowchat> {
  final controller = Get.put(StudentController());
  late List<BarChartGroupData> showingBarGroups;
  @override
  void initState() {
    super.initState();
    controller.rawBarGroups.value = controller.items;
    showingBarGroups = controller.rawBarGroups;
    controller.touchedGroupIndex.value = -1;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AspectRatio(
          aspectRatio: 1,
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 10, left: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Expanded(
                        child: BarChart(
                          BarChartData(
                            groupsSpace: 20,
                            alignment: BarChartAlignment.spaceAround,
                            maxY: 10,
                            barTouchData: BarTouchData(
                              touchTooltipData: BarTouchTooltipData(
                                tooltipBgColor: Colors.grey,
                                getTooltipItem: (a, b, c, d) => null,
                              ),
                              // touchCallback: (FlTouchEvent event, response) {
                              //   if (response == null || response.spot == null) {
                              //     setState(() {
                              //       controller.touchedGroupIndex.value = -1;
                              //       showingBarGroups =
                              //           List.of(controller.rawBarGroups);
                              //     });
                              //     return;
                              //   }
                              //   controller.touchedGroupIndex.value =
                              //       response.spot!.touchedBarGroupIndex;
                              //   setState(() {
                              //     showingBarGroups =
                              //         List.of(controller.rawBarGroups);
                              //     if (controller.touchedGroupIndex.value !=
                              //         -1) {
                              //       var sum = 0.0;
                              //       for (final rod in showingBarGroups[
                              //               controller.touchedGroupIndex.value]
                              //           .barRods) {
                              //         sum += rod.toY;
                              //       }
                              //       final avg = sum /
                              //           showingBarGroups[controller
                              //                   .touchedGroupIndex.value]
                              //               .barRods
                              //               .length;
                              //       showingBarGroups[controller
                              //           .touchedGroupIndex
                              //           .value] = showingBarGroups[
                              //               controller.touchedGroupIndex.value]
                              //           .copyWith(
                              //         barRods: showingBarGroups[controller
                              //                 .touchedGroupIndex.value]
                              //             .barRods
                              //             .map((rod) {
                              //           return rod.copyWith(
                              //               toY: avg, color: Color(0xff61a5c2));
                              //         }).toList(),
                              //       );
                              //     }
                              //   });
                              // },
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(),
                              topTitles: const AxisTitles(),
                              bottomTitles: bottomTitles(),
                              leftTitles: leftTitles(),
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            barGroups: showingBarGroups,
                            gridData: const FlGridData(
                                show: true, drawVerticalLine: false),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Row(
                          children: [
                            // Spacer(),
                            Container(
                              margin: EdgeInsets.only(
                                right: 5,
                                left: 10,
                              ),
                              height: 4.w,
                              width: 4.w,
                              color: Color(0xff012a4a),
                            ),
                            Expanded(
                                child: Text(
                              "International Programme",
                              style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 15
                                        : 12,
                              ),
                            )),

                            Container(
                              margin: EdgeInsets.only(left: 10, right: 5),
                              height: 4.w,
                              width: 4.w,
                              color: Color(0xff468faf),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                "National Programme",
                                style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 15
                                          : 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  AxisTitles bottomTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        getTitlesWidget: (double value, TitleMeta meta) {
          final Widget text = Container(
            child: Text(
              "${controller.summayReport.value.data!.en![value.toInt()].term}",
              style: TextStyle(
                color: Color(0xff7589a2),
                fontWeight: FontWeight.w500,
                fontSize: SizerUtil.deviceType == DeviceType.tablet ? 15 : 11,
              ),
            ),
          );
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 10,
            child: Container(child: text),
          );
        },
        reservedSize: 30,
      ),
    );
  }

  AxisTitles leftTitles() {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: 1,
        getTitlesWidget: (double value, TitleMeta meta) {
          String text;
          if (value == 0 || value < 100) {
            text = '${10 * value.toInt()}';
          } else {
            text = '100';
          }
          return SideTitleWidget(
            axisSide: meta.axisSide,
            space: 5,
            child: Text(text,
                style: TextStyle(
                  color: Color(0xff7589a2),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                )),
          );
        },
      ),
    );
  }
}
