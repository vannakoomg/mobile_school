import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import 'package:school/repos/calendar_attendance.dart';
import 'package:sizer/sizer.dart';

import '../../models/CalendarAttendanceDB.dart';
import '../../repos/attendancedetail.dart';
import '../../config/theme/theme.dart';

final today = DateUtils.dateOnly(DateTime.now());

class AttendanceCalendar extends StatefulWidget {
  const AttendanceCalendar({Key? key}) : super(key: key);

  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  late List<Attendance> _recAttendance = [];
  Map<DateTime, int> datasets = {};
  late double size;
  late final PhoneSize phoneSize;
  DateTime now = DateTime.now();
  final DateFormat _format = new DateFormat("yyyy-MM-dd");
  final DateFormat _formatPopup = new DateFormat("dd-MMM-yyyy");
  int totalPresent = 0, totalExcused = 0, totalUnexcused = 0;
  String strCheckIn = '', strCheckOut = '';

  Map<int, Color> colorSets = {
    1: Colors.blueAccent,
    2: Colors.green,
    3: Colors.blueGrey,
  };

  @override
  void initState() {
    super.initState();
    size = SizerUtil.deviceType == DeviceType.tablet ? 18.0 : 14.0;
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    _fetchCalendarAttendance(month: '${now.month}', year: '${now.year}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
      ),
      body: _buildTableCalendar(),
    );
  }

  Widget _buildTableCalendar() {
    return Container(
      child: Column(
        children: [
          Container(
            width: SizerUtil.deviceType == DeviceType.tablet ? 90.w : null,
            child: Card(
              margin: EdgeInsets.only(
                  top: SizerUtil.deviceType == DeviceType.tablet ? 10 : 20),
              elevation: 20,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  child: HeatMapCalendar(
                    showColorTip: false,
                    flexible: true,
                    weekTextColor: Colors.cyan,
                    textColor: Colors.black,
                    weekFontSize: size,
                    monthFontSize: size,
                    fontSize: size,
                    borderRadius: 150,
                    datasets: {},
                    colorMode: ColorMode.color,
                    colorsets: colorSets,
                    onMonthChange: (value) {
                      totalPresent = totalExcused = totalUnexcused = 0;
                      _fetchCalendarAttendance(
                          month: '${value.month}', year: '${value.year}');
                    },
                    onClick: (value) {
                      _fetchAttendanceDetail(
                          dateString: '${_formatPopup.format(value)}');
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: 1.5.h,
                  right: 1.5.h,
                  top: SizerUtil.deviceType == DeviceType.tablet ? 2.h : 5.h),
              // color: Colors.grey.shade200,
              // height: 5.h,
              child: GridView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Card(
                    color: Colors.blueAccent,
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Total\nPresent Days',
                          style: myTextStyleHeaderWhite[phoneSize],
                          textAlign: TextAlign.center,
                        ),
                        Container(
                          height: 7.h,
                          width: 7.h,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Text('$totalPresent',
                              style: myTextStyleHeaderBlue[phoneSize]),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.green,
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: Text(
                          'Total Excused Absent Days',
                          style: myTextStyleHeaderWhite[phoneSize],
                          textAlign: TextAlign.center,
                        )),
                        Container(
                          height: 7.h,
                          width: 7.h,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Text('$totalExcused',
                              style: myTextStyleHeaderGreen[phoneSize]),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    color: Colors.blueGrey,
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                            child: AutoSizeText(
                          'Total Unexcused Absent Days',
                          style: TextStyle(
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 18
                                      : 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        )),
                        Container(
                          height: 7.h,
                          width: 7.h,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Text('$totalUnexcused',
                              style: myTextStyleHeaderYellow[phoneSize]),
                        ),
                      ],
                    ),
                  ),
                ],
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 0.5.h,
                    mainAxisSpacing: 1.h),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _fetchCalendarAttendance({required String month, required String year}) {
    fetchCalendarAttendance(month: month, year: year).then((value) {
      setState(() {
        try {
          print("value=${value.status}");
          //present
          _recAttendance.clear();
          _recAttendance.addAll(value.data.present);

          totalPresent = _recAttendance.length;
          _recAttendance.forEach((element) {
            datasets.addAll({DateTime.parse(_format.format(element.date)): 1});
          });
          //excused
          _recAttendance.clear();
          _recAttendance.addAll(value.data.excused);
          totalExcused = _recAttendance.length;
          _recAttendance.forEach((element) {
            datasets.addAll({DateTime.parse(_format.format(element.date)): 2});
          });
          //unexcused
          _recAttendance.clear();
          _recAttendance.addAll(value.data.unexcused);
          totalUnexcused = _recAttendance.length;
          _recAttendance.forEach((element) {
            datasets.addAll({DateTime.parse(_format.format(element.date)): 3});
          });
        } catch (err) {
          Get.defaultDialog(
            title: "Error",
            middleText: "$value",
            barrierDismissible: true,
            confirm: reloadBtn(),
          );
        }
      });
    });
  }

  void _fetchAttendanceDetail({required String dateString}) {
    // print("dateString=$dateString");
    var strDate = dateString;
    fetchAttendanceDetail(date: dateString).then((value) {
      setState(() {
        try {
          strCheckIn = value.data.checkIn ?? '';
          strCheckOut = value.data.checkOut ?? '';
          if (strCheckIn != '')
            viewCheckInOut(
                date: strDate, checkIn: strCheckIn, checkOut: strCheckOut);
        } catch (err) {
          print('err==$err');
        }
      });
    });
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          _fetchCalendarAttendance(month: '${now.month}', year: '${now.year}');
        },
        child: Text("Reload"));
  }

  void viewCheckInOut(
      {required String date,
      required String checkIn,
      required String checkOut}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            // clipBehavior: Clip.antiAliasWithSaveLayer,
            content: InteractiveViewer(
              child: Container(
                padding: EdgeInsets.all(8.0),
                height: 18.h,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Text('$date', style: myTextStyleHeader[phoneSize]),
                        new Divider(
                          color: Colors.grey.shade700,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Check-In    : ',
                                  style: myTextStyleHeader[phoneSize]),
                              Text('$strCheckIn',
                                  style: myTextStyleBody[phoneSize]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text('Check-Out : ',
                                  style: myTextStyleHeader[phoneSize]),
                              Text('$strCheckOut',
                                  style: myTextStyleBody[phoneSize]),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            key: const Key('closeIconKey'),
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
