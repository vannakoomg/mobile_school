import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/models/AttendanceDB.dart';
import 'package:school/repos/attendance_list.dart';
import 'package:get/get.dart';
import 'package:school/config/theme/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({Key? key}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late List<Datum> _recAttendanceList = [];
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool isMoreLoading = true;
  bool isFirstLoading = true;
  late final PhoneSize phoneSize;
  late double iconSize;
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance"),
      ),
      body: _buildBody,
    );
  }

  void _firstLoad() {
    fetchAttendance().then((value) {
      _recAttendanceList.clear();
      setState(() {
        try {
          print('value.data.data=${value.data.data}');
          _recAttendanceList.addAll(value.data.data);
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
    iconSize = SizerUtil.deviceType == DeviceType.tablet ? 50 : 30;
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
        fetchAttendance(pageNo: (++_page).toString()).then((value) {
          setState(() {
            value.data.nextPageUrl == null
                ? isMoreLoading = false
                : isMoreLoading = true;
            _recAttendanceList.addAll(value.data.data);
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
        child: _buildListView(_recAttendanceList),
      ),
    );
  }

  _buildListView(List<Datum> items) {
    return Column(
      children: [
        Container(
          color: Colors.cyan,
          padding: EdgeInsets.all(10),
          height: SizerUtil.deviceType == DeviceType.tablet ? 25.sp : 40.sp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(
                  'Date',
                  style: myTextStyleHeader[phoneSize],
                ),
                width: 30.w,
                alignment: Alignment.centerLeft,
              ),
              Container(
                child: Text('Check-In', style: myTextStyleHeader[phoneSize]),
                width: 30.w,
                alignment: Alignment.center,
              ),
              Container(
                child: Text('Check-Out', style: myTextStyleHeader[phoneSize]),
                width: 30.w,
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                // if(items.length==0){
                //   return Container(child: Text("NO DATA"), alignment: Alignment.center, height: 85.h);
                // }
                if (index == items.length) {
                  return _buildProgressIndicator();
                } else {
                  return _buildItem(items[index]);
                }
              }),
        ),
      ],
    );
  }

  _buildItem(Datum item) {
    final Color checkInColor, checkOutColor;
    checkOutColor = Colors.green;
    checkInColor = Colors.blue;
    return Card(
      color: item.status == 'Absent & Excused'
          ? Colors.green
          : item.status == 'Absent & Unexcused'
              ? Colors.yellow
              : Colors.white,
      elevation: 5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30.w,
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('${item.dateFormat}',
                      style: myTextStyleBody[phoneSize]),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text('${item.status}',
                      style: item.status == 'Present'
                          ? myTextStyleHeader[phoneSize]
                          : myTextStyleHeaderRed[phoneSize]),
                ),
              ],
            ),
          ),
          item.status == 'Present'
              ? Container(
                  width: 30.w,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/home_screen_icon/attendance_clock.png',
                        height: iconSize,
                        width: iconSize,
                        color: checkInColor,
                      ),
                      Text('${item.timeFormat}',
                          style: myTextStyleBody[phoneSize]),
                    ],
                  ),
                )
              : Text(''),
          item.status == 'Present'
              ? Container(
                  width: 30.w,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/home_screen_icon/attendance_clock.png',
                        height: iconSize,
                        width: iconSize,
                        color: checkOutColor,
                      ),
                      Text('07:26 AM', style: myTextStyleBody[phoneSize]),
                    ],
                  ),
                )
              : Text(''),
        ],
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
