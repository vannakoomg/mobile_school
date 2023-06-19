import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/models/TimetableDB.dart';
import 'package:school/repos/timetable.dart';
import 'package:school/screens/theme/theme.dart';
import 'package:sizer/sizer.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({Key? key}) : super(key: key);

  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final storage = GetStorage();
  late final PhoneSize phoneSize;
  String dropdownValue = 'Monday';
  late DateTime _now;
  late String formattedDate, formattedMonth;
  late List<Timetable> _timetableListOdd = [];
  late List<Timetable> _timetableListEven = [];
  late Class _timetableClassOdd;
  late Class _timetableClassEven;
  bool _oddEven = false;
  bool _isShift = true;
  List<String> strDayOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    _tabController = TabController(length: 2, vsync: this);
    _now = DateTime.now();
    formattedDate = DateFormat('EEEE').format(_now);
    formattedMonth = DateFormat('M').format(_now);
    // print("formattedMonth=${int.parse(formattedMonth)%2}");
    var gradeLevel = storage.read('isGradeLevel') ?? '0';
    var strGradeLevel = gradeLevel.replaceAll(new RegExp(r'[^0-9]'), '');
    if (strGradeLevel == '12')
      strDayOfWeek.add('Saturday');
    else if (formattedDate == 'Saturday' || formattedDate == 'Sunday') {
      formattedDate = "Friday";
    }

    dropdownValue = formattedDate;
    _fetchTimetableOdd(dayOfWeek: formattedDate);
    _fetchTimetableEven(dayOfWeek: formattedDate);

    if (int.parse(formattedMonth) % 2 == 0)
      _tabController.animateTo(1);
    else
      _tabController.animateTo(0);

    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_timetableListOdd.isEmpty ||
        _timetableListEven.isEmpty ||
        _timetableClassOdd.name.isBlank == false ||
        _timetableClassEven.name.isBlank == false) {
      isLoading = false;
    } else {
      isLoading = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Timetable"),
        bottom: _oddEven == true
            ? TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                // isScrollable: true,
                tabs: [
                  Tab(
                    text: "Odd Month",
                  ),
                  Tab(
                    text: "Even Month",
                  ),
                ],
              )
            : null,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 5),
            child: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              dropdownColor: Color(0xff1d1a56),
              iconSize: 30,
              elevation: 16,
              style: const TextStyle(color: Colors.white),
              underline: Container(
                height: 2,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: strDayOfWeek.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  onTap: () {
                    _fetchTimetableOdd(dayOfWeek: value);
                    _fetchTimetableEven(dayOfWeek: value);
                  },
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: SizerUtil.deviceType == DeviceType.tablet
                            ? 18
                            : 14),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      body: !isLoading
          ? _isShift
              ? Center(child: CircularProgressIndicator())
              : Container()
          : (_oddEven
              ? TabBarView(
                  controller: _tabController,
                  children: [
                    Tab(
                      //Odd
                      child: SizerUtil.deviceType == DeviceType.tablet
                          ? _buildIpadSizeOdd
                          : _buildIphoneSizeOdd,
                    ),
                    //Even
                    Tab(
                      child: SizerUtil.deviceType == DeviceType.tablet
                          ? _buildIpadSizeEven
                          : _buildIphoneSizeEven,
                    ),
                  ],
                )
              : SizerUtil.deviceType == DeviceType.tablet
                  ? _buildIpadSizeOdd
                  : _buildIphoneSizeOdd),
    );
  }

  get _buildIphoneSizeOdd {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              width: 100.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: _timetableClassOdd.khmerTeacher != '' ? 10.h : 6.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Homeroom: ',
                              style: myTextStyleBody[phoneSize],
                            ),
                            Text(
                              _timetableClassOdd.homeroom,
                              style: myTextStyleHeader[phoneSize],
                            ),
                          ],
                        ),
                        _timetableClassOdd.khmerTeacher != ''
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Khmer Teacher: ',
                                    style: myTextStyleBody[phoneSize],
                                  ),
                                  Text(
                                    _timetableClassOdd.khmerTeacher,
                                    style: myTextStyleHeader[phoneSize],
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _timetableClassOdd.teacherAide != ''
                                ? Row(
                                    children: [
                                      Text(
                                        'Teacher\'s Aide: ',
                                        style: myTextStyleBody[phoneSize],
                                      ),
                                      Text(
                                        _timetableClassOdd.teacherAide,
                                        style: myTextStyleHeader[phoneSize],
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Room: ${_timetableClassOdd.roomNo}',
                                    style: myTextStyleBody[phoneSize],
                                  ),
                            _timetableClassOdd.teacherAide != ''
                                ? Text(
                                    'Room: ${_timetableClassOdd.roomNo}',
                                    style: myTextStyleBody[phoneSize],
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.blue.shade400,
              alignment: Alignment.topCenter,
              width: 100.w,
              // height: 100.h,
              child: DataTable(
                columnSpacing: 0,
                headingRowHeight: 5,
                columns: [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '',
                      textAlign: TextAlign.center,
                      style: myTextStyleHeaderWhite[phoneSize],
                    ),
                  ))),
                ],
                rows: _timetableListOdd.map((data) {
                  var index = _timetableListOdd.indexOf(data);
                  return DataRow(
                      color: MaterialStateProperty.all(
                          data.breakTime == 'Study Time'
                              ? Colors.teal.shade300
                              : (data.breakTime != 'Lunch Break'
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade100)),
                      cells: [
                        DataCell(Container(
                          width: 5.w,
                          alignment: Alignment.centerLeft,
                          // color: Colors.blueAccent,
                          child: Text(
                            '${index + 1}',
                            style: myTextStyleBodyWhite[phoneSize],
                          ),
                        )),
                        DataCell(Container(
                          width: 25.w,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                data.startTime,
                                style: myTextStyleBodyWhite[phoneSize],
                              ),
                              Text(
                                data.endTime,
                                style: myTextStyleBodyWhite[phoneSize],
                              )
                            ],
                          ),
                        )),
                        DataCell(Container(
                            width: 65.w,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10),
                            // color: Colors.redAccent,
                            child: data.breakTime == 'Study Time'
                                ? data.teacherName != ""
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.subject,
                                            textAlign: TextAlign.center,
                                            style:
                                                myTextStyleBodyWhite[phoneSize],
                                          ),
                                          Text(
                                            'Lecture, ${data.teacherName}',
                                            style:
                                                myTextStyleBodyWhite[phoneSize],
                                          )
                                        ],
                                      )
                                    : Text(
                                        data.subject,
                                        style: myTextStyleBodyWhite[phoneSize],
                                      )
                                : Text(
                                    data.breakTime,
                                    style: myTextStyleBodyWhite[phoneSize],
                                  ))),
                      ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _buildIphoneSizeEven {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              // color: Colors.redAccent,
              padding: EdgeInsets.all(8.0),
              width: 100.h,
              // height: 12.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: _timetableClassEven.khmerTeacher != '' ? 10.h : 6.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Homeroom: ',
                              style: myTextStyleBody[phoneSize],
                            ),
                            Text(
                              _timetableClassEven.homeroom,
                              style: myTextStyleHeader[phoneSize],
                            ),
                          ],
                        ),
                        _timetableClassEven.khmerTeacher != ''
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Khmer Teacher: ',
                                    style: myTextStyleBody[phoneSize],
                                  ),
                                  Text(
                                    _timetableClassEven.khmerTeacher,
                                    style: myTextStyleHeader[phoneSize],
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _timetableClassEven.teacherAide != ''
                                ? Row(
                                    children: [
                                      Text(
                                        'Teacher\'s Aide: ',
                                        style: myTextStyleBody[phoneSize],
                                      ),
                                      Text(
                                        _timetableClassEven.teacherAide,
                                        style: myTextStyleHeader[phoneSize],
                                      ),
                                    ],
                                  )
                                : Text(
                                    'Room: ${_timetableClassEven.roomNo}',
                                    style: myTextStyleBody[phoneSize],
                                  ),
                            _timetableClassEven.teacherAide != ''
                                ? Text(
                                    'Room: ${_timetableClassEven.roomNo}',
                                    style: myTextStyleBody[phoneSize],
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Divider(
            //   color: Colors.blueGrey,
            //   height: 1.h,
            //   thickness: 0.2.h,
            // ),
            Container(
              // color: Colors.blue.shade400,
              alignment: Alignment.topCenter,
              width: 100.w,
              // height: 100.h,
              child: DataTable(
                columnSpacing: 0,
                headingRowHeight: 5,
                columns: [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '',
                      textAlign: TextAlign.center,
                      style: myTextStyleHeaderWhite[phoneSize],
                    ),
                  ))),
                ],
                rows: _timetableListEven.map((data) {
                  var index = _timetableListEven.indexOf(data);
                  return DataRow(
                      color: MaterialStateProperty.all(
                          data.breakTime == 'Study Time'
                              ? Colors.teal.shade300
                              : (data.breakTime != 'Lunch Break'
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade100)),
                      cells: [
                        DataCell(Container(
                          width: 5.w,
                          alignment: Alignment.centerLeft,
                          // color: Colors.blueAccent,
                          child: Text(
                            '${index + 1}',
                            style: myTextStyleBodyWhite[phoneSize],
                          ),
                        )),
                        DataCell(Container(
                          width: 25.w,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                data.startTime,
                                style: myTextStyleBodyWhite[phoneSize],
                              ),
                              Text(
                                data.endTime,
                                style: myTextStyleBodyWhite[phoneSize],
                              )
                            ],
                          ),
                        )),
                        DataCell(Container(
                            width: 65.w,
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 10),
                            // color: Colors.redAccent,
                            child: data.breakTime == 'Study Time'
                                ? data.teacherName != ""
                                    ? Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data.subject,
                                            textAlign: TextAlign.center,
                                            style:
                                                myTextStyleBodyWhite[phoneSize],
                                          ),
                                          Text(
                                            'Lecture, ${data.teacherName}',
                                            style:
                                                myTextStyleBodyWhite[phoneSize],
                                          )
                                        ],
                                      )
                                    : Text(
                                        data.subject,
                                        style: myTextStyleBodyWhite[phoneSize],
                                      )
                                : Text(
                                    data.breakTime,
                                    style: myTextStyleBodyWhite[phoneSize],
                                  ))),
                      ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _buildIpadSizeOdd {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              height: _timetableClassOdd.khmerTeacher != '' ? 12.h : 7.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Homeroom: ',
                        style: myTextStyleBody[phoneSize],
                      ),
                      Text(
                        _timetableClassOdd.homeroom,
                        style: myTextStyleHeader[phoneSize],
                      ),
                    ],
                  ),
                  _timetableClassOdd.khmerTeacher != ''
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khmer Teacher: ',
                              style: myTextStyleBody[phoneSize],
                            ),
                            Text(
                              _timetableClassOdd.khmerTeacher,
                              style: myTextStyleHeader[phoneSize],
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _timetableClassOdd.teacherAide != ''
                          ? Row(
                              children: [
                                Text(
                                  'Teacher\'s Aide: ',
                                  style: myTextStyleBody[phoneSize],
                                ),
                                Text(
                                  _timetableClassOdd.teacherAide,
                                  style: myTextStyleHeader[phoneSize],
                                ),
                              ],
                            )
                          : Text(
                              'Room: ${_timetableClassOdd.roomNo}',
                              style: myTextStyleBody[phoneSize],
                            ),
                      _timetableClassOdd.teacherAide != ''
                          ? Text(
                              'Room: ${_timetableClassOdd.roomNo}',
                              style: myTextStyleBody[phoneSize],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blueGrey,
              alignment: Alignment.topCenter,
              width: 100.w,
              // height: 100.h,
              child: DataTable(
                columnSpacing: 0,
                headingRowHeight: 0,
                columns: [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                ],
                rows: _timetableListOdd.map((data) {
                  //var index = _timetableListOdd.indexOf(data);
                  return DataRow(
                      color: MaterialStateProperty.all(
                          data.breakTime == 'Study Time'
                              ? Colors.teal.shade300
                              : (data.breakTime != 'Lunch Break'
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade100)),
                      cells: [
                        DataCell(Container(
                          width: 30.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data.time,
                            style: myTextStyleBodyWhite[phoneSize],
                          ),
                        )),
                        DataCell(Container(
                            width: 35.w,
                            alignment: Alignment.centerLeft,
                            child: data.breakTime == 'Study Time'
                                ? Text(
                                    data.subject,
                                    textAlign: TextAlign.center,
                                    style: myTextStyleBodyWhite[phoneSize],
                                  )
                                : Text(
                                    data.breakTime,
                                    style: myTextStyleBodyWhite[phoneSize],
                                  ))),
                        DataCell(Container(
                          width: 35.w,
                          // color: Colors.redAccent,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data.teacherName != ""
                                ? 'Lecture, ${data.teacherName}'
                                : '',
                            style: myTextStyleBodyWhite[phoneSize],
                          ),
                        )),
                      ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  get _buildIpadSizeEven {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              height: _timetableClassEven.khmerTeacher != '' ? 12.h : 7.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Homeroom: ',
                        style: myTextStyleBody[phoneSize],
                      ),
                      Text(
                        _timetableClassEven.homeroom,
                        style: myTextStyleHeader[phoneSize],
                      ),
                    ],
                  ),
                  _timetableClassEven.khmerTeacher != ''
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khmer Teacher: ',
                              style: myTextStyleBody[phoneSize],
                            ),
                            Text(
                              _timetableClassEven.khmerTeacher,
                              style: myTextStyleHeader[phoneSize],
                            ),
                          ],
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _timetableClassEven.teacherAide != ''
                          ? Row(
                              children: [
                                Text(
                                  'Teacher\'s Aide: ',
                                  style: myTextStyleBody[phoneSize],
                                ),
                                Text(
                                  _timetableClassEven.teacherAide,
                                  style: myTextStyleHeader[phoneSize],
                                ),
                              ],
                            )
                          : Text(
                              'Room: ${_timetableClassEven.roomNo}',
                              style: myTextStyleBody[phoneSize],
                            ),
                      _timetableClassEven.teacherAide != ''
                          ? Text(
                              'Room: ${_timetableClassEven.roomNo}',
                              style: myTextStyleBody[phoneSize],
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.blueGrey,
              alignment: Alignment.topCenter,
              width: 100.w,
              // height: 100.h,
              child: DataTable(
                columnSpacing: 0,
                headingRowHeight: 0,
                columns: [
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                  DataColumn(
                      label: Expanded(
                          child: Text(
                    '',
                    textAlign: TextAlign.center,
                    style: myTextStyleHeaderWhite[phoneSize],
                  ))),
                ],
                rows: _timetableListEven.map((data) {
                  //var index = _timetableListEven.indexOf(data);
                  return DataRow(
                      color: MaterialStateProperty.all(
                          data.breakTime == 'Study Time'
                              ? Colors.teal.shade300
                              : (data.breakTime != 'Lunch Break'
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade100)),
                      cells: [
                        DataCell(Container(
                          width: 30.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data.time,
                            style: myTextStyleBodyWhite[phoneSize],
                          ),
                        )),
                        DataCell(Container(
                            width: 35.w,
                            alignment: Alignment.centerLeft,
                            child: data.breakTime == 'Study Time'
                                ? Text(
                                    data.subject,
                                    textAlign: TextAlign.center,
                                    style: myTextStyleBodyWhite[phoneSize],
                                  )
                                : Text(
                                    data.breakTime,
                                    style: myTextStyleBodyWhite[phoneSize],
                                  ))),
                        DataCell(Container(
                          width: 35.w,
                          // color: Colors.redAccent,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            data.teacherName != ""
                                ? 'Lecture, ${data.teacherName}'
                                : '',
                            style: myTextStyleBodyWhite[phoneSize],
                          ),
                        )),
                      ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _fetchTimetableOdd({String dayOfWeek = 'Friday', String type = 'Odd'}) {
    fetchTimetable(dayOfWeek, type).then((value) {
      _timetableListOdd.clear();
      setState(() {
        try {
          print("value.data.odd=${value.status}");
          if (value.data.timetables.length > 0) {
            // print("isBlank");
            _timetableListOdd.addAll(value.data.timetables);
            _timetableClassOdd = value.data.dataClass;
            _timetableClassOdd.name = '';
            if (_timetableClassOdd.scheduleTemplate.first.type != 'Both')
              _oddEven = true;
          } else
            _isShift = false;

          // isLoading = true;
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

  void _fetchTimetableEven(
      {String dayOfWeek = 'Friday', String type = 'Even'}) {
    fetchTimetable(dayOfWeek, type).then((value) {
      _timetableListEven.clear();
      setState(() {
        try {
          print("value.data.even=${value.status}");
          if (value.data.timetables.length > 0) {
            _timetableListEven.addAll(value.data.timetables);
            _timetableClassEven = value.data.dataClass;
            _timetableClassEven.name = '';
            if (_timetableClassEven.scheduleTemplate.first.type != 'Both')
              _oddEven = true;
          } else
            _isShift = false;

          isLoading = true;
        } catch (err) {
          // Get.defaultDialog(
          //   title: "Error",
          //   middleText: "$value",
          //   barrierDismissible: true,
          //   confirm: reloadBtn(),
          // );
        }
      });
    });
  }

  Widget reloadBtn() {
    return Container(
      child: ElevatedButton(
          onPressed: () {
            Get.back();
            _fetchTimetableOdd();
            _fetchTimetableEven();
          },
          child: Text("Reload")),
    );
  }
}
