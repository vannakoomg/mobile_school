import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/repos/login.dart';
import 'package:school/repos/profile_detail.dart';
import 'package:sizer/sizer.dart';

class AddAccountPage extends StatefulWidget {
  @override
  _AddAccountPageState createState() => _AddAccountPageState();
}

class _AddAccountPageState extends State<AddAccountPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final _passcodeController = TextEditingController();
  final storage = GetStorage();
  bool _hide = true;
  late bool _isDisableButton;
  late Map<String, dynamic> _mapUser;

  @override
  void initState() {
    _mapUser = storage.read('mapUser');
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
              // cursorColor: Colors.red,
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
          // SizedBox(height: 3.h),
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
                for (dynamic type in _mapUser.keys) {
                  if (emailController.text.toUpperCase().trim() == type) {
                    Get.defaultDialog(
                      title: "",
                      middleText: "User already logged in!",
                      barrierDismissible: false,
                      confirm: reloadBtn(),
                    );
                    return;
                  }
                }
                // _displayTextInputDialog(context);
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
    userLogin(emailController.text.trim(), passwordController.text.trim(),
            storage.read('device_token'))
        .then((value) {
      try {
        print('Success=${value.status}');
        storage.write('isPassword', passwordController.text.trim());
        _fetchProfile(apiKey: value.data.token);
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

  void _fetchProfile({required String apiKey}) {
    fetchProfile(apiKey: apiKey).then((value) {
      setState(() {
        try {
          print("value.data.list=${value.data.data}");
          storage.write('isPhoto', value.data.data[0].fullImage);
          var user = {
            "${value.data.data[0].email}": {
              "name": "${value.data.data[0].name}",
              "token": "$apiKey",
              "classId": "${value.data.data[0].classId}",
              "userId": "${value.data.data[0].id}",
              "gradeLevel": "${value.data.data[0].className}",
              "password": "${storage.read('isPassword')}",
              "photo": "${value.data.data[0].fullImage}",
            },
          };

          Get.back(result: user);
          EasyLoading.showSuccess('Logged in successfully!');
          EasyLoading.dismiss();
        } catch (err) {
          Get.defaultDialog(
            title: "Error",
            middleText: "$value",
            barrierDismissible: false,
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
        },
        child: Text("OK"));
  }
}
