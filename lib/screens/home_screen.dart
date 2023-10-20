import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:school/models/menu_icon_list.dart';
import 'package:school/repos/exam_schedule.dart';
import 'package:school/repos/home_slide.dart';
import 'package:school/repos/notification_list.dart';
import 'package:school/repos/profile_detail.dart';
import 'package:school/utils/function/function.dart';
import 'package:school/utils/widgets/custom_show_case.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../models/AssignmentListDB.dart';
import '../models/SettingDB.dart';
import '../repos/assignment_list.dart';
import '../repos/login.dart';
import '../repos/update_version.dart';
import '../config/url.dart';
import 'pages/switch_account.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final storage = GetStorage();
  int activeIndex = 0;
  DefaultCacheManager manager = new DefaultCacheManager();
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

  final List<String> _imageIphoneList = ['${baseUrlSchool + 'blank.png'}'],
      _imageIpadList = ['${baseUrlSchool + 'blank.png'}'];
  late Map<String, dynamic> _mapUser;
  late List<Assigned> _recAssignedList = [], _recMissingList = [];
  late List<Slide> _recData = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        menuIconList[4].globalKey,
        menuIconList[5].globalKey,
        menuIconList[6].globalKey,
        // menuIconList[4].globalKey,
        // menuIconList[5].globalKey,
        // menuIconList[6].globalKey,
        // menuIconList[4].globalKey,
        // menuIconList[5].globalKey,
        // menuIconList[6].globalKey,
        // menuIconList[4].globalKey,
        // menuIconList[5].globalKey,
        // menuIconList[6].globalKey,
        // menuIconList[4].globalKey,
        // menuIconList[5].globalKey,
        // menuIconList[6].globalKey,
      ]);
    });
    _fetchHomeSlide();
    WidgetsBinding.instance.addObserver(this);
    _fetchNotificationCount();
    _fetchExamScheduleCount();
    _fetchAssignment();
    _login();
    // scrollController.jumpTo(200);
    if (storage.read('user_token') != null && storage.read('mapUser') != null)
      _fetchProfile().then((value) {
        scrollController.jumpTo(50);
      });
    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: _buildAppBar,
      body: _buildBody,
    );
  }

  get _buildAppBar {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            child: Icon(Icons.menu),
            onTap: () => Scaffold.of(context).openDrawer(),
          ),
          Expanded(
            child: Column(
              children: [
                Image.asset(
                  'assets/icons/home_screen_icon_one_color/ICS_International_School.png',
                  width:
                      SizerUtil.deviceType == DeviceType.tablet ? 16.w : 33.w,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          GestureDetector(
            child: storage.read('notification_badge') != 0 &&
                    storage.read('notification_badge') != null
                ? badges.Badge(
                    badgeContent: Text('${storage.read('notification_badge')}',
                        style: TextStyle(color: Colors.white)),
                    child: Icon(Icons.notifications),
                  )
                : Icon(Icons.notifications),
            onTap: () async {
              tracking("notification");
              if (storage.read('user_token') != null) {
                Get.toNamed('notification');
              } else {
                var data =
                    await Get.toNamed('login', arguments: 'notification');
                if (data == true) {
                  setState(() {
                    _fetchNotificationCount();
                    _fetchExamScheduleCount();
                    _fetchAssignment();
                    _fetchProfile();
                  });
                }
              }
            },
          ),
        ],
      ),
      centerTitle: true,
    );
  }

  get _buildBody {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children: [
          _buildImageSlider,
          _buildGridMenu,
        ],
      ),
    );
  }

  get _buildImageSlider {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 30.h,
          child: CarouselSlider.builder(
              itemCount: _imageIphoneList.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = SizerUtil.deviceType == DeviceType.tablet
                    ? _imageIpadList[index]
                    : _imageIphoneList[index];
                return _buildUrlImages(urlImage);
              },
              options: CarouselOptions(
                  height: SizerUtil.deviceType == DeviceType.tablet
                      ? 130.sp
                      : 180.sp,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }
                  // reverse: true,
                  )),
        ),
        Positioned(
          child: buildIndicator(),
          bottom: 1.h,
        ),
      ],
    );
  }

  _buildUrlImages(urlImage) {
    return CachedNetworkImage(
      width: double.infinity,
      imageUrl: urlImage,
      fit: BoxFit.cover,
      errorWidget: (context, url, error) => SizedBox(),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: _imageIphoneList.length,
        effect: SlideEffect(
            dotColor: Colors.white,
            activeDotColor: Colors.lightBlue,
            dotHeight: 1.h,
            dotWidth: 1.h),
      );

  get _buildGridMenu {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 2.h),
        color: Colors.white,
        child: GridView.builder(
          controller: scrollController,
          itemCount: menuIconList.length,
          itemBuilder: (context, index) {
            return Container(
              // color: Colors.green,
              child: GestureDetector(
                onTap: () async {
                  tracking("${menuIconList[index].title}");
                  if (storage.read('user_token') != null ||
                      menuIconList[index].isAuthorize) {
                    var data = await Get.toNamed(menuIconList[index].route);
                    if (data == 'Assignment') {
                      setState(() {
                        storage.read('assignment_badge');
                      });
                    }
                  } else {
                    var data = await Get.toNamed('login',
                        arguments: menuIconList[index].route);
                    if (data == true) {
                      setState(() {
                        _fetchNotificationCount();
                        _fetchExamScheduleCount();
                        _fetchAssignment();
                        _fetchProfile();
                      });
                    }
                  }
                },
                child: CustomShowCase(
                  title: 'Exam Schedules',
                  key1: menuIconList[index].globalKey,
                  child: Card(
                    elevation: 10,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menuIconList[index].title == 'Exam Schedules' &&
                                (storage.read('exam_schedule_badge') != 0 &&
                                    storage.read('exam_schedule_badge') != null)
                            ? badges.Badge(
                                badgeContent: Text(
                                    '${storage.read('exam_schedule_badge')}',
                                    style: TextStyle(color: Colors.white)),
                                child: Image.asset(menuIconList[index].img,
                                    height: 8.h, width: 8.h),
                              )
                            : menuIconList[index].title == 'Assignments' &&
                                    (storage.read('assignment_badge') != 0 &&
                                        storage.read('assignment_badge') !=
                                            null)
                                ? badges.Badge(
                                    badgeContent: Text(
                                        '${storage.read('assignment_badge')}',
                                        style: TextStyle(color: Colors.white)),
                                    child: Image.asset(menuIconList[index].img,
                                        height: 8.h, width: 8.h),
                                  )
                                : Image.asset(menuIconList[index].img,
                                    height: 8.h, width: 8.h),
                        SizedBox(
                          height: 5.sp,
                        ),
                        Text(
                          menuIconList[index].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 7.sp
                                      : 9.sp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: SizerUtil.deviceType == DeviceType.tablet ? 4 : 3,
              crossAxisSpacing: 1.h,
              mainAxisSpacing: 1.h),
        ),
      ),
    );
  }

  void _fetchNotificationCount() {
    if (storage.read('user_token') == null) return;
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

  void _fetchExamScheduleCount() {
    if (storage.read('user_token') == null) return;

    fetchExamSchedule().then((value) {
      try {
        setState(() {
          // print("value.data.total=${value.data.total}");
          storage.write('exam_schedule_badge', value.data.total);
        });
      } catch (err) {
        print('err=$err');
      }
    });
  }

  Future _fetchProfile() async {
    fetchProfile(apiKey: storage.read('user_token')).then((value) {
      setState(() {
        try {
          if (storage.read('mapUser') == null) {
            _mapUser = {
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

            storage.write('mapUser', _mapUser);
            storage.write('isActive', value.data.data[0].email);
            storage.write('isName', value.data.data[0].name);
            storage.write('isClassId', value.data.data[0].classId);
            storage.write('isUserId', value.data.data[0].id);
            storage.write('isGradeLevel', value.data.data[0].className);
          } else {
            _mapUser = storage.read('mapUser');
            // storage.write('isGradeLevel', value.data.data[0].className);
            for (dynamic type in _mapUser.keys) {
              if (type == storage.read('isActive')) {
                _mapUser[type]['name'] = value.data.data[0].name;
                _mapUser[type]['classId'] = value.data.data[0].classId;
                _mapUser[type]['userId'] = value.data.data[0].id;
                _mapUser[type]['gradeLevel'] = value.data.data[0].className;
                _mapUser[type]['photo'] = value.data.data[0].fullImage;

                storage.write('isActive', type);
                storage.write('isName', value.data.data[0].name);
                storage.write('user_token', _mapUser[type]['token']);
                storage.write('isClassId', value.data.data[0].classId);
                storage.write('isUserId', value.data.data[0].id);
                storage.write('isGradeLevel', value.data.data[0].className);
                storage.write('isPassword', _mapUser[type]['password']);
              }
            }
          }
          if (value.data.data[0].version != storage.read("isVersion"))
            _updateVersion(version: storage.read("isVersion"));
          storage.write('isPhoto', value.data.data[0].fullImage);
        } catch (err) {
          print('Error=$err');
          Get.defaultDialog(
            title: "Error",
            middleText: "$value",
            barrierDismissible: true,
            confirm: reloadBtn(value),
          );
        }
      });
    });
  }

  void _updateVersion({required String version}) {
    print("version=$version");
    updateCurrentVersion(version: version).then((value) {
      setState(() {
        try {
          print("_updateVersion=${value.status}");
        } catch (err) {
          print("err=$err");
        }
      });
    });
  }

  void _fetchAssignment() {
    if (storage.read('user_token') == null) return;

    fetchAssignment().then((value) {
      setState(() {
        try {
          // print("_fetchAssignment");
          _recAssignedList = [];
          _recMissingList = [];
          _recAssignedList.addAll(value.assigned);
          _recMissingList.addAll(value.missing);
          storage.write('assignment_badge',
              _recAssignedList.length + _recMissingList.length);
        } catch (err) {
          print("err=$err");
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    manager.emptyCache();
    switch (state) {
      case AppLifecycleState.resumed:
        if (storage.read('user_token') != null &&
            storage.read('mapUser') != null) {
          print("_fetchNotificationCount");
          _fetchNotificationCount();
          _fetchExamScheduleCount();
          _fetchAssignment();
        }
        if (storage.read('user_token') != null &&
            storage.read('mapUser') != null) _fetchProfile();
        print("app in resumed");
        break;
      case AppLifecycleState.inactive:
        print("app in inactive");
        break;
      case AppLifecycleState.paused:
        print("app in paused");
        break;
      case AppLifecycleState.detached:
        print("app in detached");
        break;
    }
  }

  get _removeUser {
    _mapUser = storage.read('mapUser');
    // print("_mapUser.length=${_mapUser.length}");
    if (_mapUser.length >= 1) {
      for (dynamic type in _mapUser.keys) {
        if (type == storage.read('isActive')) {
          setState(() {
            _mapUser.remove(type);
            storage.write('mapUser', _mapUser);
          });
          break;
        }
      }
    }
    storage.remove('exam_schedule_badge');
    storage.remove('notification_badge');
    storage.remove('user_token');
    storage.remove('isActive');
    storage.remove('isName');
    storage.remove('isClassId');
    storage.remove('isUserId');
    storage.remove('isGradeLevel');
    storage.remove('isPassword');
    storage.remove('user_token');
    storage.remove('isActive');
    storage.remove('assignment_badge');
    storage.remove('isPhoto');
  }

  void _login() {
    if (storage.read('user_token') == null) return;

    userLogin(storage.read('isActive'), storage.read('isPassword'),
            storage.read('device_token'))
        .then((value) {
      try {
        // print(value.status);
        if (value == 'Unauthorized') {
          Get.defaultDialog(
            title: "Login",
            middleText: "Your password was changed on a different device.",
            barrierDismissible: false,
            confirm: reloadBtn('Unauthenticated.'),
          );
        }
      } catch (err) {
        print('Err===$err');
      }
    });
  }

  void _fetchHomeSlide() {
    fetchHomeSlide().then((value) {
      setState(() {
        try {
          // print("value.link1=${value.data[0].link1}");
          _recData.addAll(value.data);
          _imageIphoneList.clear();
          _imageIpadList.clear();
          _recData.forEach((element) {
            _imageIphoneList.add(element.link1);
            _imageIpadList.add(element.link2);
          });
        } catch (err) {
          print("err=$err");
        }
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget reloadBtn(String message) {
    return ElevatedButton(
        onPressed: () {
          if (message == 'Unauthenticated.') {
            _removeUser;
            Get.offAll(() => SwitchAccountPage(),
                arguments: 'Unauthenticated.');
          } else {
            Get.back();
          }
        },
        child: Text("OK"));
  }
}
