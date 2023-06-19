// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' as storage;
import 'package:school/models/FeedbackDetailDB.dart';
import 'package:school/repos/feedback_detail.dart';
import 'package:school/repos/notification_list.dart';
import 'package:school/repos/notification_mark_as_read_one_by_one.dart';
import 'package:school/screens/theme/theme.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sizer/sizer.dart';

class FeedbackDetail extends StatefulWidget {
  final String item;
  const FeedbackDetail({Key? key, required this.item}) : super(key: key);

  @override
  _FeedbackDetailState createState() => _FeedbackDetailState();
}

class _FeedbackDetailState extends State<FeedbackDetail> {
  late Data _feedbackDetail;
  late final PhoneSize phoneSize;
  bool isLoading = false;
  late String _item;
  late String _notificationId;
  final _storage = storage.GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
      ),
      body: _buildBody,
    );
  }

  void _fetchFeedbackDetail(String id) {
    fetchFeedbackDetail(trId: id).then((value) {
      setState(() {
        try {
          print("value.data=${value.data}");
          _feedbackDetail = value.data;
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
          _fetchFeedbackDetail(_item);
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
                    child: CachedNetworkImage(
                      imageUrl: _feedbackDetail.fullimage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Container(),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                .format(_feedbackDetail.createdAt),
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
                            _feedbackDetail.time,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        color: Colors.grey.shade300,
                        child: Text(
                          _feedbackDetail.question,
                          textAlign: TextAlign.justify,
                          style: myTextStyleBody[phoneSize],
                        ),
                      ),
                      SizedBox(
                        height: 1.h,
                      ),
                      _feedbackDetail.reply != 0
                          ? Column(
                              children: [
                                Container(
                                  height: 1,
                                  width: 95.w,
                                  color: Colors.grey.shade300,
                                  margin: EdgeInsets.only(top: 5, bottom: 10),
                                ),
                                Container(
                                  width: 100.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 5.h,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                    'ICS International School / ',
                                                    style: myTextStyleHeader[
                                                        phoneSize]),
                                                Text('Replied',
                                                    style: TextStyle(
                                                        color:
                                                            Colors.blueAccent)),
                                              ],
                                            ),
                                            Text(_feedbackDetail.repliedAt,
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 1.h,
                                      ),
                                      SizedBox(
                                        child: Linkify(
                                          onOpen: _onOpen,
                                          text: _feedbackDetail.answer,
                                          style: myTextStyleBody[phoneSize],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : Container(),
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
    _notificationId = Get.arguments.toString();
    // print("_notificationId=$_notificationId");
    if (_notificationId != "fbDetail") _markAsReadOneByOne(_notificationId);

    _fetchFeedbackDetail(_item);
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

  Future<void> _markAsReadOneByOne(String trId) async {
    await notificationMarkAsReadOneByOne(trId: trId);
    _fetchNotificationCount();
  }

  void _fetchNotificationCount() {
    fetchNotification(read: '2').then((value) {
      try {
        setState(() {
          _storage.write('notification_badge', value.data.total);
        });
      } catch (err) {
        print("err=$err");
      }
    });
  }
}
