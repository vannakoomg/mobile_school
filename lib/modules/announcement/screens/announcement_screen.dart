import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/announcement/models/announcment_model.dart';
import 'package:school/repos/announcement_list.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school/config/theme/theme.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/widgets/blank_screen.dart';
import 'announcement_detail_screen.dart';

class AnnouncementScreen extends StatefulWidget {
  const AnnouncementScreen({Key? key}) : super(key: key);

  @override
  _AnnouncementScreenState createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends State<AnnouncementScreen> {
  late List<Datum> _recAnnouncementList = [];
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool isMoreLoading = true;
  bool isFirstLoading = true;
  late final PhoneSize phoneSize;
  int? _empty;
  void _firstLoad() {
    fetchAnnouncement().then((value) {
      _recAnnouncementList.clear();
      setState(() {
        try {
          _empty = value.data.total;
          _recAnnouncementList.addAll(value.data.data);
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
        fetchAnnouncement(pageNo: (++_page).toString()).then((value) {
          setState(() {
            value.data.nextPageUrl == null
                ? isMoreLoading = false
                : isMoreLoading = true;
            _recAnnouncementList.addAll(value.data.data);
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
        title: Text("News"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isMoreLoading = true;
            _page = 1;
            _firstLoad();
          });
        },
        child: Container(
          color: Colors.grey.withOpacity(0.2),
          alignment: Alignment.center,
          child: _empty == 0
              ? BlankPage()
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  controller: _scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _recAnnouncementList.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _recAnnouncementList.length) {
                      return _buildProgressIndicator();
                    } else {
                      return _buildItem(_recAnnouncementList[index], index);
                    }
                  },
                ),
        ),
      ),
    );
  }

  _buildItem(Datum item, int i) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          // boxShadow: [
          //   BoxShadow(color: Colors.grey, blurRadius: 20, spreadRadius: 0.5)
          // ]
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
              child: _buildUrlImages(item.fullImage),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                height: 12.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: myTextStyleHeader[phoneSize],
                        )),
                    Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          // color: ,
                        ),
                        SizedBox(
                          width: 0.8.h,
                        ),
                        Text(
                          item.date,
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
                          item.time,
                          style: myTextStyleBody[phoneSize],
                        ),
                        Spacer(),
                        if (item.view != 0)
                          item.view == 1
                              ? Text("${item.view}  view")
                              : Text("${item.view}  views"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Get.to(() => AnnouncementHtml(
                  item: '${item.id}',
                ))!
            .then((value) {
          setState(() {
            _recAnnouncementList[i].view++;
          });
        });
      },
    );
  }

  _buildUrlImages(String urlImage) {
    return Container(
      color: Colors.white,
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
            // boxShadow: [
            //   BoxShadow(blurRadius: 5, color: Colors.grey, offset: Offset(1, 3))
            // ],
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
}
