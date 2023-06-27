import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/events/controller/events_controller.dart';
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
        backgroundColor: Color(0xff1d1a56),
        appBar: AppBar(title: Text("Event")),
        body: SingleChildScrollView(
            child: Container(
                child: Column(
          children: [
            Container(
              color: Colors.white,
              child: TableCalendar(
                  rowHeight: 50,
                  calendarBuilders: CalendarBuilders(
                    disabledBuilder: (context, day, focusedDay) {
                      return Container();
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        height: 50,
                        width: 50,
                        child: Center(child: Text("${day.day}")),
                      );
                    },
                    selectedBuilder: (context, timeNow, event) {
                      for (int i = 0;
                          i < controller.eventDate.value.data!.length;
                          ++i) {
                        if (DateFormat('yyyy-MM-dd').format(timeNow) ==
                            controller.eventDate.value.data![i].date) {
                          return Container(
                              width: 45,
                              height: 45,
                              child: Stack(
                                children: [
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(int.parse(controller
                                                .eventDate
                                                .value
                                                .data![i]
                                                .event![0]
                                                .action_color
                                                .toString()))
                                            .withOpacity(0.8),
                                      ),
                                      width: 35,
                                      height: 35,
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
                                        height: 15,
                                        width: 15,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                            child: Text(
                                          "${controller.eventDate.value.data![i].event!.length}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
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
                  firstDay: DateTime(2010, 10, 16),
                  lastDay: DateTime(2030, 3, 14),
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
            ),
            Container(
              color: Colors.white,
              child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  decoration: BoxDecoration(
                    color: Color(0xff1d1a56),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: controller.isloading.value == false
                      ? Column(children: [
                          Text(
                            controller.eventDate.value.data!.isEmpty
                                ? "NOTHING"
                                : "UPCOMING",
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: controller.eventDate.value.data!.map(
                              (e) {
                                return Container(
                                    child: Column(children: [
                                  EventCard(
                                      day: "${e.date![8]}${e.date![9]}",
                                      data: e.event!),
                                  SizedBox(
                                    height: 30,
                                  )
                                ]));
                              },
                            ).toList(),
                          )
                        ])
                      : SizedBox()),
            )
          ],
        )))));
  }
}
