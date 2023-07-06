import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/profile/controllers/profile_controller.dart';
import 'package:sizer/sizer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Container(
      height: 100.h,
      width: 100.w,
      color: Colors.grey[300],
      child: Column(
        children: [
          Container(
            color: AppColor.primaryColor,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 40),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.isShowProfile.value = false;
                        },
                        child: Icon(Icons.close_rounded,
                            color: Colors.white, size: 20.sp),
                      ),
                      SizedBox(
                        width: 20,
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
                      color: Colors.white, shape: BoxShape.circle),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "VANNAK",
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
                  "Student ID : IS202323",
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
              children: controller.menuProfile.asMap().entries.map((e) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('${e.value.route}');
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
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 18.sp
                              : 14.sp,
                        ),
                      )
                    ]),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
