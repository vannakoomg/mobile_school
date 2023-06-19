import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/models/eLearningSubjectDB.dart';
import 'package:school/repos/e_learning_subject.dart';
import 'package:school/screens/pages/e_learning_video_detail.dart';
import 'package:sizer/sizer.dart';
import 'e_learning_document_detail.dart';

class ELearningSubjectPage extends StatefulWidget {
  const ELearningSubjectPage({Key? key}) : super(key: key);

  @override
  _ELearningSubjectPageState createState() => _ELearningSubjectPageState();
}

class _ELearningSubjectPageState extends State<ELearningSubjectPage> {
  late List<Datum> _eLearningSubjectList = [];
  late bool view;
  late double iconSize;
  late String _title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$_title E-Learning"),
      ),
      body: _buildBody,
    );
  }

  @override
  void initState() {
    super.initState();
    view = true;
    _title = Get.arguments.toString();
    iconSize = SizerUtil.deviceType == DeviceType.tablet ? 15.sp : 20.sp;
    _fetchELearningSubject();
  }

  get _buildBody {
    return Stack(
      children: [
        Container(
          height: 5.h,
          width: 100.w,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                iconSize: iconSize,
                icon: Icon(
                  Icons.grid_view,
                  color: view ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    view = true;
                  });
                },
              ),
              IconButton(
                iconSize: iconSize,
                icon: Icon(
                  Icons.list,
                  color: !view ? Colors.blue : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    view = false;
                  });
                },
              ),
            ],
          ),
        ),
        Container(child: view ? _buildGridMenu : _buildListMenu),
      ],
    );
  }

  get _buildGridMenu {
    return Container(
      margin: EdgeInsets.only(top: 5.h),
      padding: EdgeInsets.only(left: 2.h, right: 2.h),
      color: Colors.grey.shade100,
      child: GridView.builder(
        itemCount: _eLearningSubjectList.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (_title == 'Video')
                Get.to(() => ELearningVideoDetail(
                      name: _eLearningSubjectList[index].name,
                      url: _eLearningSubjectList[index].firstVideo,
                      id: "${_eLearningSubjectList[index].id}",
                    ));
              else
                Get.to(() => ELearningDocumentDetail(
                      id: "${_eLearningSubjectList[index].id}",
                      name: _eLearningSubjectList[index].name,
                    ));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10.h,
                    child:
                        _buildUrlImages(_eLearningSubjectList[index].fullImage),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _eLearningSubjectList[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SizerUtil.deviceType == DeviceType.tablet ? 3 : 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 1.h,
            mainAxisSpacing: 1.h),
      ),
    );
  }

  get _buildListMenu {
    return Container(
      color: Colors.grey.shade100,
      margin: EdgeInsets.only(top: 5.h),
      child: ListView.builder(
          itemCount: _eLearningSubjectList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(5),
              elevation: 5,
              child: ListTile(
                leading: _eLearningSubjectList[index].fullImage != null &&
                        _eLearningSubjectList[index].fullImage != ""
                    ? Image.network(
                        _eLearningSubjectList[index].fullImage,
                        height: 40,
                        width: 40,
                      )
                    : Image.asset(
                        "assets/icons/login_icon/logo_no_background.png",
                        width: 40,
                        height: 40,
                      ),
                title: Text(_eLearningSubjectList[index].name),
                onTap: () {
                  if (_title == 'Video')
                    Get.to(() => ELearningVideoDetail(
                          name: _eLearningSubjectList[index].name,
                          url: _eLearningSubjectList[index].firstVideo,
                          id: "${_eLearningSubjectList[index].id}",
                        ));
                  else
                    Get.to(() => ELearningDocumentDetail(
                          id: "${_eLearningSubjectList[index].id}",
                          name: _eLearningSubjectList[index].name,
                        ));
                },
              ),
            );
          }),
    );
  }

  _buildUrlImages(String urlImage) {
    //DefaultCacheManager().removeFile(urlImage);
    return Container(
      color: Colors.white,
      child: CachedNetworkImage(
        height: 8.h,
        imageUrl: urlImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: imageProvider,
              // fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => Icon(
          Icons.photo_library_outlined,
          size: SizerUtil.deviceType == DeviceType.tablet ? 40.sp : 50.sp,
          color: Colors.grey.shade400,
        ),
        errorWidget: (context, url, error) =>
            Image.asset("assets/icons/login_icon/logo_no_background.png"),
      ),
    );
  }

  void _fetchELearningSubject() {
    fetchELearningSubject().then((value) {
      _eLearningSubjectList.clear();
      setState(() {
        try {
          _eLearningSubjectList.addAll(value.data);
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
          _fetchELearningSubject();
        },
        child: Text("Reload"));
  }
}
