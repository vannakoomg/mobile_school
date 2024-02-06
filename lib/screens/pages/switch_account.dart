import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/screens/pages/add_account.dart';
import 'package:school/config/theme/theme.dart';
import 'package:sizer/sizer.dart';

class SwitchAccountPage extends StatefulWidget {
  const SwitchAccountPage({Key? key}) : super(key: key);

  @override
  _SwitchAccountPageState createState() => _SwitchAccountPageState();
}

class _SwitchAccountPageState extends State<SwitchAccountPage> {
  late final PhoneSize phoneSize;
  final storage = GetStorage();
  late Map<String, dynamic> _mapUser;
  List<String> studentId = [];
  List<String> studentName = [];
  List<String> studentPhoto = [];
  bool unauthenticated = false;

  @override
  void initState() {
    super.initState();
    _mapUser = storage.read('mapUser');
    for (dynamic type in _mapUser.keys) {
      studentId.add(type);
      studentName.add(_mapUser[type]['name']);
      studentPhoto.add(_mapUser[type]['photo'] ?? '');
    }
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    if (Get.arguments.toString() == 'Unauthenticated.') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unauthenticated = true;
        addNewUser();
      });

      // Future.delayed(Duration(seconds: 0), (){
      //   addNewUser();
      // });
    }
    // print("hello");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Switch Account')),
      body: _buildBody,
    );
  }

  get _buildBody {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(10),
              itemCount: _mapUser.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildItem(index);
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: InkWell(
            onTap: () => addNewUser(),
            child: Card(
                elevation: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(8),
                  height: 8.h,
                  width: 100.w,
                  child: Row(
                    children: [
                      SizedBox(
                        child: Icon(Icons.library_add_outlined),
                        width: 5.h,
                        height: 5.h,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Add account', style: myTextStyleHeader[phoneSize]),
                    ],
                  ),
                  // color: Colors.red,
                )),
          ),
        ),
      ],
    );
  }

  Future<void> addNewUser() async {
    var data = await Get.to(() => AddAccountPage());
    //print("data=$data");
    if (data != null) {
      setState(() {
        _mapUser.addAll(data);
        storage.write('mapUser', _mapUser);
        for (dynamic type in data.keys) {
          studentId.add(type);
          studentName.add(_mapUser[type]['name']);
          studentPhoto.add(_mapUser[type]['photo']);
          storage.write('isActive', type);
          storage.write('isName', _mapUser[type]['name']);
          storage.write('user_token', _mapUser[type]['token']);
          storage.write('isClassId', _mapUser[type]['classId']);
          storage.write('isUserId', _mapUser[type]['userId']);
          storage.write('isGradeLevel', _mapUser[type]['gradeLevel']);
          storage.write('isPassword', _mapUser[type]['password']);
        }
      });
    }
    // print("storage.read('mapUser').lenth=${storage.read('mapUser').length}");
    if (storage.read('mapUser').length == 0) {
      storage.remove('mapUser');
      Get.offAllNamed('dashboard');
    } else if (unauthenticated && data != null) {
      print('_mapUser[0].keys=${_mapUser.keys.first}');
      Get.offAllNamed('dashboard');
      // for (dynamic type in _mapUser[0].keys) {
      //   setState(() {
      //     storage.remove('isPhoto');
      //     storage.write('isActive', type);
      //     storage.write('isName', _mapUser[type]['name']);
      //     storage.write('user_token', _mapUser[type]['token']);
      //     storage.write('isClassId', _mapUser[type]['classId']);
      //     storage.write('isUserId', _mapUser[type]['userId']);
      //     storage.write('isGradeLevel', _mapUser[type]['gradeLevel']);
      //     storage.write('isPassword', _mapUser[type]['password']);
      //     // storage.write('isUsername', _mapUser[type]['name']);
      //     // print("isActive=${storage.read('isActive')}");
      //     Get.offAllNamed('dashboard');
      //   });
      // }
    }
  }

  _buildItem(int index) {
    return InkWell(
      child: Card(
        elevation: 5,
        color: storage.read('isActive') == studentId[index]
            ? Colors.grey.shade300
            : null,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              // height: 120,
              child: Row(
                children: [
                  SizedBox(
                    child: _buildUrlImages(studentPhoto[index]),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      height: 8.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${studentName[index]}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: myTextStyleHeader[phoneSize],
                          ),
                          Text(
                            '${studentId[index]}',
                            style: TextStyle(
                                color:
                                    storage.read('isActive') == studentId[index]
                                        ? Colors.black
                                        : Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Icon(storage.read('isActive') == studentId[index]
                        ? Icons.done
                        : null),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // if(storage.read('isActive') == studentId[index])
        //   print('studentId[index]=${studentId[index]}');
        if (storage.read('isActive') != studentId[index]) {
          for (dynamic type in _mapUser.keys) {
            setState(() {
              if (type == studentId[index]) {
                debugPrint("value ${_mapUser[type]['campus']}");
                storage.write('isActive', type);
                storage.write('isName', _mapUser[type]['name']);
                storage.write('user_token', _mapUser[type]['token']);
                storage.write('isClassId', _mapUser[type]['classId']);
                storage.write('isUserId', _mapUser[type]['userId']);
                storage.write('isGradeLevel', _mapUser[type]['gradeLevel']);
                storage.write('isPassword', _mapUser[type]['password']);
                storage.write('isPhoto', _mapUser[type]['photo']);
                storage.write('name', _mapUser[type]['name']);
                // storage.write('campus', '');
                // storage.write('isUsername', _mapUser[type]['name']);
                // print("isActive=${storage.read('isActive')}");
                Get.offAllNamed('dashboard');
              }
            });
          }
        }
      },
    );
  }

  _buildUrlImages(String urlImage) {
    //DefaultCacheManager().removeFile(urlImage);
    return Container(
      // color: Colors.white,
      child: CachedNetworkImage(
        height: 5.h,
        width: 5.h,
        imageUrl: urlImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: imageProvider,
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
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
}
