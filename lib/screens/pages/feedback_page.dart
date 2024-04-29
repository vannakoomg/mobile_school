import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/models/FeedbackListDB.dart';
import 'package:school/repos/feedback_category.dart';
import 'package:school/repos/feedback_list.dart';
import 'package:school/screens/pages/feedback_detail.dart';
import 'package:school/screens/pages/feedback_send.dart';
import 'package:school/utils/widgets/custom_dialog.dart';
import 'package:shimmer/shimmer.dart';
import 'package:school/config/theme/theme.dart';
import 'package:sizer/sizer.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  late List<Datum> _feedbackList = [];
  ScrollController _scrollController = ScrollController();
  int _page = 1;
  bool isMoreLoading = true;
  bool isFirstLoading = true;
  bool isAddEnable = false;
  late final PhoneSize phoneSize;
  late List<String> _categoryItem = [];

  void _firstLoad() {
    fetchFeedback().then((value) {
      _feedbackList.clear();
      setState(() {
        try {
          // print("value=$");
          print("value.data.data=${value.data.nextPageUrl}");
          _feedbackList.addAll(value.data.data);
          isFirstLoading = false;
          isMoreLoading = false;
        } catch (err) {
          isMoreLoading = false;
          CustomDialog.error(
            barrierDismissible: true,
            title: "Error",
            message: "$value",
            context: context,
            bottonTitle: "Reload",
            ontap: () {
              Get.back();
              _firstLoad();
              _fetchFeedbackCategory();
            },
          );
        }
      });
    });
  }

  void _fetchFeedbackCategory() {
    fetchFeedbackCategory().then((value) {
      _categoryItem.clear();
      setState(() {
        try {
          print("value.data=${value.data}");
          _categoryItem.addAll(value.data);
          isAddEnable = true;
        } catch (err) {}
      });
    });
  }

  handleReturnData() async {
    var data = await Get.to(() => FeedbackSendPage(sortFilter: _categoryItem));
    if (data == true) {
      setState(() {
        _firstLoad();
      });
    }
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
        fetchFeedback(pageNo: (++_page).toString()).then((value) {
          setState(() {
            value.data.nextPageUrl == null
                ? isMoreLoading = false
                : isMoreLoading = true;
            _feedbackList.addAll(value.data.data);
          });
        });
      }
    });
    _fetchFeedbackCategory();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Feedback List"), actions: <Widget>[
        IconButton(
            onPressed: () {
              handleReturnData();
            },
            icon: isAddEnable ? Icon(Icons.add) : Icon(null)),
      ]),
      body: _buildBody,
    );
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
        child: _buildListView(_feedbackList),
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
        color: item.reply == 0 ? Colors.white : Colors.grey.shade300,
        elevation: 5,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              // height: 120,
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
                                item.question,
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 12.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(''),
                        Icon(Icons.navigate_next),
                        Text(
                          item.reply != 0 ? 'Replied' : '',
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Get.to(
            () => FeedbackDetail(
                  item: '${item.id}',
                ),
            arguments: 'fbDetail');
      },
    );
  }

  _buildUrlImages(String urlImage) {
    return Container(
      // color: Colors.white,
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
}
