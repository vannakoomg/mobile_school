import 'package:flutter/material.dart';
import 'package:school/repos/aba.dart';
import 'package:sizer/sizer.dart';

import '../../../config/app_colors.dart';

class LoadingCanteen extends StatelessWidget {
  const LoadingCanteen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: 30.h,
            color: AppColor.primaryColor,
            child: Center(
              child: Text('${storage.read("isName")}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 14.sp
                          : 18.sp)),
            ),
          ),
          Spacer(),
          CircularProgressIndicator(
            color: AppColor.primaryColor,
          ),
          Spacer(),
        ],
      ),
    );
  }
}
