import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/models/eLearningCourseDB.dart';
import 'package:school/repos/e_learning_course.dart';
import 'package:school/config/theme/theme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:sizer/sizer.dart';

class ELearningVideoDetail extends StatefulWidget {
  final String name, url, id;

  const ELearningVideoDetail(
      {Key? key, required this.name, required this.url, required this.id})
      : super(key: key);

  @override
  _ELearningVideoDetailState createState() => _ELearningVideoDetailState();
}

class _ELearningVideoDetailState extends State<ELearningVideoDetail> {
  ScrollController _scrollController = ScrollController();
  late List<Datum> _eLearningCourseList = [];
  late final PhoneSize phoneSize;
  late YoutubePlayerController _youtubePlayerController;

  bool fullScreen = false;
  String _url = '';
  String _title = '';
  int _index = 0;
  int _page = 1;
  bool isMoreLoading = true;
  bool isFirstLoading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            aspectRatio: 100.h / 100.w,
            controller: _youtubePlayerController,
            showVideoProgressIndicator: true,
            progressColors: ProgressBarColors(
              playedColor: Colors.blue,
              handleColor: Colors.blueAccent,
            ),
          ),
          builder: (context, player) {
            return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
                appBar: AppBar(
                  title: Text(
                    widget.name,
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      height: 30.h,
                      color: Color(0xff1d1a56),
                      child: player,
                    ),
                    Container(
                      height: 5.h,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 1.h),
                      child: Text(
                        _title,
                        style: myTextStyleHeader[phoneSize],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        // child: _buildListView(_eLearningCourseList),
                        child: _buildBody,
                      ),
                    ),
                  ],
                ));
          }),
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
        child: _buildListView(_eLearningCourseList),
      ),
    );
  }

  void runYoutubePlayer() {
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: _url,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: true,
        loop: false,
        isLive: false,
        forceHD: true,
        enableCaption: true,
        // hideThumbnail: true,
      ),
    );
  }

  @override
  void initState() {
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    _url = widget.url.split("/").last;

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
        fetchELearningCourse(
                pageNo: (++_page).toString(),
                courseId: widget.id,
                category: 'video')
            .then((value) {
          setState(() {
            value.data.nextPageUrl == null
                ? isMoreLoading = false
                : isMoreLoading = true;
            _eLearningCourseList.addAll(value.data.data);
          });
        });
      }
    });
    runYoutubePlayer();
    super.initState();
  }

  _buildListView(List<Datum> items) {
    return ListView.builder(
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
    return GestureDetector(
      child: Card(
        color: index == _index ? Colors.grey.shade300 : Colors.white,
        margin: EdgeInsets.all(5),
        elevation: 5,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  SizedBox(
                    child: _buildUrlImages(
                        'https://i1.ytimg.com/vi/${item.url.split("/").last}/hqdefault.jpg'),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                item.lesson,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: myTextStyleHeader[phoneSize],
                              )),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: myTextStyleBody[phoneSize],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    // child: Icon(Icons.navigate_next),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          _index = index;
          _title = item.description;
          _url = item.url.split("/").last;
          _youtubePlayerController.load(_url);
          // _youtubePlayerController.value.isPlaying;
        });
      },
    );
  }

  void _firstLoad() {
    fetchELearningCourse(courseId: widget.id, category: 'video').then((value) {
      _eLearningCourseList.clear();
      setState(() {
        try {
          print("value.data.list=${value.data.data}");
          _title = value.data.data[0].description;
          _eLearningCourseList.addAll(value.data.data);
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

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _youtubePlayerController.pause();
    super.deactivate();
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

  _buildUrlImages(String urlImage) {
    //DefaultCacheManager().removeFile(urlImage);
    return Container(
      color: Colors.white,
      child: CachedNetworkImage(
        height: 11.h,
        width: 13.h,
        imageUrl: urlImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Icon(
          Icons.photo_library_outlined,
          size: 50.sp,
          color: Colors.grey.shade400,
        ),
        errorWidget: (context, url, error) =>
            Image.asset("assets/icons/login_icon/logo_no_background.png"),
      ),
    );
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          _firstLoad();
        },
        child: Text("Reload"));
  }
}
