import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/config/route.dart';
import 'package:school/modules/announcement/screens/announcement_detail_screen.dart';
import 'package:school/modules/canteen/screen/canteen_screen.dart';
import 'package:school/repos/notification_list.dart';
import 'package:school/repos/register_device_token.dart';
import 'package:school/screens/pages/feedback_detail.dart';
import 'package:school/screens/pages/homework_detail.dart';
import 'package:school/screens/pages/iwallet.dart';
import 'package:school/screens/pages/notification_detail.dart';
import 'package:showcaseview/showcaseview.dart';
import 'models/AssignmentListDB.dart';
import 'repos/assignment_list.dart';
import 'screens/dashboard_screen.dart';
import 'screens/pages/switch_account.dart';
import 'screens/widgets/local_notications_helper.dart';
import 'models/push_notification.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:device_info/device_info.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final FirebaseMessaging _messaging;
  late String _notificationRoute;
  late String _notificationId;
  late String? _notificationUserId;
  PushNotification? _notificationInfo;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // DashboardScreen _dashboardScreen = DashboardScreen();
  SwitchAccountPage _switchAccountPage = SwitchAccountPage();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final storage = GetStorage();
  late List<Assigned> _recAssignedList = [], _recMissingList = [];

  Map<int, Color> color = {
    50: Color.fromRGBO(51, 153, 255, .1),
    100: Color.fromRGBO(51, 153, 255, .2),
    200: Color.fromRGBO(51, 153, 255, .3),
    300: Color.fromRGBO(51, 153, 255, .4),
    400: Color.fromRGBO(51, 153, 255, .5),
    500: Color.fromRGBO(51, 153, 255, .6),
    600: Color.fromRGBO(51, 153, 255, .7),
    700: Color.fromRGBO(51, 153, 255, .8),
    800: Color.fromRGBO(51, 153, 255, .9),
    900: Color.fromRGBO(51, 153, 255, 1),
  };

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          useMaterial3: false,
          appBarTheme: Theme.of(context).appBarTheme,
          primarySwatch: MaterialColor(0xff1d1a56, color),
        ),
        home: storage.read('user_token') == null &&
                (storage.read('mapUser') != null &&
                    storage.read('mapUser').length != 0)
            ? _switchAccountPage
            : ShowCaseWidget(
                builder: Builder(
                  builder: (context) => DashboardScreen(),
                ),
              ),
        routes: route02,
        builder: EasyLoading.init(),
      );
    });
  }

  //For handling notification when the app is in force ground
  void registerNotification() async {
    await Firebase.initializeApp();
    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    String? token = await FirebaseMessaging.instance.getToken();
    print("token= $token");
    print("SizerUtil.deviceType=${SizerUtil.deviceType.obs}");
    storage.write('device_token', token);

    fetchRegisterDeviceToken(
            token!,
            _deviceData['id'] ?? _deviceData['utsname.machine:'],
            _deviceData['brand'] ?? _deviceData['systemName'])
        .then((value) {
      try {
        print('Success=${value.status}');
      } catch (err) {
        print("err=$err");
      }
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (message.notification!.title == "Top up Notification") {
          debugPrint("fetch new blance ");
        }
        print(
            'Message ======> title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
        // Parse the message received
        if (message.data['route'] != null) {
          _notificationRoute = message.data['route'];
          _notificationId = message.data['id'];
          _notificationUserId = message.data['user_id'];
        }
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );
        setState(() {
          print("notification=$notification");
          _notificationInfo = notification;
        });

        if (_notificationInfo != null) {
          _fetchNotificationCount();
          _fetchAssignment();
          print("For displaying the notification as an overlay");
          showOngoingNotification(flutterLocalNotificationsPlugin,
              title: _notificationInfo!.title!, body: _notificationInfo!.body!);
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }

    final settingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload!));

    flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(android: settingsAndroid, iOS: settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String? payload) async {
    _routes(
        route: _notificationRoute,
        page: _notificationId,
        userId: _notificationUserId);
  }

  //For handling notification when the app is in terminated
  checkForInitialMessage() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await FirebaseMessaging.instance.getInitialMessage().then((message) {
      debugPrint("ontap notification 03");

      if (message != null)
        _routes(
            route: message.data['route'],
            page: message.data['id'],
            userId: message.data['user_id']);
    });
  }

  @override
  void initState() {
    var mapUserLength = storage.read('mapUser');
    // print('test=${mapUserLength.toString()}');
    if (mapUserLength == 0) storage.remove('mapUser');

    //print("storage.read('mapUser')=${storage.read('mapUser')}");
    //For handling notification when the app is in force ground
    registerNotification();
    //For handling notification when the app is in background but not terminated
    checkForInitialMessage();
    // For handling notification when the app is in background but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("ontap notification 02");
      if (message.data['route'] != null) {
        _routes(
            route: message.data['route'],
            page: message.data['id'],
            userId: message.data['user_id']);
      }
    });
    initPlatformState();
    super.initState();
  }

  Future<void> _routes(
      {required String route, String? page, String? userId}) async {
    if (route == "Menu Today Is Coming") {
      Get.to(CanteenScreen());
    } else {
      if (route == 'ICS News') {
        Get.to(() => AnnouncementHtml(item: page!));
      } else if (userId != storage.read('isUserId').toString()) {
        Get.offAllNamed('dashboard');
      } else if (route == 'Fingerprint Notification') {
        Get.toNamed('attendance_calendar');
      } else if (route == 'ICS Feedback') {
        Get.to(() => FeedbackDetail(item: page!));
      } else if (route == 'Assignment') {
        var data = await Get.to(() => HomeworkDetailPage(
              assignmentId: int.parse(page!),
            ));
        if (data == null) _fetchAssignment();
      } else if (route == 'Order Notification') {
        Get.to(() => IWallet(index: 1));
      } else if (route == 'Top up Notification') {
        Get.toNamed('i_wallet');
      } else if (route == 'Menu Today Is Coming') {
        debugPrint("Menu Today Is Coming 333333333");
      } else {
        var data = await Get.to(() => NotificationsDetail(
              item: page!,
            ));
        if (data == null) _fetchNotificationCount();
      }
    }
  }

  Future<void> initPlatformState() async {
    Map<String, dynamic> deviceData = <String, dynamic>{};
    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'brand': build.brand,
      'device': build.device,
      'id': build.id,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'utsname.machine:': data.utsname.machine,
    };
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
}
