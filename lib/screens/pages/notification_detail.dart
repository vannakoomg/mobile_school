// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/models/NotificationDetailDB.dart';
import 'package:school/repos/notification_detail.dart';
import 'package:school/repos/notification_list.dart';
import 'package:school/repos/notification_mark_as_read_one_by_one.dart';
import 'package:school/screens/theme/theme.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

class NotificationsDetail extends StatefulWidget {
  final String item;
  const NotificationsDetail({Key? key, required this.item}) : super(key: key);

  @override
  _NotificationsDetailState createState() => _NotificationsDetailState();
}

class _NotificationsDetailState extends State<NotificationsDetail> {
  late NotificationDetailDbData _notificationDetail;
  late final PhoneSize phoneSize;
  bool isLoading = false;
  late String _item;
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            !isLoading ? Text('') : Text('${_notificationDetail.data.title}'),
      ),
      body: _buildBody,
    );
  }

  void _fetchNotificationDetail(String id) {
    fetchNotificationDetail(trId: id).then((value) {
      setState(() {
        try {
          print("value.data=${value.data}");
          _notificationDetail = value.data;
          _fetchNotificationCount();
          isLoading = true;
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

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          _fetchNotificationDetail(_item);
        },
        child: Text("Reload"));
  }

  get _buildBody {
    return !isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  color: Colors.blueGrey,
                  child: Container(
                    width: 100.w,
                    child: InteractiveViewer(
                      child: CachedNetworkImage(
                        imageUrl: _notificationDetail.data.fullimage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Container(),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // SizedBox(child: Text(_notificationDetail.data.title, style: myTextStyleHeader[phoneSize],),),
                      // SizedBox(height: 1.h,),
                      Row(
                        children: [
                          Icon(
                            Icons.event_sharp,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 0.8.h,
                          ),
                          Text(
                            DateFormat('MMMM dd,yyyy')
                                .format(_notificationDetail.createdAt),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 0.8.h,
                          ),
                          Text(
                            DateFormat('HH:mm:ss')
                                .format(_notificationDetail.createdAt),
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        width: 95.w,
                        color: Colors.grey.shade300,
                        margin: EdgeInsets.only(top: 5, bottom: 10),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      SizedBox(
                        child: Linkify(
                          onOpen: _onOpen,
                          text: _notificationDetail.data.message,
                          style: myTextStyleBody[phoneSize],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  @override
  void initState() {
    super.initState();
    _item = widget.item;
    _fetchNotificationDetail(_item);
    _markAsReadOneByOne(_item);
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }

  void _fetchNotificationCount() {
    fetchNotification(read: '2').then((value) {
      try {
        setState(() {
          storage.write('notification_badge', value.data.total);
        });
      } catch (err) {
        print("err=$err");
      }
    });
  }

  void _markAsReadOneByOne(String trId) {
    notificationMarkAsReadOneByOne(trId: trId);
  }
}
