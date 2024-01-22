import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/profile/controllers/profile_controller.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatefulWidget {
  final String profile;
  final String studentName;
  final String id;
  const ProfileScreen({
    Key? key,
    required this.profile,
    required this.studentName,
    required this.id,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Container(
      height: 100.h,
      width: 100.w,
      color: AppColor.secondary,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColor.primary,
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.isShowProfile.value = false;
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Icon(Icons.close_rounded,
                                color: Colors.white, size: 20.sp),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "ICS",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 20.sp
                                : 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 25.w,
                    width: 25.w,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        color: AppColor.primary,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                              widget.profile,
                            ),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.studentName}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 8.sp
                          : 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Student ID : ${widget.id}",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 8.sp
                          : 12.sp,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Column(
                children: [
                  Column(
                    children: controller.menuProfile.asMap().entries.map((e) {
                      return GestureDetector(
                        onTap: () {
                          controller.ontaplist(
                              route: e.value.route, track: e.value.title);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 10),
                          height: 7.5.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(children: [
                            SizedBox(
                              width: 20,
                            ),
                            e.value.icon,
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "${e.value.title}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w400,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 18.sp
                                        : 14.sp,
                              ),
                            )
                          ]),
                        ),
                      );
                    }).toList(),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.logout();
                    },
                    child: Container(
                      height: 7.5.h,
                      decoration: BoxDecoration(
                          color: AppColor.warning,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        "LOGOUT",
                        style: TextStyle(
                            color: AppColor.mainColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      )),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
