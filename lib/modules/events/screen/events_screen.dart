import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/events/controller/events_controller.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widgets/events_card.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final controller = Get.put(EventsController());
  @override
  void initState() {
    DateTime now = new DateTime.now();
    controller.focusDate.value = DateTime(now.year, now.month, 01);
    controller.getEvent(
        DateFormat('yyyy-MM-dd').format(DateTime(now.year, now.month, 01)));
    super.initState();
  }

  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
            title: Text(
          "Events",
          style: TextStyle(
              color: Colors.white,
              fontSize: SizerUtil.deviceType == DeviceType.tablet ? 10.sp : 16),
        )),
        body: Container(
            child: Column(
          children: [
            TableCalendar(
                rowHeight: 6.h,
                headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize:
                        SizerUtil.deviceType == DeviceType.tablet ? 22 : 16,
                  ),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) {
                    return Container(
                      height: 50,
                      width: 50,
                      child: Center(
                          child: Text(
                        "${day.day}",
                        style: TextStyle(
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 20
                                : 14,
                            color: Colors.grey),
                      )),
                    );
                  },
                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      height: 50,
                      width: 50,
                      child: Center(
                        child: Text(
                          "${day.day}",
                          style: TextStyle(
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 20
                                      : 14,
                              color: Colors.grey),
                        ),
                      ),
                    );
                  },
                  selectedBuilder: (context, timeNow, event) {
                    for (int i = 0;
                        i < controller.eventDate.value.data!.length;
                        ++i) {
                      if (DateFormat('yyyy-MM-dd').format(timeNow) ==
                          controller.eventDate.value.data![i].date) {
                        return Container(
                            width: 6.h,
                            height: 6.h,
                            child: Stack(
                              children: [
                                Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.primaryColor
                                          .withOpacity(0.9),
                                    ),
                                    width: 5.h,
                                    height: 5.h,
                                    child: Center(
                                      child: Text(
                                        "${timeNow.day}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    margin: const EdgeInsets.only(
                                      bottom: 5,
                                    ),
                                  ),
                                ),
                                if (controller.eventDate.value.data![i].event!
                                        .length >
                                    1)
                                  Positioned(
                                    right: 3,
                                    child: Container(
                                      height: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 22
                                          : 15,
                                      width: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 22
                                          : 15,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: Text(
                                        "${controller.eventDate.value.data![i].event!.length}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: SizerUtil.deviceType ==
                                                    DeviceType.tablet
                                                ? 12
                                                : 10),
                                      )),
                                    ),
                                  )
                              ],
                            ));
                      }
                    }
                    return null;
                  },
                ),
                firstDay: DateTime(2023, 10, 16),
                lastDay: DateTime(2050, 3, 14),
                focusedDay: controller.focusDate.value,
                onPageChanged: (value) {
                  controller.focusDate.value = value;
                  controller.getEvent(DateFormat('yyyy-MM-dd').format(value));
                },
                selectedDayPredicate: (value) {
                  if (controller.isloading.value == false) {
                    for (int i = 0;
                        i < controller.eventDate.value.data!.length;
                        ++i) {
                      if (DateUtil().formattedDate(
                              DateTime.parse(value.toString())) ==
                          DateUtil().formattedDate(DateTime.parse(controller
                              .eventDate.value.data![i].date
                              .toString()))) {
                        return true;
                      }
                    }
                  }
                  return false;
                },
                availableCalendarFormats: {
                  CalendarFormat.month: 'Month',
                }),
            Expanded(
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: controller.isloading.value == false
                      ? Column(
                          children: [
                            Text(
                              controller.eventDate.value.data!.isEmpty
                                  ? "No Event"
                                  : controller.eventDate.value.data!.length > 1
                                      ? "Events"
                                      : "Event",
                              style: TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 14.sp
                                        : 10.sp,
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Stack(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: controller
                                                .eventDate.value.data!
                                                .map(
                                              (e) {
                                                return Container(
                                                    child: Column(children: [
                                                  EventCard(
                                                    day:
                                                        "${e.date![8]}${e.date![9]}",
                                                    data: e.event!,
                                                  ),
                                                ]));
                                              },
                                            ).toList(),
                                          ),
                                          Positioned(
                                              child: Container(
                                            height: 3,
                                            width: 20,
                                            color: Colors.white,
                                          ))
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      )
                                    ]),
                              ),
                            ),
                          ],
                        )
                      : Center(
                          child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ),
                        )),
            )
          ],
        ))));
  }
}
