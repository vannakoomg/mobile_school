import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/models/about_list.dart';
import 'package:sizer/sizer.dart';
import 'theme/theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final PhoneSize phoneSize;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About Us"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: aboutUsList.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: EdgeInsets.all(5),
                elevation: 5,
                child: ListTile(
                  leading: Image.asset(
                    aboutUsList[index].img,
                    height: 40,
                    width: 40,
                  ),
                  title: Text(aboutUsList[index].title,
                      style: myTextStyleBody[phoneSize]),
                  onTap: () {
                    Get.toNamed(aboutUsList[index].route);
                  },
                ),
              );
            }),
      ),
    );
  }
}
