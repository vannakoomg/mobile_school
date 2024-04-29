import 'dart:ffi';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static info({
    required String? title,
    required BuildContext context,
    bool isTop = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              '$title',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: Duration(days: 365),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: isTop == false ? MediaQuery.sizeOf(context).height - 150 : 10,
          bottom: isTop == true ? MediaQuery.sizeOf(context).height - 150 : 10,
        ),
      ),
    );
  }

  static success({
    required String? title,
    required BuildContext context,
    bool isTop = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              '$title',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: Duration(days: 365),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: isTop == false ? MediaQuery.sizeOf(context).height - 150 : 10,
          bottom: isTop == false ? MediaQuery.sizeOf(context).height - 150 : 10,
        ),
      ),
    );
  }

  static danger({
    required String? title,
    required BuildContext context,
    bool isTop = false,
  }) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(
              '$title',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
        duration: Duration(days: 365),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          top: isTop == false ? MediaQuery.sizeOf(context).height - 150 : 10,
          bottom: isTop == false ? MediaQuery.sizeOf(context).height - 150 : 10,
        ),
      ),
    );
  }

  static warning({
    required String? title,
    required BuildContext context,
    Widget icon = const Icon(
      Icons.warning_amber_rounded,
      color: Color(0xffdb7c26),
    ),
    FlushbarPosition position = FlushbarPosition.BOTTOM,
  }) {
    return Flushbar(
      backgroundColor: const Color.fromARGB(255, 255, 228, 195),
      borderColor: const Color(0xffdb7c26),
      borderWidth: 0.3,
      padding: const EdgeInsets.only(left: 8, right: 8, top: 15, bottom: 10),
      margin: const EdgeInsets.all(10),
      messageSize: 0,
      flushbarPosition: position,
      message: "0sdfsdfsdfsd",
      titleText: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            icon,
            const Gap(5),
            Expanded(
              child: Text(
                "$title",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: const Color(0xffdb7c26),
                    fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.close_rounded,
                color: Color(0xffdb7c26),
              ),
            )
          ],
        ),
      ),
      reverseAnimationCurve: Curves.easeInOut,
      borderRadius: BorderRadius.circular(10),
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}
