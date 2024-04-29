import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBottonAuth extends StatelessWidget {
  final Function ontap;
  final String title;

  const CustomBottonAuth({Key? key, required this.ontap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        ontap();
      },
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
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
          "$title",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizerUtil.deviceType == DeviceType.tablet ? 18 : 14),
        ),
      ),
    );
  }
}
