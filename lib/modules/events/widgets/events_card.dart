import 'package:flutter/material.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/events/models/event_model.dart';
import 'package:sizer/sizer.dart';

class EventCard extends StatelessWidget {
  final String day;
  final List<Event> data;
  const EventCard({
    Key? key,
    required this.day,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(
            left: 10,
          ),
          decoration: BoxDecoration(
              border: Border(
            left: BorderSide(
              width: 0.55,
              color: AppColor.primaryColor,
            ),
          )),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 5.w,
            ),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: data.asMap().entries.map((element) {
                    return Container(
                      margin: EdgeInsets.only(top: 0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  top: 4, bottom: 5, left: 10, right: 10),
                              decoration: BoxDecoration(
                                  color: Color(int.parse(
                                      element.value.action_color!.toString())),
                                  borderRadius: BorderRadius.circular(7)),
                              child: Text(
                                "${element.value.title}",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 8.sp
                                          : 12,
                                ),
                              ),
                            ),

                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 5, bottom: 20),
                              child: element.value.time != ""
                                  ? Text(
                                      "${element.value.time}",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: SizerUtil.deviceType ==
                                                  DeviceType.tablet
                                              ? 6.sp
                                              : 12),
                                    )
                                  : SizedBox(),
                            ),
                            // if (data.length < element.key + 1)
                            // SizedBox(
                            //   height: 20,
                            // )
                          ]),
                    );
                  }).toList()),
            )
          ]),
        ),
        Positioned(
          top: 3,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 0),
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.primaryColor,
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
