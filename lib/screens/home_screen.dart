import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/models/menu_icon_list.dart';
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
  final List<String> _imageIphoneList = ['${baseUrlSchool + 'blank.png'}'],
      _imageIpadList = ['${baseUrlSchool + 'blank.png'}'];
  late Map<String, dynamic> _mapUser;
  late List<Assigned> _recAssignedList = [], _recMissingList = [];
  late List<Slide> _recData = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    debugPrint("user token ${storage.read('user_token')}");
    _fetchHomeSlide();
    WidgetsBinding.instance.addObserver(this);
    _fetchNotificationCount();
    _fetchExamScheduleCount();
    _fetchAssignment();
    _login();
    if (storage.read('user_token') != null && storage.read('mapUser') != null)
      _fetchProfile().then((value) {
        // scrollController.jumpTo(50);
      });
    manager.emptyCache();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
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
              tracking(
                menuName: "notification",
                campus: storage.read("campus") ?? '',
                userName: storage.read('isActive') ?? '',
              );
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
      margin: EdgeInsets.only(
          // top: 1.5.h,
          ),
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
        CarouselSlider.builder(
          itemCount: _imageIphoneList.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = SizerUtil.deviceType == DeviceType.tablet
                ? _imageIpadList[index]
                : _imageIphoneList[index];
            return _buildUrlImages(urlImage);
          },
          options: CarouselOptions(
              height:
                  SizerUtil.deviceType == DeviceType.tablet ? 130.sp : 180.sp,
              viewportFraction: 1,
              autoPlay: true,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              }
              // onPageChanged: (index, reason) {
              //   setState(() {
              //     activeIndex = index;
              //   });
              // },
              // height: MediaQuery.sizeOf(context).width / 2.3,
              // enlargeCenterPage: true,
              // autoPlay: true,
              // aspectRatio: 16 / 9.8,
              // autoPlayCurve: Curves.fastOutSlowIn,
              // enableInfiniteScroll: true,
              // autoPlayAnimationDuration: Duration(milliseconds: 800),
              // viewportFraction: 0.8,
              ),
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
      imageUrl: urlImage,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          // borderRadius:
          //     BorderRadius.circular(20.0), // Set your desired border radius
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      errorWidget: (context, url, error) => SizedBox(),
    );
  }

  Widget buildIndicator() => Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.black.withOpacity(0.3)),
        child: AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: _imageIphoneList.length,
          effect: SlideEffect(
              spacing: 5,
              dotColor: const Color.fromARGB(255, 194, 194, 194),
              activeDotColor: Colors.white,
              dotHeight: 0.7.h,
              dotWidth: 0.7.h),
        ),
      );

  get _buildGridMenu {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 2.h,
          right: 2.h,
          top: 1.5.h,
        ),
        child: GridView.builder(
          itemCount: menuIconList.length,
          itemBuilder: (context, index) {
            return Container(
              child: GestureDetector(
                onTap: () async {
                  tracking(
                    menuName: "${menuIconList[index].route}",
                    campus: storage.read("campus") ?? '',
                    userName: storage.read('isActive') ?? '',
                  );
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
                child: Container(
                  margin: EdgeInsets.only(
                      // top: 1.2.h,
                      ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      menuIconList[index].title == 'Exam Schedule' &&
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
                                      storage.read('assignment_badge') != null)
                              ? badges.Badge(
                                  badgeContent: Text(
                                      '${storage.read('assignment_badge')}',
                                      style: TextStyle(color: Colors.white)),
                                  child: Image.asset(menuIconList[index].img,
                                      height: 7.h, width: 7.h),
                                )
                              : Image.asset(menuIconList[index].img,
                                  height: 7.h, width: 7.h),
                      SizedBox(
                        height: 5.sp,
                      ),
                      Text(
                        menuIconList[index].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 7.sp
                                : 10.sp),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SizerUtil.deviceType == DeviceType.tablet ? 4 : 3,
            crossAxisSpacing: 1.2.h,
            mainAxisSpacing: 1.2.h,
          ),
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
                "campus": "${value.data.data[0].campus}",
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
      case AppLifecycleState.hidden:
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

  Widget reloadBtn(String message) {
    return ElevatedButton(
      onPressed: () {
        if (message == 'Unauthenticated.') {
          _removeUser;
          Get.offAll(() => SwitchAccountPage(), arguments: 'Unauthenticated.');
        } else {
          Get.back();
        }
      },
      child: Text("OK"),
    );
  }
}
