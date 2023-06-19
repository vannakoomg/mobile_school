// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusesPage extends StatefulWidget {
  const CampusesPage({Key? key}) : super(key: key);

  @override
  _CampusesPageState createState() => _CampusesPageState();
}

class _CampusesPageState extends State<CampusesPage>
    with TickerProviderStateMixin {
  double _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 18 : 14;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Campuses"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
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
    return SingleChildScrollView(
      child: Column(
        children: [
          _space,
          Container(
            width: 95.w,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, // Set border color
                    width: 3.0), // Set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0)), // Set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
                ] // Make rounded corner of border
                ),
            child: Image.asset(
              'assets/icons/about_us_icon/main_campus_small.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          _space,
          InkWell(
            onTap: () => customLaunch(
                'https://www.google.com/maps/place/ICS+International+School/@11.5611053,104.9240103,17z/data=!3m1!4b1!4m5!3m4!1s0x31095139c214cfe1:0x2def7adf627bfdbc!8m2!3d11.5611001!4d104.926199'),
            child: Stack(
              children: [
                Container(
                  width: 95.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.white, // Set border color
                          width: 3.0), // Set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(5.0)), // Set rounded corner radius
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 10,
                            color: Colors.black,
                            offset: Offset(1, 3))
                      ] // Make rounded corner of border
                      ),
                  child: Image.asset(
                    'assets/icons/about_us_icon/main_map.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 5.sp,
                  left: 5.sp,
                  child: Container(
                    alignment: Alignment.center,
                    height: 25.sp,
                    width: 35.w,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        gradient: new LinearGradient(
                          colors: [Color(0xff1a237e), Colors.lightBlueAccent],
                        )),
                    padding: const EdgeInsets.all(0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions,
                          color: Colors.white,
                        ),
                        Text(
                          "Directions",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 18
                                      : 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Address: ",
                        style: TextStyle(
                            fontSize: _fontSize + 2,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                          'No 14, Street 214, Sangkat Boeung Raing, Khan Daun Penh, Phnom Penh',
                          style: TextStyle(fontSize: _fontSize)),
                    ),
                  ],
                ),
                _space,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Tel: ",
                        style: TextStyle(
                            fontSize: _fontSize + 2,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text('099 509 998 / 016 929 985',
                          style: TextStyle(fontSize: _fontSize)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  get _calmetteCampusInfo {
    return SingleChildScrollView(
      child: Column(
        children: [
          _space,
          Container(
            width: 95.w,
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.white, // Set border color
                    width: 3.0), // Set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(5.0)), // Set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.black, offset: Offset(1, 3))
                ] // Make rounded corner of border
                ),
            child: Image.asset(
              'assets/icons/about_us_icon/calmette_campus_small.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          _space,
          InkWell(
            onTap: () => customLaunch(
                'https://www.google.com/maps/place/ICS+Calmett+Campus/@11.582241,104.9164326,19.15z/data=!4m12!1m6!3m5!1s0x31095139c214cfe1:0x2def7adf627bfdbc!2sICS+International+School!8m2!3d11.5611001!4d104.926199!3m4!1s0x3109515e74d88fed:0xd8d2066e59cd4aeb!8m2!3d11.5823708!4d104.9170562'),
            child: Stack(children: [
              Container(
                width: 95.w,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.white, // Set border color
                        width: 3.0), // Set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0)), // Set rounded corner radius
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          color: Colors.black,
                          offset: Offset(1, 3))
                    ] // Make rounded corner of border
                    ),
                child: Image.asset(
                  'assets/icons/about_us_icon/calmette_map.jpeg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 5.sp,
                left: 5.sp,
                child: Container(
                  alignment: Alignment.center,
                  height: 25.sp,
                  width: 35.w,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: new LinearGradient(
                        colors: [Color(0xff1a237e), Colors.lightBlueAccent],
                      )),
                  padding: const EdgeInsets.all(0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.directions,
                        color: Colors.white,
                      ),
                      Text(
                        "Directions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 18
                                : 14),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Address: ",
                        style: TextStyle(
                            fontSize: _fontSize + 2,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text(
                          'No 25A, Street 75 (Corner of Street 80), Sangkat Sras Chak, Khan Daun Penh, Phnom Penh',
                          style: TextStyle(fontSize: _fontSize)),
                    ),
                  ],
                ),
                _space,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Tel: ",
                        style: TextStyle(
                            fontSize: _fontSize + 2,
                            fontWeight: FontWeight.bold)),
                    Expanded(
                      child: Text('099 509 997 / 016 929 975',
                          style: TextStyle(fontSize: _fontSize)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  Widget get _space => const SizedBox(height: 10);
}
