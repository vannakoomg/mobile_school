import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/repos/login.dart';
import 'package:school/repos/profile_detail.dart';
import 'package:school/utils/function/function.dart';
import 'package:school/utils/widgets/custom_botton_auth.dart';
import 'package:school/utils/widgets/custom_dialog.dart';
import 'package:sizer/sizer.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final storage = GetStorage();
  late String? _route;
  bool _hide = true;
  late bool _isDisableButton;

  @override
  void initState() {
    _route = Get.arguments.toString();
    print("_route=$_route");
    _isDisableButton = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: _buildBody,
      ),
    );
  }

  get _buildBody {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset(
                    SizerUtil.deviceType == DeviceType.tablet
                        ? "assets/icons/login_icon/iPad.png"
                        : "assets/icons/login_icon/iPhone.png",
                    width: double.infinity,
                    fit: BoxFit.cover),
                Positioned(
                  child: Container(
                    height: 50.h,
                    alignment: Alignment.center,
                    // color: Colors.red,
                    child: Image.asset(
                        "assets/icons/home_screen_icon_one_color/ICS_International_School.png",
                        width: SizerUtil.deviceType == DeviceType.tablet
                            ? 45.w
                            : 60.w,
                        color: Colors.white),
                  ),
                ),
                Positioned(
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 40),
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      child: Icon(
                        Icons.arrow_back_rounded,
                        size: 35,
                        color: Colors.white,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            child: Text(
              'USER LOGIN',
              style: TextStyle(
                  fontSize:
                      SizerUtil.deviceType == DeviceType.tablet ? 14.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff1a0785)),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                horizontal:
                    SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
            child: TextField(
              autocorrect: false,
              textInputAction: TextInputAction.next,
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Username", prefixIcon: Icon(Icons.person)),
              style: TextStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                  color: Color(0xff1a0785)),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(
                horizontal:
                    SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
            child: TextField(
              onSubmitted: (value) {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hide ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    setState(() {
                      _hide = !_hide;
                    });
                  },
                ),
              ),
              style: TextStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                  color: Color(0xff1a0785)),
              obscureText: _hide,
            ),
          ),
          SizedBox(height: 3.h),
          Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(
                  horizontal:
                      SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40,
                  vertical: 10),
              child: CustomBottonAuth(
                ontap: () {
                  if (_isDisableButton == false) {
                    setState(() {
                      _isDisableButton = true;
                    });
                    _login();
                  }
                },
                title: "LOGIN",
              )),
        ],
      ),
    );
  }

  void _login() {
    EasyLoading.show(status: 'Loading');
    userLogin(emailController.text.trim(), passwordController.text.trim(),
            storage.read('device_token'))
        .then((value) {
      try {
        setState(() {
          storage.write('user_token', value.data.token);
          storage.write('isActive', value.data.studentId);
          fetchProfile(apiKey: '${value.data.token}')
              .then((value) => {
                    storage.write('campus', value.data.data[0].campus),
                  })
              .then((value) => {
                    tracking(
                      menuName: _route ?? "",
                      campus: storage.read("campus") ?? '',
                      userName: storage.read('isActive') ?? '',
                    )
                  });
          storage.write('isPassword', passwordController.text.trim());
          EasyLoading.showSuccess('Logged in successfully!');
          EasyLoading.dismiss();
          Get.back(result: true);
          if (_route == 'no route' || _route == 'pick_up_card') {
          } else if (_route == 'dashboard') {
            Get.offAllNamed(_route!);
          } else {
            Get.toNamed(_route!);
          }
          debugPrint("route $_route");
        });
      } catch (err) {
        EasyLoading.dismiss();
        setState(() {
          _isDisableButton = false;
        });
        value =
            value == 'Unauthorized' ? 'Username/Password is incorrect!' : value;
        CustomDialog.error(
          title: "Error",
          message: value,
          context: context,
        );
      }
    });
  }

  // Future<void> _displayTextInputDialog(BuildContext context) async {
  //   return showDialog(
  //     barrierDismissible: false,
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Passcode'),
  //         content: TextField(
  //           controller: _passcodeController,
  //           decoration: InputDecoration(hintText: "Enter your passcode"),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('CANCEL'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           FlatButton(
  //             child: Text('SUBMIT', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),),
  //             onPressed: () {
  //               // print(_passcodeController.text);
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
