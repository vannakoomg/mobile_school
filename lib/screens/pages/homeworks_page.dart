// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/utils/widgets/custom_dialog.dart';
import 'package:sizer/sizer.dart';
import '../../models/AssignmentListDB.dart';
import '../../repos/assignment_list.dart';
import '../../config/theme/theme.dart';
import '../../utils/widgets/blank_screen.dart';
import 'homework_detail.dart';

class HomeworksPage extends StatefulWidget {
  const HomeworksPage({Key? key}) : super(key: key);

  @override
  _HomeworksPageState createState() => _HomeworksPageState();
}

class _HomeworksPageState extends State<HomeworksPage>
    with TickerProviderStateMixin {
  late TabController _controller;
  late final PhoneSize phoneSize;
  late List<Assigned> _recAssignedList = [],
      _recMissingList = [],
      _recDoneList = [];
  int present = 0;
  int perPage = 15;
  int _emptyAssigned = 0, _emptyMissing = 0, _emptyDone = 0;
  bool isLoading = false;
  final storage = GetStorage();
  late String device;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    if (Platform.isAndroid)
      device = 'Android';
    else
      device = 'iOS';

    _fetchAssignment();
    // print("date=${DateTime.parse("24 March 2023 11:47:00")}");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: 'Assignment');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Assignments"),
          leading: IconButton(
              icon: Icon(
                  device == 'iOS' ? Icons.arrow_back_ios : Icons.arrow_back),
              onPressed: () => Get.back(result: 'Assignment')),
        ),
        body: !isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints.expand(height: 6.h),
                    child: TabBar(
                      controller: _controller,
                      labelColor: Colors.deepPurpleAccent,
                      unselectedLabelColor: Colors.blueGrey,
                      labelStyle: myTextStyleHeader[phoneSize],
                      indicatorColor: Colors.deepPurpleAccent,
                      tabs: [
                        Tab(
                          child: _emptyAssigned != 0
                              ? badges.Badge(
                                  position: badges.BadgePosition.topEnd(
                                      end: _emptyAssigned > 10 ? -25 : -18),
                                  // animationType: BadgeAnimationType.scale,
                                  // toAnimate: true,
                                  badgeContent: Text('$_emptyAssigned',
                                      style: TextStyle(color: Colors.white)),
                                  child: Text('Assigned'),
                                )
                              : Text('Assigned'),
                        ),
                        Tab(
                          child: _emptyMissing != 0
                              ? badges.Badge(
                                  position: badges.BadgePosition.topEnd(
                                      end: _emptyMissing > 10 ? -25 : -18),
                                  // animationType: BadgeAnimationType.scale,
                                  // toAnimate: true,
                                  badgeContent: Text('$_emptyMissing',
                                      style: TextStyle(color: Colors.white)),
                                  child: Text('Missing'),
                                )
                              : Text('Missing'),
                        ),
                        Tab(text: "Completed"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: TabBarView(controller: _controller, children: [
                        _emptyAssigned == 0 ? BlankPage() : _upcoming,
                        _emptyMissing == 0 ? BlankPage() : _missing,
                        _emptyDone == 0 ? BlankPage() : _completed,
                      ]),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  get _upcoming {
    return assignmentBodyList(
      assignments: _recAssignedList,
    );
  }

  get _missing {
    return assignmentBodyList(
      assignments: _recMissingList,
    );
  }

  get _completed {
    return assignmentBodyList(
      assignments: _recDoneList,
    );
  }

  Widget assignmentBodyList({required List<Assigned> assignments}) {
    assignments = assignments.reversed.toList();
    return ListView.builder(
        // reverse: true,
        itemCount: assignments.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Container(
                // color: Colors.blue,
                height: 17.h,
                // width: 40.w,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.assignment,
                                color: Color(0xff3f51b5),
                                size: 13.sp,
                              ),
                              Container(
                                  width: 70.w,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '  ${assignments[index].course.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: myTextStyleHeader[phoneSize],
                                  )),
                            ],
                          ),
                          (assignments[index].mResult.turnedin == "1" &&
                                  assignments[index].mResult.mStatus == 'Done')
                              ? Text('__/${assignments[index].marks}',
                                  style: myTextStyleBodyBlueGray[phoneSize])
                              : (assignments[index].mResult.turnedin == "1" &&
                                      assignments[index].mResult.mStatus !=
                                          'Done')
                                  ? Text(
                                      '${assignments[index].mResult.mStatus}',
                                      style: myTextStyleHeader[phoneSize])
                                  : Text(''),
                        ],
                      ),
                      Container(
                          width: 70.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${assignments[index].name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: myTextStyleBody[phoneSize],
                          )),
                      Row(
                        children: [
                          Text(
                            'Assigned on ',
                            style: myTextStyleHeader[phoneSize],
                          ),
                          Text('${assignments[index].mCreatedate}',
                              style: myTextStyleBody[phoneSize]),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Due on ',
                            style: myTextStyleHeader[phoneSize],
                          ),
                          Text('${assignments[index].mDuedate}',
                              style: myTextStyleBody[phoneSize]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () async {
              storage.write('reloadAssignment', false);
              var data = await Get.to(() => HomeworkDetailPage(
                    assignmentId: assignments[index].id,
                  ));
              print("data=$data");
              if (storage.read('reloadAssignment') == true) {
                //print("reload");
                _recAssignedList = [];
                _recMissingList = [];
                _recDoneList = [];
                _fetchAssignment();
              }
            },
          );
        });
  }

  void _fetchAssignment() {
    fetchAssignment().then((value) {
      setState(() {
        try {
          _recAssignedList.addAll(value.assigned);
          _recMissingList.addAll(value.missing);
          _recDoneList.addAll(value.done);
          _emptyAssigned = _recAssignedList.length;
          _emptyMissing = _recMissingList.length;
          _emptyDone = _recDoneList.length;
          storage.write('assignment_badge', _emptyAssigned + _emptyMissing);
          isLoading = true;
        } catch (err) {
          CustomDialog.error(
            title: "Error",
            message: "$value",
            context: context,
            barrierDismissible: true,
            bottonTitle: "Reload",
            ontap: () {
              Get.back();
              _fetchAssignment();
            },
          );
        }
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
