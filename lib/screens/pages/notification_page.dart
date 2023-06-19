import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/models/NotificationListDB.dart';
import 'package:school/repos/notification_list.dart';
import 'package:school/repos/notification_mark_as_read.dart';
import 'package:school/repos/notification_mark_as_read_one_by_one.dart';
import 'package:school/screens/pages/notification_detail.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school/screens/theme/theme.dart';
import 'package:sizer/sizer.dart';
import 'blank_page.dart';
import 'feedback_detail.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late List<Datum> _recNotificationList = [];
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool isMoreLoading = true;
  bool isFirstLoading = true;
  late final PhoneSize phoneSize;
  final storage = GetStorage();
  int? _empty;

  void _firstLoad() {
    fetchNotification().then((value) {
      _recNotificationList.clear();
      setState(() {
        try {
          print("value.data.data=${value.data.nextPageUrl}");
          _empty = value.data.total;
          _recNotificationList.addAll(value.data.data);
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
    // _empty=0;
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
        fetchNotification(pageNo: (++_page).toString()).then((value) {
          setState(() {
            value.data.nextPageUrl == null
                ? isMoreLoading = false
                : isMoreLoading = true;
            _recNotificationList.addAll(value.data.data);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
        actions: <Widget>[
          Center(
            child: InkWell(
              // textColor: Colors.white,
              onTap: () {
                _markAsRead();
              },
              child: Text("Mark as read"),
            ),
          ),
        ],
      ),
      body: _buildBody,
    );
  }

  void _markAsRead() {
    notificationMarkAsRead();
    setState(() {
      _recNotificationList.forEach((f) => f.readAt = '1');
      storage.write('notification_badge', 0);
    });
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
        child: _empty == 0 ? BlankPage() : _buildListView(_recNotificationList),
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
            return _buildItem(items[index], index);
          }
        });
  }

  _buildItem(Datum item, int index) {
    return InkWell(
      child: Card(
        color: item.readAt != null ? Colors.white : Colors.grey.shade300,
        elevation: 5,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 12.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.data.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: myTextStyleHeader[phoneSize],
                              )),
                          Row(
                            children: [
                              Icon(
                                Icons.event_sharp,
                                color: Color(0xff1d1a56),
                              ),
                              SizedBox(
                                width: 0.8.h,
                              ),
                              Text(
                                DateFormat('MMMM dd,yyyy')
                                    .format(item.createdAt),
                                style: myTextStyleBody[phoneSize],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Color(0xff1d1a56),
                              ),
                              SizedBox(
                                width: 0.8.h,
                              ),
                              Text(
                                DateFormat('HH:mm:ss').format(item.createdAt),
                                style: myTextStyleBody[phoneSize],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  SizedBox(
                    child: _buildUrlImages(item.data.fullimage),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _recNotificationList[index].readAt = '1';
        });
        if (item.data.appname == 'Fingerprint Notification') {
          _markAsReadOneByOne(item.id);
          Get.toNamed('attendance');
        } else if (item.data.appname == 'ICS Feedback') {
          Get.to(() => FeedbackDetail(item: '${item.data.trid}'),
              arguments: item.id);
        } else {
          Get.to(() => NotificationsDetail(
                item: item.id,
              ));
        }
      },
    );
  }

  _buildUrlImages(String urlImage) {
    return Container(
      child: CachedNetworkImage(
        height: 12.h,
        width: 12.h,
        imageUrl: urlImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.grey, offset: Offset(1, 3))
            ],
          ),
        ),
        placeholder: (context, url) => Icon(
          Icons.photo_library_outlined,
          size: SizerUtil.deviceType == DeviceType.tablet ? 40.sp : 50.sp,
          color: Colors.grey.shade400,
        ),
        errorWidget: (context, url, error) =>
            Image.asset("assets/icons/login_icon/logo_with_radius.png"),
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

  Future<void> _markAsReadOneByOne(String trId) async {
    await notificationMarkAsReadOneByOne(trId: trId);
    _fetchNotificationCount();
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
}
