import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/repos/login.dart';
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
            child: ElevatedButton(
              onPressed: () {
                if (_isDisableButton == false) {
                  setState(() {
                    _isDisableButton = true;
                  });
                  _login();
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  // side: BorderSide(color: Colors.red)
                )),
              ),
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15.0)),
              // textColor: Colors.white,
              // padding: const EdgeInsets.all(0),
              child: Container(
                alignment: Alignment.center,
                height: SizerUtil.deviceType == DeviceType.tablet ? 60.0 : 50.0,
                width: 100.w,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: new LinearGradient(
                      colors: [Color(0xff1a237e), Colors.lightBlueAccent],
                    )),
                padding: const EdgeInsets.all(0),
                child: Text(
                  "LOGIN",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() {
    EasyLoading.show(status: 'Loading');
    debugPrint(
        "data 01 : ${emailController.text.trim()} , ${passwordController.text.trim()} , ${storage.read('device_token')}");
    userLogin(emailController.text.trim(), passwordController.text.trim(),
            storage.read('device_token'))
        .then((value) {
      try {
        setState(() {
          print('Success=${value.status}');
          storage.write('user_token', value.data.token);
          debugPrint("token ${value.data.token}");
          storage.write('isActive', value.data.studentId);

          // storage.write('isUsername', emailController.text.trim());
          storage.write('isPassword', passwordController.text.trim());
          EasyLoading.showSuccess('Logged in successfully!');
          EasyLoading.dismiss();
          // Navigator.pop(context);

          Get.back(result: true);
          if (_route == 'no route' || _route == 'pick_up_card') {
            // print("no route");
          } else if (_route == 'dashboard') {
            Get.offAllNamed(_route!);
          } else {
            Get.toNamed(_route!);
          }
        });
      } catch (err) {
        EasyLoading.dismiss();
        setState(() {
          _isDisableButton = false;
        });
        value =
            value == 'Unauthorized' ? 'Username/Password is incorrect!' : value;
        Get.defaultDialog(
          title: "Error",
          middleText: "$value",
          barrierDismissible: false,
          confirm: reloadBtn(),
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

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("OK"));
  }
}
