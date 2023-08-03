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
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (element.key != 0)
                              SizedBox(
                                height: 10,
                              ),
                            Text(
                              "${element.value.title}",
                              style: TextStyle(
                                color: Color(int.parse(
                                    element.value.action_color.toString())),
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 8.sp
                                        : 12,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Text(
                                "${element.value.time}",
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.tablet
                                        ? 6.sp
                                        : 12),
                              ),
                            ),
                          ]),
                    );
                  }).toList()),
            )
          ]),
        ),
        Positioned(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 0),
                height: 20,
                width: 20,
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
              // Container(
              //   height: 5,
              //   width: 10,
              //   color: Color(0xff1d1a56),
              // )
            ],
          ),
        )
      ],
    );
  }
}
