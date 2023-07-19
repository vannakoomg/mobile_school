import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BlankPage extends StatefulWidget {
  const BlankPage({Key? key}) : super(key: key);

  @override
  State<BlankPage> createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/home_screen_icon/no-data.png',
            height: 15.h,
          ),
          SizedBox(
            height: 8,
          ),
          Text('No Data Found',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizerUtil.deviceType == DeviceType.tablet
                      ? 9.sp
                      : 11.sp)),
        ],
      ),
    );
  }
}
