import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:school/models/menu_icon_list.dart';
import 'package:school/modules/profile/controllers/profile_controller.dart';
import 'package:school/repos/exam_schedule.dart';
import 'package:school/repos/home_slide.dart';
import 'package:school/repos/notification_list.dart';
import 'package:school/repos/profile_detail.dart';
import 'package:school/utils/function/function.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sizer/sizer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../config/app_colors.dart';
import '../models/AssignmentListDB.dart';
import '../models/SettingDB.dart';
import '../modules/profile/screens/profile_screen.dart';
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
  final controller = Get.put(ProfileController());
  final storage = GetStorage();
  int activeIndex = 0;
  DefaultCacheManager manager = new DefaultCacheManager();
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();

  final List<String> _imageIphoneList = ['${baseUrlSchool + 'blank.png'}'],
      _imageIpadList = ['${baseUrlSchool + 'blank.png'}'];
  late Map<String, dynamic> _mapUser;
  late List<Assigned> _recAssignedList = [], _recMissingList = [];
  late List<Slide> _recData = [];

  @override
  void initState() {
    super.initState();
    _fetchHomeSlide();
    WidgetsBinding.instance.addObserver(this);
    _fetchNotificationCount();
    _fetchExamScheduleCount();
    _fetchAssignment();
    _login();

    if (storage.read('user_token') != null && storage.read('mapUser') != null)
      _fetchProfile();
    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: Colors.grey.shade300,
          key: key,
          body: _buildBody,
        ));
  }

  get _buildBody {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: 10.h,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (storage.read('user_token') == null) {
                          // Get.toNamed('login', arguments: 'home_screen');
                        } else {
                          tracking("profile");
                          controller.isShowProfile.value = true;
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Row(children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            height: 7.h,
                            width: 7.h,
                            child: Center(
                              child: Container(
                                height: 7.h - 5,
                                width: 7.h - 5,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColor.primaryColor,
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            "${storage.read('isPhoto')}"))),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "${controller.helloFromIcs()}  ${storage.read('isName') ?? ''}",
                            style: TextStyle(
                              color: AppColor.primaryColor.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 10.sp
                                      : 13.sp,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    _buildGridMenu,
                    _buildImageSlider,
                    SizedBox(
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 11.h,
            color: AppColor.primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  width: 20,
                ),
                Image.asset(
                  'assets/icons/home_screen_icon_one_color/ICS_International_School.png',
                  width:
                      SizerUtil.deviceType == DeviceType.tablet ? 16.w : 33.w,
                  color: Colors.white,
                ),
                Spacer(),
                GestureDetector(
                  child: storage.read('notification_badge') != 0 &&
                          storage.read('notification_badge') != null
                      ? badges.Badge(
                          badgeContent: Text(
                              '${storage.read('notification_badge')}',
                              style: TextStyle(color: Colors.white)),
                          child: Icon(Icons.notifications),
                        )
                      : Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
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
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          AnimatedPositioned(
              top: controller.isShowProfile.value == false ? 100.h : 0.h,
              left: 0,
              curve: Curves.easeOutCirc,
              duration: Duration(milliseconds: 300),
              child: AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                  opacity: controller.isShowProfile.value == false ? 0 : 1,
                  child: ProfileScreen(
                    id: '${storage.read('isActive')}',
                    profile: '${storage.read('isPhoto')}',
                    studentName: '${storage.read('isName')}',
                  )))
        ],
      ),
    );
  }

  get _buildImageSlider {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: CarouselSlider.builder(
              itemCount: _imageIphoneList.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = SizerUtil.deviceType == DeviceType.tablet
                    ? _imageIpadList[index]
                    : _imageIphoneList[index];
                return _buildUrlImages(urlImage);
              },
              options: CarouselOptions(
                  aspectRatio: 10 / 9,
                  height: SizerUtil.deviceType == DeviceType.tablet
                      ? 120.sp
                      : 170.sp,
                  viewportFraction: 1,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  })),
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
    return Column(
      children: [
        Container(
            margin: EdgeInsets.only(top: 0, right: 5, left: 5),
            child: Wrap(
              children: menuIconList.asMap().entries.map((e) {
                return GestureDetector(
                  onTap: () async {
                    debugPrint("route : ${menuIconList[e.key].route}");
                    tracking("${menuIconList[e.key].title}");
                    if (storage.read('user_token') != null ||
                        menuIconList[e.key].isAuthorize) {
                      var data = await Get.toNamed(menuIconList[e.key].route);
                      if (data == 'Assignment') {
                        setState(() {
                          storage.read('assignment_badge');
                        });
                      }
                    } else {
                      var data = await Get.toNamed('login',
                          arguments: menuIconList[e.key].route);
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
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3 - 15,
                    height: MediaQuery.of(context).size.width / 3 -
                        15 +
                        (MediaQuery.of(context).size.width / 3 - 15) / 10,
                    margin: EdgeInsets.only(left: 5, right: 5, top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        menuIconList[e.key].title == 'Exam Schedules' &&
                                (storage.read('exam_schedule_badge') != 0 &&
                                    storage.read('exam_schedule_badge') != null)
                            ? badges.Badge(
                                badgeContent: Text(
                                    '${storage.read('exam_schedule_badge')}',
                                    style: TextStyle(color: Colors.white)),
                                child: Image.asset(menuIconList[e.key].img,
                                    height: 8.h, width: 8.h),
                              )
                            : menuIconList[e.key].title == 'Assignments' &&
                                    (storage.read('assignment_badge') != 0 &&
                                        storage.read('assignment_badge') !=
                                            null)
                                ? badges.Badge(
                                    badgeContent: Text(
                                        '${storage.read('assignment_badge')}',
                                        style: TextStyle(color: Colors.white)),
                                    child: Image.asset(menuIconList[e.key].img,
                                        height: 8.h, width: 8.h),
                                  )
                                : Image.asset(menuIconList[e.key].img,
                                    height: 6.5.h, width: 6.5.h),
                        SizedBox(
                          height: 5.sp,
                        ),
                        Text(
                          menuIconList[e.key].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 8.sp
                                      : 10.sp),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            )),
        Container(
          margin: EdgeInsets.only(left: 10, right: 10, top: 10),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: menuSubIconList.asMap().entries.map(
              (e) {
                return GestureDetector(
                  onTap: () async {
                    debugPrint("route : ${menuIconList[e.key].route}");
                    tracking("${menuIconList[e.key].title}");
                    if (storage.read('user_token') != null ||
                        menuSubIconList[e.key].isAuthorize) {
                      var data =
                          await Get.toNamed(menuSubIconList[e.key].route);
                      if (data == 'Assignment') {
                        setState(() {
                          storage.read('assignment_badge');
                        });
                      }
                    } else {
                      var data = await Get.toNamed('login',
                          arguments: menuSubIconList[e.key].route);
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
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                    margin: EdgeInsets.only(right: 5),
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                        child: Row(
                      children: [
                        Image.asset(
                          "${menuSubIconList[e.key].img}",
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${menuSubIconList[e.key].title}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 8.sp
                                      : 10.sp),
                        ),
                      ],
                    )),
                  ),
                );
              },
            ).toList()),
          ),
        )
      ],
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
          storage.write('exam_schedule_badge', value.data.total);
        });
      } catch (err) {
        print('err=$err');
      }
    });
  }

  void _fetchProfile() {
    fetchProfile(apiKey: storage.read('user_token')).then((value) {
      debugPrint(
          "khmer sl khmer ${value.data.data[0].fullImage} ${value.data.data[0].name} ${value.data.data[0].email}");
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
            storage.write('isPhoto', value.data.data[0].fullImage);
          } else {
            _mapUser = storage.read('mapUser');
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
                storage.write('isPhoto', value.data.data[0].fullImage);
              }
            }
          }
          if (value.data.data[0].version != storage.read("isVersion"))
            _updateVersion(version: storage.read("isVersion"));
          storage.write('isPhoto', value.data.data[0].fullImage);
        } catch (err) {
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
