import 'dart:async';
import 'dart:io';

import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart' as str;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:school/repos/collection_card.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../models/CollectionCardDB.dart';
import '../../repos/datetime.dart';
import '../../config/theme/theme.dart';

class PickUpCard extends StatefulWidget {
  const PickUpCard({Key? key}) : super(key: key);

  @override
  _PickUpCardState createState() => _PickUpCardState();
}

class _PickUpCardState extends State<PickUpCard> {
  late final PhoneSize phoneSize;
  late Data _recData;
  bool isLoading = false;
  late String device;
  Timer? timer;
  String _dateTime = '';
  final storage = str.GetStorage();
  late Map<String, dynamic> _mapAllUser;
  List<Menu> _map = [];
  late Menu selectedUser;
  DefaultCacheManager manager = new DefaultCacheManager();
  late String dropdownValue;
  List<String> strName = [];
  String qrCode = '';

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 60), (t) {
      setState(() {
        _fetchDateTime();
      });
    });
  }

  @override
  void dispose() {
    timer!.cancel(); //cancel the periodic task
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    manager.emptyCache();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;

    if (Platform.isAndroid)
      device = 'Android';
    else
      device = 'iOS';
    // _dateTime = DateFormat("yyyy-MM-dd – kk:mm:ss").format(DateTime.now());
    int i = 0, k = 0;
    _mapAllUser = storage.read('mapUser');
    _mapAllUser.forEach((key, value) {
      _map.add(Menu(id: key, name: value['name'], userToken: value['token']));
      i++;
      if (key == storage.read('isActive')) {
        k = i;
      }
    });
    selectedUser = _map[k - 1];
    _fetchCollectionCard(
        userToken: '${_mapAllUser['${storage.read('isActive')}']['token']}');
    _fetchDateTime();
    startTimer(); // 5 seconds.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar,
      body:
          !isLoading ? Center(child: CircularProgressIndicator()) : _buildBody,
    );
  }

  void _fetchDateTime() {
    fetchDateTime().then((value) {
      Future.delayed(const Duration(milliseconds: 500), () {
        setState(() {
          try {
            _dateTime = '${value.data.date} ${value.data.time}';
            qrCode = '${_recData.rfIdCard}&$_dateTime';

            // if('${value.name} ${value.value}' == storage.read('isVersion'))
            //   Future.delayed(Duration.zero, () {
            //     PopupNewVersion().dialogBuilder(context);
            //   });
          } catch (err) {
            print("err=$err");
          }
        });
      });
    });
  }

  get _buildAppBar {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.cyan,
      title: Container(
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                // color: Colors.blueAccent,
                height: 100.h,
                width: 10.w,
                child: Icon(
                  device == 'iOS' ? Icons.arrow_back_ios : Icons.arrow_back,
                  size: 25,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              // width: 30.w,
              // color: Colors.blueAccent,
              child: DropdownButton<Menu>(
                value: selectedUser,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                ),
                dropdownColor: Colors.cyan,
                iconSize: 30,
                elevation: 16,
                style: const TextStyle(color: Colors.white),
                underline: Container(
                  height: 2,
                  color: Colors.white,
                ),
                onChanged: (Menu? newValue) {
                  setState(() {
                    selectedUser = newValue!;
                    // print("dropdownValue=$dropdownValue");
                  });
                },
                items: _map.map<DropdownMenuItem<Menu>>((Menu value) {
                  return DropdownMenuItem<Menu>(
                    onTap: () {
                      // print("valuevalue=${value.name}");
                      _fetchCollectionCard(userToken: value.userToken);
                      _fetchDateTime();
                      // value.index();
                      // print("_mapAllUser_mapAllUser=${_map[0]['name']}");
                    },
                    value: value,
                    child: Text(
                      value.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 18
                              : 14),
                    ),
                  );
                }).toList(),
              ),
            ),
            Container(
                // alignment: Alignment.topRight,
                // width: 10.w,
                // height: 100.w,
                // color: Colors.red,
                child: AnimateIcon(
              key: UniqueKey(),
              onTap: () {
                _fetchDateTime();
                // _fetchPosUser();
                // var _checkTime = timeCheck();
                // print("timeCheck=$_checkTime");
              },
              iconType: IconType.animatedOnTap,
              // height: 8.w,
              width: 8.w,
              color: Colors.white,
              animateIcon: AnimateIcons.refresh,
            ))
          ],
        ),
      ),
      centerTitle: true,
    );
  }

  get _buildBody {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 10.h),
              alignment: Alignment.center,
              height: 35.h,
              width: 100.w,
              color: Colors.cyan,
              child: _recData.rfIdCard != null
                  ? QrImage(
                      foregroundColor: Colors.cyan,
                      backgroundColor: Colors.white,
                      data: '$qrCode',
                      version: QrVersions.auto,
                      size: 20.h,
                      gapless: false,
                    )
                  : null,
            ),
            Expanded(
                child: Container(
              color: Colors.white,
            ))
          ],
        ),
        Positioned(
          child: Container(
            height: 58.h,
            width: 90.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                  ),
                  height: 7.h,
                  width: 100.w,
                  // color: Colors.grey.shade300,
                  child: Text('PICK UP VIRTUAL CARD',
                      style: myTextStyleHeaderBigSize[phoneSize]),
                  alignment: Alignment.center,
                ),
                Container(
                  // width: 90.w,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      _buildUrlImages('${_recData.fullImage}'),
                      SizedBox(
                        width: 2.w,
                      ),
                      Container(
                        height: 18.h,
                        width: 55.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Student ID: ${_recData.email}',
                                style: myTextStyleHeader[phoneSize]),
                            Text('ឈ្មោះ: ${_recData.nameKh}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: myTextStyleHeader[phoneSize]),
                            Text('Name: ${_recData.name}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: myTextStyleHeader[phoneSize]),
                            AutoSizeText(
                              'Class: ${_recData.dataClass.name}',
                              style: TextStyle(
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 18
                                          : 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1d1a56)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.h,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: SizerUtil.deviceType == DeviceType.tablet
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          _buildUrlImages('${_recData.guardian1Photo}'),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text('${_recData.guardian1}',
                              style: myTextStyleBody[phoneSize]),
                        ],
                      ),
                      Column(
                        children: [
                          _buildUrlImages('${_recData.guardian2Photo}'),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text('${_recData.guardian2}',
                              style: myTextStyleBody[phoneSize]),
                        ],
                      ),
                      Column(
                        children: [
                          _buildUrlImages('${_recData.guardian3Photo}'),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          Text('${_recData.guardian3}',
                              style: myTextStyleBody[phoneSize]),
                        ],
                      ),
                    ],
                  ),
                ),
                // Text(
                //   "$_dateTime",
                //   style: TextStyle(fontSize: 8.sp),
                // ),
              ],
            ),
          ),
          // right: 5,
          top: 25.h,
        ),
        // Positioned(
        //   child: InkWell(
        //     child: Icon(
        //       device == 'iOS' ? Icons.arrow_back_ios : Icons.arrow_back,
        //       size: 30,
        //       color: Colors.white,
        //     ),
        //     onTap: () {
        //       Navigator.of(context).pop();
        //     },
        //   ),
        //   left: 20,
        //   top: 50,
        // )
      ],
    );
  }

  _buildUrlImages(String urlImage) {
    //DefaultCacheManager().removeFile(urlImage);
    return Container(
      color: Colors.white,
      child: InkWell(
        child: CachedNetworkImage(
          height: SizerUtil.deviceType == DeviceType.tablet ? 19.h : 17.h,
          width: SizerUtil.deviceType == DeviceType.tablet ? 18.h : 27.w,
          imageUrl: urlImage,
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              // shape: BoxShape.circle,
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: imageProvider,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5, color: Colors.grey, offset: Offset(1, 3))
              ],
            ),
          ),
          placeholder: (context, url) => _buildProgressIndicator(),
          errorWidget: (context, url, error) => _buildError(),
        ),
      ),
    );
  }

  _buildError() {
    return Container(
        decoration: BoxDecoration(
      // shape: BoxShape.circle,
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      boxShadow: [
        BoxShadow(blurRadius: 0, color: Colors.grey, offset: Offset(1, 3))
      ],
    ));
  }

  _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: 1.0,
          child: Shimmer.fromColors(
            child: Icon(
              Icons.image,
              size: 10.h,
            ),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }

  void _fetchCollectionCard({required String userToken}) {
    fetchCollectionCard(userToken: userToken).then((value) {
      setState(() {
        try {
          print("value=${value.status}");
          _recData = value.data;
          // qrCode = '${_recData.rfIdCard}&$_dateTime';
          // _recData.fullImage = _recData.guardian1Photo = _recData.guardian2Photo = _recData.guardian3Photo = 'https://images.unsplash.com/photo-1524860769472-246b6afea403?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8aGFja3xlbnwwfHwwfHw%3D&w=1000&q=80';
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
          _fetchCollectionCard(
              userToken:
                  '${_mapAllUser['${storage.read('isActive')}']['token']}');
        },
        child: Text("Reload"));
  }

  // Future<void> disableCapture() async {
  //   //disable screenshots and record screen in current screen
  //   await ScreenProtector.preventScreenshotOn();
  //   // await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_KEEP_SCREEN_ON);
  // }
}

class Menu {
  String id, name, userToken;

  Menu({required this.id, required this.name, required this.userToken});
}
