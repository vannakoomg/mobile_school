import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/models/ExamScheduleDB.dart';
import 'package:school/repos/exam_schedule.dart';
import 'package:school/screens/theme/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import 'blank_page.dart';

class ExamSchedulePage extends StatefulWidget {
  const ExamSchedulePage({Key? key}) : super(key: key);

  @override
  _ExamSchedulePageState createState() => _ExamSchedulePageState();
}

class _ExamSchedulePageState extends State<ExamSchedulePage> {
  late List<Datum> _examScheduleList = [];
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool isMoreLoading = true;
  bool isFirstLoading = true;
  late final PhoneSize phoneSize;
  final DateFormat _format = new DateFormat("yyyy-MM-dd");
  final storage = GetStorage();
  int? _empty;
  Map<String,Color>  daysColorMap = {
    "Mon": Colors.yellowAccent.shade700,
    "Tue": Colors.purple.shade300,
    "Wed": Colors.greenAccent.shade200,
    "Thu": Colors.green,
    "Fri": Colors.blueAccent,
    "Sat": Colors.deepPurple,
    "Sun": Colors.redAccent,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Exam Schedules"),
      ),
      body: _buildBody,
    );
  }

  void _firstLoad() {
    fetchExamSchedule().then((value) {
      _examScheduleList.clear();
      setState(() {
        try {
          print("value.data.data=${value.data.nextPageUrl}");
          _empty = value.data.total;
          _examScheduleList.addAll(value.data.data);
          isFirstLoading = false;
          isMoreLoading = false;
        } catch (err) {
          isMoreLoading = false;
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

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          _firstLoad();
        },
        child: Text("Reload"));
  }

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    _firstLoad();
    _scrollController.addListener(() {
      if (!isFirstLoading) {
        setState(() {
          isMoreLoading = true;
          isFirstLoading = true;
        });
      }
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          isMoreLoading) {
        fetchExamSchedule(pageNo: (++_page).toString()).then((value) {
          setState(() {
            value.data.nextPageUrl == null
                ? isMoreLoading = false
                : isMoreLoading = true;
            _examScheduleList.addAll(value.data.data);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  get _buildBody {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isMoreLoading = true;
          _page = 1;
          _firstLoad();
        });
      },
      child: Container(
        alignment: Alignment.center,
        child: _empty == 0 ? BlankPage() : _buildListView(_examScheduleList),
      ),
    );
  }

  _buildListView(List<Datum> items) {
    return ListView.builder(
        padding: EdgeInsets.all(8),
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
            return _buildItem(items[index]);
          }
        });
  }

  _buildItem(Datum item) {
    return InkWell(
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    height: SizerUtil.deviceType == DeviceType.tablet ? 10.5.h : 11.5.h,
                    width: SizerUtil.deviceType == DeviceType.tablet ? 15.w : 20.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        border: Border.all(color: Colors.blueAccent)),
                    child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Container(
                                  width: 100.w,
                                  padding: const EdgeInsets.all(5.0),
                                  child: Center(child: Text(DateFormat('EEE').format(_format.parse(item.date)), style: myTextStyleHeaderWhite[phoneSize],)),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(11.0),
                                        topRight: Radius.circular(11.0)),
                                    color: daysColorMap['${DateFormat('EEE').format(_format.parse(item.date))}'],
                                    //Gradient
                                  ),
                                ),
                                Container(
                                  // color: Colors.red,
                                  width: 100.w,
                                  height: 7.h,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(DateFormat('dd').format(_format.parse(item.date)), style: myTextStyleHeader[phoneSize],),
                                      Text(DateFormat('MMM').format(_format.parse(item.date)), style: myTextStyleHeader[phoneSize],),
                                      Text(DateFormat('yyyy').format(_format.parse(item.date)), style: myTextStyleHeader[phoneSize],),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      // width: 300,
                      // color: Colors.red,
                      height: 12.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: TextStyle(color: Color(0xff1d1a56), fontWeight: FontWeight.bold, fontSize: SizerUtil.deviceType == DeviceType.tablet ? 12.sp : 14.sp),
                              )),
                          Text('${item.course.name}', style: myTextStyleBody[phoneSize]),
                          Row(
                            children: [
                              Text('${item.startTime}', style: myTextStyleBody[phoneSize]),
                              Text(' to '),
                              Text('${item.endTime}', style: myTextStyleBody[phoneSize]),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isMoreLoading ? 1.0 : 00,
          child: Shimmer.fromColors(
            child: ListTile(
              leading: Icon(
                Icons.image,
                size: 50.0,
              ),
              title: SizedBox(
                child: Container(
                  color: Colors.grey.shade300,
                ),
                height: 10,
              ),
              subtitle: SizedBox(
                child: Container(
                  color: Colors.grey.shade300,
                ),
                height: 10,
              ),
            ),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }
}
