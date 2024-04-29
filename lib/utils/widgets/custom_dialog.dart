import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/utils/widgets/custom_botton.dart';

class CustomDialog {
  static error({
    bool barrierDismissible = false,
    required String title,
    required String message,
    String bottonTitle = "OK",
    Function? ontap,
    required BuildContext context,
  }) {
    Get.defaultDialog(
      radius: 30,
      barrierDismissible: barrierDismissible,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: "",
      content: Container(
        padding: EdgeInsets.only(bottom: 10, left: 40, right: 40),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              Icons.do_disturb_outlined,
              size: 70,
              color: AppColor.error,
            ),
            Text("$title",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 22)),
            Gap(10),
            Text(
              "$message",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            Gap(20),
            CustomButton(
              colors: AppColor.error,
              white: 100,
              title: "$bottonTitle",
              onTap: () {
                if (ontap == null) {
                  Get.back();
                } else {
                  ontap();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  static wanring({
    bool barrierDismissible = false,
    required String title,
    required String message,
    String bottonTitle = "OK",
    Function? ontap,
    required BuildContext context,
  }) {
    Get.defaultDialog(
      barrierDismissible: barrierDismissible,
      radius: 30,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: "",
      content: Container(
        padding: EdgeInsets.only(bottom: 10, left: 40, right: 40),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 70,
              color: AppColor.wanring,
            ),
            Text("$title",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 22)),
            Gap(10),
            Text(
              "$message",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            Gap(20),
            CustomButton(
              colors: AppColor.wanring,
              white: 100,
              title: "$bottonTitle",
              onTap: () {
                if (ontap != null) {
                  ontap();
                } else {
                  Get.back();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  static success({
    required String title,
    required String message,
    String bottonTitle = "OK",
    Function? ontap,
    required BuildContext context,
    bool barrierDismissible = false,
  }) {
    Get.defaultDialog(
      barrierDismissible: barrierDismissible,
      radius: 30,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: "",
      content: Container(
        padding: EdgeInsets.only(bottom: 10, left: 40, right: 40),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              Icons.gpp_good_outlined,
              size: 70,
              color: AppColor.success,
            ),
            Text("$title",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 22)),
            Gap(10),
            Text(
              "$message",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            Gap(20),
            CustomButton(
              colors: AppColor.success,
              white: 100,
              title: "$bottonTitle",
              onTap: () {
                if (ontap != null) {
                  ontap();
                } else {
                  Get.back();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  static info({
    required String title,
    required String message,
    required BuildContext context,
    String bottonTitle = "OK",
    Function? ontap,
    bool barrierDismissible = false,
  }) {
    Get.defaultDialog(
      barrierDismissible: barrierDismissible,
      radius: 30,
      contentPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      title: "",
      content: Container(
        padding: EdgeInsets.only(bottom: 10, left: 40, right: 40),
        width: double.infinity,
        color: Colors.transparent,
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              size: 70,
              color: AppColor.info,
            ),
            Text("$title",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontSize: 22)),
            Gap(10),
            Text(
              "$message",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            Gap(20),
            CustomButton(
              colors: AppColor.info,
              white: 100,
              title: "$bottonTitle",
              onTap: () {
                if (ontap != null) {
                  ontap();
                } else {
                  Get.back();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
