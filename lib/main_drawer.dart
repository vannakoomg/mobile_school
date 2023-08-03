// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'repos/exam_schedule.dart';
import 'repos/logout.dart';
import 'repos/notification_list.dart';
import 'repos/profile_detail.dart';
import 'screens/pages/switch_account.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  final storage = GetStorage();
  late Map<String, dynamic> _mapUser;
  List<String> studentName = [];
  String studentLastName = "", studentFirstName = "";
  late Map<String, dynamic> mapUser;
  DefaultCacheManager manager = new DefaultCacheManager();

  @override
  void initState() {
    super.initState();
    if (storage.read('isName') != null) {
      debugPrint("nininininin");

      studentName = storage.read('isName').split(" ");
      for (var i = 0; i < studentName.length; i++) {
        if (i == 0)
          studentFirstName = studentName[i].toUpperCase();
        else
          studentLastName += studentName[i] + ' ';
      }
    }
    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizerUtil.deviceType == DeviceType.tablet ? 45.w : 67.w,
      child: Drawer(
        child: Column(
          children: <Widget>[
            _buildHeader,
            Container(
              color: Colors.grey.shade300,
              height: 1,
            ),
            _buildBody,
            _buildFooter
          ],
        ),
      ),
    );
  }

  get _buildHeader {
    // print("storage.read('isPhoto')=${storage.read('isPhoto')}");
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      color: Colors.grey.shade200,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            storage.read('isPhoto') != null
                ? _buildUrlImages(storage.read('isPhoto'))
                : _buildDefaultImage(),
            SizedBox(width: 5),
            Container(
              // color: Colors.red,
              height: SizerUtil.deviceType == DeviceType.tablet ? 13.h : 10.h,
              // color: Colors.red,
              margin: EdgeInsets.only(top: 30, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:
                        SizerUtil.deviceType == DeviceType.tablet ? 25.w : 35.w,
                    // color: Colors.red,
                    child: storage.read('user_token') != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                studentLastName,
                                style: TextStyle(
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.tablet
                                        ? 7.sp
                                        : 12.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                studentFirstName,
                                style: TextStyle(
                                    fontSize: SizerUtil.deviceType ==
                                            DeviceType.tablet
                                        ? 7.sp
                                        : 12.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : Text(
                            'ICSIS',
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 7.sp
                                        : 10.sp,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  Container(
                    width:
                        SizerUtil.deviceType == DeviceType.tablet ? 25.w : 35.w,
                    child: Text(
                      storage.read('user_token') != null
                          ? 'ID: ${storage.read('isActive')}'
                          : '',
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 6.sp
                              : 9.sp),
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

  get _buildBody {
    return Expanded(
      child: Container(
        color: Colors.grey.shade200,
        // height: 10.h,
        child: ListView(
          padding: EdgeInsets.only(top: 0.0),
          // height: 1000,
          children: <Widget>[
            storage.read('user_token') != null
                ? Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      'Accounts',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  )
                : Container(),
            storage.read('user_token') != null
                ? ListTile(
                    leading:
                        Icon(Icons.switch_account, color: Color(0xff1d1a56)),
                    title: Align(
                      alignment: Alignment(
                          SizerUtil.deviceType == DeviceType.tablet
                              ? -1.2
                              : -1.7,
                          0),
                      child: Text("Switch Account",
                          style: TextStyle(
                              color: Color(0xff1d1a56),
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 7.sp
                                      : 11.sp)),
                    ),
                    onTap: () async {
                      var data = await Get.to(() => SwitchAccountPage());
                      if (data == null) {
                        _fetchNotificationCount();
                      }
                      // }
                    },
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text('Media',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  )),
            ),
            buildMenuItem(
              text: 'Facebook',
              icon: FontAwesomeIcons.facebook,
              onClicked: () {
                customLaunchDirectApp(id: '836813176377920');
              },
            ),
            buildMenuItem(
              text: 'Instagram',
              icon: FontAwesomeIcons.instagram,
              onClicked: () {
                customLaunch('http://instagram.com/icsis_mc_admin');
              },
            ),
            buildMenuItem(
              text: 'Youtube',
              icon: FontAwesomeIcons.youtube,
              onClicked: () {
                customLaunch(
                    'https://www.youtube.com/channel/UCs-Pp54gcmQjnQAVhcx4q9A/featured');
              },
            ),
            buildMenuItem(
              text: 'Telegram',
              icon: FontAwesomeIcons.telegram,
              onClicked: () {
                customLaunch('https://telegram.me/icsismc');
              },
            ),
            storage.read('user_token') != null
                ? ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.red),
                    title: Align(
                      alignment: Alignment(
                          SizerUtil.deviceType == DeviceType.tablet
                              ? -1.2
                              : -1.4,
                          0),
                      child: Text("Logout",
                          style: TextStyle(
                              color: Color(0xff1d1a56),
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 7.sp
                                      : 11.sp)),
                    ),
                    hoverColor: Colors.red,
                    onTap: () {
                      _userLogout();
                    },
                  )
                : ListTile(
                    leading: Icon(Icons.login, color: Color(0xff1d1a56)),
                    title: Align(
                      alignment: Alignment(
                          SizerUtil.deviceType == DeviceType.tablet
                              ? -1.2
                              : -1.4,
                          0),
                      child: Text("Login",
                          style: TextStyle(
                              color: Color(0xff1d1a56),
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 7.sp
                                      : 11.sp)),
                    ),
                    hoverColor: Colors.red,
                    onTap: () async {
                      var data =
                          await Get.toNamed('login', arguments: 'no route');
                      // print("datadata=$data");
                      if (data == true) {
                        setState(() {
                          _fetchNotificationCount();
                          _fetchExamScheduleCount();
                          _fetchProfile();
                        });
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  get _buildFooter {
    return Container(
      color: Colors.grey.shade200,
      // color: Colors.red,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.grey.shade300,
              height: 1,
            ),
            _spaceHeight,
            Text('${storage.read('isVersion')}',
                style: TextStyle(color: Colors.grey.shade600)),
            _spaceHeight,
          ],
        ),
      ),
    );
  }

  void _fetchNotificationCount() {
    fetchNotification(read: '2').then((value) {
      try {
        setState(() {
          storage.write('notification_badge', value.data.total);
          Navigator.of(context).pop();
        });
      } catch (err) {
        print("err=$err");
      }
    });
  }

  void _fetchExamScheduleCount() {
    if (storage.read('user_token') == null) return;

    fetchExamSchedule().then((value) {
      try {
        setState(() {
          storage.write('exam_schedule_badge', value.data.total);
        });
      } catch (err) {
        print('err=$err');
      }
    });
  }

  void _fetchProfile() {
    fetchProfile(apiKey: storage.read('user_token')).then((value) {
      setState(() {
        try {
          mapUser = {
            "${value.data.data[0].email}": {
              "name": "${value.data.data[0].name}",
              "token": "${storage.read('user_token')}",
              "classId": "${value.data.data[0].classId}",
              "userId": "${value.data.data[0].id}",
              "gradeLevel": "${value.data.data[0].className}",
              "password": "${storage.read('isPassword')}",
              "photo": "${value.data.data[0].fullImage}",
            },
          };

          storage.write('mapUser', mapUser);
          storage.write('isActive', value.data.data[0].email);
          storage.write('isName', value.data.data[0].name);
          storage.write('isClassId', value.data.data[0].classId);
          storage.write('isUserId', value.data.data[0].id);
          storage.write('isGradeLevel', value.data.data[0].className);
          storage.write('isPhoto', value.data.data[0].fullImage);
        } catch (err) {
          print('Error=$err');
        }
      });
    });
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Color(0xff1d1a56);
    final hoverColor = Colors.blue;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Align(
        alignment: Alignment(
            SizerUtil.deviceType == DeviceType.tablet ? -1.2 : -1.4, 0),
        child: Text(text,
            style: TextStyle(
                color: color,
                fontSize:
                    SizerUtil.deviceType == DeviceType.tablet ? 7.sp : 11.sp)),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  Future<void> customLaunchDirectApp({required String id}) async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/$id';
    } else {
      fbProtocolUrl = 'fb://page/$id';
    }
    String fallbackUrl = 'https://www.facebook.com/$id/';
    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }

  _buildUrlImages(String urlImage) {
    //DefaultCacheManager().removeFile(urlImage);
    return Container(
      height: SizerUtil.deviceType == DeviceType.tablet ? 13.h : 10.h,
      // color: Colors.white,
      margin: EdgeInsets.only(top: 30),
      child: CachedNetworkImage(
        height: 10.h,
        width: 10.h,
        imageUrl: urlImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            // borderRadius: BorderRadius.all(Radius.circular(50.0)),
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.grey, offset: Offset(1, 3))
            ],
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset("assets/icons/login_icon/logo_no_background.png"),
      ),
    );
  }

  _buildDefaultImage() {
    return Container(
      height: SizerUtil.deviceType == DeviceType.tablet ? 13.h : 10.h,
      // color: Colors.white,
      margin: EdgeInsets.only(top: 30),
      child: SizedBox(
          height: 10.h,
          width: 10.h,
          child: Image.asset("assets/icons/login_icon/logo_no_background.png")),
    );
  }

  void _userLogout() {
    _mapUser = storage.read('mapUser');
    bool isValue = false;
    // print("_mapUser=${_mapUser}");
    userLogout().then((value) {
      try {
        print("value.status=${value.status}");
        storage.remove('exam_schedule_badge');
        storage.remove('notification_badge');
        storage.remove('assignment_badge');
        if (_mapUser.length > 1) {
          for (dynamic type in _mapUser.keys) {
            if (type == storage.read('isActive')) {
              setState(() {
                _mapUser.remove(type);
                storage.write('mapUser', _mapUser);
                storage.remove('user_token');
                storage.remove('isActive');
                storage.remove('isName');
                storage.remove('isClassId');
                storage.remove('isUserId');
                storage.remove('isGradeLevel');
                storage.remove('isPassword');
                storage.remove('isPhoto');
                isValue = true;
                Get.offAll(() => SwitchAccountPage());
              });
              break;
            }
          }
        }
        // print("_mapUser.length-second time =${_mapUser.length}");
        if (isValue == false) {
          setState(() {
            storage.remove('user_token');
            storage.remove('isActive');
            storage.remove('isName');
            storage.remove('mapUser');
            storage.remove('isPhoto');
            Navigator.of(context).pop();
          });
        }
      } catch (err) {
        Get.defaultDialog(
          title: "Error",
          middleText: "$value",
          barrierDismissible: false,
          confirm: reloadBtn(),
        );
      }
    });
  }

  @override
  void dispose() {
    // print("disposedispose");
    // Navigator.pop(context);
    super.dispose();
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("OK"));
  }

  Widget get _spaceHeight => const SizedBox(height: 10);

// Widget get _spaceWidth => const SizedBox(width: 5);
}
