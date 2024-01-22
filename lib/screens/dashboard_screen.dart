import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/screens/about_screen.dart';
import 'package:school/screens/contact_screen.dart';
import 'package:school/screens/home_screen.dart';
import '../main_drawer.dart';
import '../repos/version.dart';
import '../translations/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

import 'widgets/popup_new_version.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Widget> _screenList = [];
  HomeScreen _homeScreen = HomeScreen();
  ContactScreen _contactUsScreen = ContactScreen();
  AboutScreen _aboutUsScreen = AboutScreen();
  // ProfileScreen _profileScreen = ProfileScreen();
  PageController _pageController = PageController();
  final storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      body: Container(
        color: Colors.grey.withOpacity(0.1),
        child: PageView(
          onPageChanged: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          controller: _pageController,
          children: _screenList,
        ),
      ),
      bottomNavigationBar: _buildBottom,
    );
  }

  @override
  void initState() {
    super.initState();
    String version = "Version 3.0";
    storage.write('isVersion', version);
    _fetchVersion();

    _screenList.add(_homeScreen);
    _screenList.add(_contactUsScreen);
    _screenList.add(_aboutUsScreen);
    // _screenList.add(_profileScreen);
  }

  int _currentIndex = 0;
  get _buildBottom {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          // print("index=$index");

          setState(() {
            _currentIndex = index;
            String track = '';
            index == 1
                ? track = "contact us"
                : index == 2
                    ? track = "about us"
                    : track = "profile";
            _pageController.animateToPage(
              _currentIndex,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          });
        },
        unselectedItemColor: Colors.grey,
        selectedItemColor: Color(0xff1d1a56),
        // type: BottomNavigationBarType.fixed, // This is all you need!
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '${LocaleKeys.bot_nav_home.tr()}',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contact_phone_outlined),
            label: '${LocaleKeys.bot_nav_contact_us.tr()}',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: '${LocaleKeys.bot_nav_about_us.tr()}',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '${LocaleKeys.bot_nav_personal.tr()}',
          ),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchVersion() {
    fetchVersion().then((value) {
      setState(() {
        try {
          if ('${value.name} ${value.value}' != storage.read('isVersion'))
            Future.delayed(Duration.zero, () {
              PopupNewVersion().dialogBuilder(context);
            });
        } catch (err) {
          print("err=$err");
        }
      });
    });
  }
}
