import 'package:flutter/material.dart';
import 'package:school/modules/events/models/event_model.dart';

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
              color: Colors.white,
            ),
          )),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 30,
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
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Text(
                                "${element.value.time}",
                                style: TextStyle(color: Colors.grey),
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
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    "$day",
                    style: TextStyle(
                      color: Color(0xff1d1a56),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Container(
                height: 5,
                width: 10,
                color: Color(0xff1d1a56),
              )
            ],
          ),
        )
      ],
    );
  }
}
