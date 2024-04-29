// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/models/contact_list.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/theme/theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late final PhoneSize phoneSize;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Contact Us"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColor.primaryColor,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              text: "Main Campus",
            ),
            Tab(
              text: "Calmette Campus",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Tab(
            child: _mainCampusInfo,
          ),
          Tab(
            child: _calmetteCampusInfo,
          ),
        ],
      ),
    );
  }

  get _mainCampusInfo {
    return Container(
      child: ListView.builder(
          itemCount: mainCampusList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Color.fromARGB(255, 164, 200, 250),
                  border: Border.all(color: AppColor.primaryColor, width: 0.5)),
              margin: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: ListTile(
                leading: Image.asset(
                  mainCampusList[index].img,
                  height: 35,
                  width: 35,
                ),
                title: Text(mainCampusList[index].title,
                    style: myTextStyleBody[phoneSize]),
                onTap: () {
                  if (mainCampusList[index].directApp)
                    customLaunchDirectApp(id: mainCampusList[index].launch);
                  else
                    customLaunch(mainCampusList[index].launch);
                },
              ),
            );
          }),
    );
  }

  get _calmetteCampusInfo {
    return Container(
      child: ListView.builder(
          itemCount: calmetteCampusList.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              margin: EdgeInsets.all(5),
              elevation: 5,
              child: ListTile(
                leading: Image.asset(
                  calmetteCampusList[index].img,
                  height: 40,
                  width: 40,
                ),
                title: Text(calmetteCampusList[index].title,
                    style: myTextStyleBody[phoneSize]),
                onTap: () {
                  if (calmetteCampusList[index].directApp)
                    customLaunchDirectApp(id: calmetteCampusList[index].launch);
                  else
                    customLaunch(calmetteCampusList[index].launch);
                },
              ),
            );
          }),
    );
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  Future<void> customLaunchDirectApp({required String id}) async {
    String fbProtocolUrl;
    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/$id';
    } else {
      fbProtocolUrl = 'fb://page/$id';
    }
    String fallbackUrl = 'https://www.facebook.com/$id/';
    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);
      if (!launched) {
        await launch(fallbackUrl, forceSafariVC: false);
      }
    } catch (e) {
      await launch(fallbackUrl, forceSafariVC: false);
    }
  }
}
