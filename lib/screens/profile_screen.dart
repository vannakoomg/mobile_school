import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school/models/ProfileDB.dart';
import 'package:school/repos/login.dart';
import 'package:school/repos/profile_detail.dart';
import 'package:school/screens/pages/switch_account.dart';
import 'package:sizer/sizer.dart';
import '../repos/change_password.dart';
import 'widgets/pdf_viewer_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;
  bool _hide = true,
      _hideOldPWD = true,
      _hideNewPWD = true,
      _hideConfirmPWD = true;
  final picker = ImagePicker();
  final storage = GetStorage();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  late List<Datum> _profile = [];
  bool isLoading = false;
  late bool _isDisableButton;
  late Map<String, dynamic> _mapUser, _mapAllUser;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // print("user_token=${storage.read('user_token')}");
    // print("user_device=${storage.read('device_token')}");
    _isDisableButton = false;
    if (storage.read('user_token') != null) {
      _fetchProfile(apiKey: storage.read('user_token'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storage.read('user_token') != null ? _buildBody : _loginPage,
    );
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );

  get _buildBody {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            _headerImage,
            _switchAccount,
            _studentProfile,
          ],
        ),
      ),
    );
  }

  void _fetchProfile({required String apiKey}) {
    fetchProfile(apiKey: apiKey).then((value) {
      setState(() {
        try {
          print("value.data.list=${value.data.data[0].email}");
          _profile.addAll(value.data.data);
          storage.write('isPhoto', value.data.data[0].fullImage);
          _mapUser = {
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
          if (storage.read('mapUser') == null) {
            storage.write('mapUser', _mapUser);
            storage.write('isActive', value.data.data[0].email);
            storage.write('isName', value.data.data[0].name);
            storage.write('isClassId', value.data.data[0].classId);
            storage.write('isUserId', value.data.data[0].id);
            storage.write('isGradeLevel', value.data.data[0].className);
          }
          //print("_mapUser=${storage.read('mapUser')}");
          // print("_isPassword=${storage.read('isPassword')}");
        } catch (err) {
          print("value=$value");
          Get.defaultDialog(
            title: "Error",
            middleText: "$value",
            barrierDismissible: false,
            confirm: reloadBtn(value),
          );
        }
      });
    });
  }

  get _headerImage {
    if (_profile.isEmpty) {
      isLoading = false;
    } else {
      isLoading = true;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100.w,
          height: SizerUtil.deviceType == DeviceType.tablet ? 35.h : 30.h,
          // color: Colors.grey,
          child: Image.asset(
            'assets/icons/profile_screen_icon/profile_header1.jpeg',
            fit: BoxFit.cover,
            alignment: Alignment.bottomCenter,
          ),
        ),
        Positioned(
          // left:40.w,
          top: 6.h,
          child: Text(
            'Student Information',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        Positioned(
          top: SizerUtil.deviceType == DeviceType.tablet
              ? 35.h / 2.7
              : 30.h / 2.5,
          child: !isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildUrlImages(_profile[0].fullImage),
        ),
      ],
    );
  }

  _buildUrlImages(String urlImage) {
    //DefaultCacheManager().removeFile(urlImage);
    return Container(
      // color: Colors.white,
      child: CachedNetworkImage(
        height: SizerUtil.deviceType == DeviceType.tablet ? 18.h : 15.h,
        width: SizerUtil.deviceType == DeviceType.tablet ? 18.h : 15.h,
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

  // _buildUrlImages(urlImage) {
  //   // DefaultCacheManager().removeFile(urlImage);
  //   return CachedNetworkImage(
  //     width: double.infinity,
  //     imageUrl: urlImage,
  //     fit: BoxFit.cover,
  //     errorWidget: (context, url, error) => Icon(Icons.error),
  //   );
  // }

  get _switchAccount {
    return Container();
  }

  get _studentProfile {
    if (_profile.isEmpty) {
      isLoading = false;
    } else {
      isLoading = true;
    }

    return !isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  border: TableBorder(
                      horizontalInside: BorderSide(
                          width: 1,
                          color: Colors.grey,
                          style: BorderStyle.solid)),
                  columnWidths: {
                    0: FlexColumnWidth(0.5),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(children: [
                      _tableCell('Student ID:', FontWeight.bold, _fontSize),
                      _tableCell(
                          '${_profile[0].email}', FontWeight.normal, _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Full name:', FontWeight.bold, _fontSize),
                      _tableCell(
                          '${_profile[0].name}', FontWeight.normal, _fontSize),
                    ]),
                    // TableRow(children: [
                    //   _tableCell('Gender:', FontWeight.bold, _fontSize),
                    //   _tableCell('', FontWeight.normal, _fontSize),
                    // ]),
                    TableRow(children: [
                      _tableCell('Class:', FontWeight.bold, _fontSize),
                      _tableCell('${_profile[0].className}', FontWeight.normal,
                          _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Phone Number:', FontWeight.bold, _fontSize),
                      _tableCell(
                          '${_profile[0].phone}', FontWeight.normal, _fontSize),
                    ]),
                    TableRow(children: [
                      _tableCell('Password:', FontWeight.bold, _fontSize),
                      InkWell(
                        onTap: () => _showChangePasswordActionSheet,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 8.sp),
                              alignment: Alignment.centerLeft,
                              height: 6.h,
                              child: Text(
                                '**************',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Container(
                              child: Icon(Icons.arrow_forward_sharp),
                              padding: EdgeInsets.only(top: 8.sp, right: 8.sp),
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Container(
                height: 1,
                width: 100.w,
                color: Colors.grey,
                margin: EdgeInsets.only(left: 8, right: 8),
              ),
            ],
          );
  }

  // get _catchImageNetwork {
  //   return CachedNetworkImage(
  //     imageUrl:
  //         "1https://img.freepik.com/free-vector/large-school-building-scene_1308-32058.jpg?size=626&ext=jpg&ga=GA1.2.2039525430.1630022400",
  //     imageBuilder: (context, imageProvider) => Container(
  //       width: SizerUtil.deviceType == DeviceType.tablet ? 18.h : 15.h,
  //       height: SizerUtil.deviceType == DeviceType.tablet ? 18.h : 15.h,
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.white, width: 2),
  //         borderRadius: BorderRadius.all(Radius.circular(50.h)),
  //         image: DecorationImage(
  //           image: imageProvider,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     ),
  //     placeholder: (context, url) => CircularProgressIndicator(),
  //     errorWidget: (context, url, error) => Container(
  //       width: SizerUtil.deviceType == DeviceType.tablet ? 18.h : 15.h,
  //       height: SizerUtil.deviceType == DeviceType.tablet ? 18.h : 15.h,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         border: Border.all(color: Colors.white, width: 2),
  //         shape: BoxShape.circle,
  //         image: DecorationImage(
  //             image: AssetImage(
  //                 'assets/icons/login_icon/logo_no_background.png')),
  //       ),
  //     ),
  //   );
  // }

  Widget _tableCell(String exam, FontWeight fontWeight, double fontSize) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 6.h,
      child: Text(
        exam,
        style: TextStyle(
            fontWeight: fontWeight, fontSize: fontSize, color: Colors.black),
      ),
    );
  }

  get _loginPage {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
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
                  ],
                ),
              ),
              Container(
                child: Text(
                  'USER LOGIN',
                  style: TextStyle(
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 14.sp
                          : 18.sp,
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
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
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
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
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
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(0)),
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
                    height:
                        SizerUtil.deviceType == DeviceType.tablet ? 60.0 : 50.0,
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
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 18
                              : 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
        EasyLoading.showSuccess('Logged in successfully!');
        EasyLoading.dismiss();
        setState(() {
          //storage.write('isUsername', emailController.text.trim());
          storage.write('isPassword', passwordController.text.trim());
          storage.write('user_token', value.data.token);
          _fetchProfile(apiKey: value.data.token);
          isLoading = true;
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
          confirm: reloadBtn(value),
        );
      }
    });
  }

  void _changePassword() {
    EasyLoading.show(status: 'Loading');
    userChangePassword(currentPasswordController.text.trim(),
            newPasswordController.text.trim())
        .then((value) {
      try {
        print('Success=${value.status}');

        if (value.status) {
          setState(() {
            _mapUser[storage.read('isActive')]['password'] =
                newPasswordController.text.trim();
            _mapAllUser = storage.read('mapUser');
            for (dynamic type in _mapAllUser.keys) {
              if (type == storage.read('isActive')) {
                _mapAllUser.remove(type);
                _mapAllUser.addAll(_mapUser);
                storage.write('mapUser', _mapAllUser);
                storage.write('isPassword', newPasswordController.text.trim());
                break;
              }
            }
            currentPasswordController.clear();
            newPasswordController.clear();
            confirmPasswordController.clear();
            Get.back();
            EasyLoading.showSuccess('Password Changed!');
            EasyLoading.dismiss();
            isLoading = true;
            _isDisableButton = false;
          });
        } else {
          EasyLoading.dismiss();
        }
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
          confirm: reloadBtn(value),
        );
      }
    });
  }

  get _showChangePasswordActionSheet {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      child: StatefulBuilder(builder: (BuildContext context,
          StateSetter setState /*You can rename this!*/) {
        return Form(
          key: formKey,
          child: Wrap(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextFormField(
                  controller: currentPasswordController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.trim() != storage.read('isPassword'))
                      return 'Password is incorrect';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Current password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideOldPWD ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideOldPWD = !_hideOldPWD;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                  obscureText: _hideOldPWD,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextFormField(
                  controller: newPasswordController,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().length <= 5)
                      return 'Password must be at least 6 characters';
                    else if (value.trim() == currentPasswordController.text)
                      return "New password cannot be the same as current password";
                    else if (value.trim() != confirmPasswordController.text)
                      return 'New password and confirm new password do not match';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: "New password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideNewPWD ? Icons.visibility : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideNewPWD = !_hideNewPWD;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                  obscureText: _hideNewPWD,
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40),
                child: TextFormField(
                  // onSubmitted: (value) {
                  //   FocusScope.of(context).requestFocus(FocusNode());
                  // },
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value!.isEmpty || value.trim().length <= 5)
                      return 'Password must be at least 6 characters';
                    else
                      return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Confirm new password",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideConfirmPWD
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _hideConfirmPWD = !_hideConfirmPWD;
                        });
                      },
                    ),
                  ),
                  style: TextStyle(
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14,
                      color: Color(0xff1a0785)),
                  obscureText: _hideConfirmPWD,
                ),
              ),
              SizedBox(height: 3.h),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(
                    horizontal:
                        SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 40,
                    vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      print("Validation");
                      if (_isDisableButton == false) {
                        setState(() {
                          _isDisableButton = true;
                        });
                        _changePassword();
                      }
                    }
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(0)),
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
                    height:
                        SizerUtil.deviceType == DeviceType.tablet ? 60.0 : 50.0,
                    width: 60.w,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: new LinearGradient(
                          colors: [Color(0xff1a237e), Colors.lightBlueAccent],
                        )),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "CHANGE PASSWORD",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 18
                              : 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    ));
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
    // print("_mapUser.length=${_mapUser.length}");
  }
}
