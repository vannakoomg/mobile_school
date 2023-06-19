import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/screens/pages/top_up_history.dart';
import 'package:sizer/sizer.dart';

import '../../config/theme/theme.dart';
import 'pos_history.dart';

class IWallet extends StatefulWidget {
  final int index;
  const IWallet({Key? key, required this.index}) : super(key: key);

  @override
  _IWalletState createState() => _IWalletState();
}

class _IWalletState extends State<IWallet> with TickerProviderStateMixin {
  late final PhoneSize phoneSize;
  late String device;
  final storage = GetStorage();
  double _fontSize = 0;
  var changeTitle = 0.0, low = 0.0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;

    if (Platform.isAndroid)
      device = 'Android';
    else
      device = 'iOS';

    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(widget.index);
    // _tabController = TabController(length: 2, vsync: this);
    _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 11.sp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // final scrolled = innerBoxIsScrolled.scrollOffset > 0;
            // print("innerBoxIsScrolled=$innerBoxIsScrolled");
            return <Widget>[
              SliverAppBar(
                expandedHeight: 30.h,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text("",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            )),
                        background: _buildBalanceCard);
                  },
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    // indicatorColor: Colors.red,
                    unselectedLabelColor: Color(0xff1d1a56),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Color(0xff1d1a56),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xff1d1a56))),
                    tabs: [
                      Tab(
                        child: Text(
                          'Top Ups',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: _fontSize),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Orders',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: _fontSize),
                        ),
                      ),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [tabTopUp, tabOrder],
          ),
        ),
      ),
    );
  }

  get _buildBalanceCard {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage("assets/icons/canteen/iWallet.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(''),
          Container(
            child: Text("${storage.read("card_no")}",
                style: TextStyle(
                    color: Color(0xff1d1a56),
                    fontWeight: FontWeight.w700,
                    fontSize: SizerUtil.deviceType == DeviceType.tablet
                        ? 12.sp
                        : 13.sp)),
            alignment: Alignment.centerRight,
            width: 100.w,
          ),
          Text(''),
          Container(
            alignment: Alignment.center,
            child: Text("iWallet History",
                style: TextStyle(
                  color: Color(0xff1d1a56),
                  fontWeight: FontWeight.w900,
                  fontSize:
                      SizerUtil.deviceType == DeviceType.tablet ? 20.sp : 22.sp,
                  fontStyle: FontStyle.italic,
                )),
          ),
          Text(''),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${storage.read('isName')}",
                      style: TextStyle(
                          color: Color(0xff1d1a56),
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 12.sp
                              : 13.sp)),
                  Text("${storage.read('isActive')}",
                      style: TextStyle(
                          color: Color(0xff1d1a56),
                          fontWeight: FontWeight.w600,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 11.sp
                              : 12.sp)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Available Balance",
                      style: TextStyle(
                          color: Color(0xff1d1a56),
                          fontWeight: FontWeight.w700,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 12.sp
                              : 13.sp)),
                  Text("\$${storage.read("available_balance")}",
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontWeight: FontWeight.w900,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 15.sp
                              : 16.sp)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  get tabTopUp {
    return TopUpHistory();
  }

  get tabOrder {
    return PosHistory();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      elevation: 2,
      child: new Container(
        color: Colors.white,
        child: _tabBar,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
