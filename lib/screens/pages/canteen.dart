import 'dart:io';

import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import '../../models/PosUserDB.dart';
import '../../models/menu_icon_list.dart';
import '../../repos/pos_data.dart';
import '../theme/theme.dart';

class CanteenScreen extends StatefulWidget {
  const CanteenScreen({Key? key}) : super(key: key);

  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  final storage = GetStorage();
  late final PhoneSize phoneSize;
  late String device;
  late List<PosUserData> _recPosUserData = [];
  late List<CanteenMenu> _recCanteenMenu = [];
  late int posSessionOrderId, posSessionTopUpId;
  late bool posMessage, posUserMessage;
  bool isLoading = false, isFirstLoading = false;
  var f = NumberFormat("##0.00", "en_US");
  double _balance = 0;
  int productCount = 0;
  late String title, body;

  // DateTime dateOnly = now.getDateOnly();

  @override
  void initState() {
    super.initState();
    _fetchPosUser();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;

    if (Platform.isAndroid)
      device = 'Android';
    else
      device = 'iOS';
  }

  @override
  Widget build(BuildContext context) {
    return !isLoading
        ? _loading()
        : Container(
            height: 100.h,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Column(
                  children: [_buildHeader, _buildBodyListExtend],
                ),
                _buildMainBalance,
                Positioned(
                  left: 20,
                  top: 40,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      device == 'iOS' ? Icons.arrow_back_ios : Icons.arrow_back,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          );
  }

  _loading() {
    return Container(
      // color: Colors.grey,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 30.h,
                color: Color(0xff1d1a56),
                margin: EdgeInsets.only(bottom: 2.h),
              ),
              Center(child: CircularProgressIndicator()),
            ],
          ),
          Positioned(
            left: 20,
            top: 40,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: Icon(
                device == 'iOS' ? Icons.arrow_back_ios : Icons.arrow_back,
                size: 25,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  get _buildHeader {
    return _recPosUserData[0].name != ""
        ? Container(
            padding: EdgeInsets.all(8.0),
            height: 30.h,
            color: Color(0xff1d1a56),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildUrlImages(storage.read('isPhoto') ?? ''),
                SizedBox(
                  width: 2.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Text('${_recPosUserData[0].name}',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 14.sp
                                      : 18.sp)),
                    ),
                    Text('${storage.read('isActive')}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 10.sp
                                : 11.sp)),
                  ],
                ),
              ],
            ),
          )
        : Container(
            padding: EdgeInsets.all(8.0),
            height: 30.h,
            color: Color(0xff1d1a56),
          );
  }

  get _buildBodyListExtend {
    return _recPosUserData[0].cardId != ""
        ? Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    // color: Colors.red,
                    height: 5.h,
                  ),
                  ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      // physics: PageScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: menuCanteenList.length,
                      itemBuilder: (context, index) => Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              index == 0
                                  ? Divider(
                                      color: Colors.blue,
                                      height: 2,
                                    )
                                  : SizedBox(),
                              _buildItem(index),
                              Divider(
                                color: Colors.blue,
                                height: 2,
                              )
                            ],
                          )),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  _buildItem(int index) {
    return InkWell(
      child: Container(
          // color: Colors.red,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 8, right: 8),
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 10.w,
                      child: Image.asset('${menuCanteenList[index].img}')),
                  SizedBox(
                    width: 5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${menuCanteenList[index].title}',
                          style: myTextStyleHeader[phoneSize]),
                      SizedBox(
                        height: 0.5.h,
                      ),
                      Container(
                        width: 70.w,
                        child: AutoSizeText(
                          '${menuCanteenList[index].subtitle}',
                          style: TextStyle(
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 15
                                      : 12),
                          minFontSize: 10,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Color(0xff1d1a56),
              )
            ],
          )),
      onTap: () {
        // print("productCount=$productCount");
        // _recPosUserData[0].cardId = "";
        // posSessionId = 0;
        if ((_recPosUserData[0].cardId != "" &&
            posSessionOrderId != 0 &&
            index == 0)) {
          handleReturnData(
              route: menuCanteenList[index].route, arg: productCount);
          // Get.toNamed(route, arguments: arg);
        } else if ((_recPosUserData[0].cardId != "" &&
            posSessionTopUpId != 0 &&
            index == 1)) {
          handleReturnData(
              route: menuCanteenList[index].route, arg: productCount);
        } else if ((_recPosUserData[0].cardId != "" &&
            (index == 2 || index == 3))) {
          handleReturnData(
              route: menuCanteenList[index].route, arg: productCount);
        } else if (_recPosUserData[0].cardId == "") {
          title = 'CARD';
          body = 'UNREGISTER';
          message(title: title, body: body);
        } else if (posSessionOrderId == 0 && (index == 0)) {
          title = '';
          body = storage.read("message_pre_order_closed");
          message(title: title, body: body);
        } else if (posSessionTopUpId == 0 && index == 1) {
          title = 'Top Up';
          body = storage.read("message_top_up_closed");
          message(title: title, body: body);
        } else if (index == 4) {
          handleReturnData(
              route: menuCanteenList[index].route, arg: productCount);
        }
      },
    );
  }

  get _buildMainBalance {
    return Positioned(
        top: 23.h,
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 3, offset: Offset(2, 3))
            ],
          ),
          width: 90.w,
          height: 13.h,
          // color: Colors.white,
          child: _recPosUserData[0].cardId != ""
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Available Balance",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 10.sp
                                        : 12.sp)),
                        Text("\$${f.format(_balance)}",
                            style: TextStyle(
                                color: Color(0xff1d1a56),
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 16.sp
                                        : 18.sp))
                      ],
                    ),
                    Container(
                        alignment: Alignment.topRight,
                        width: 10.w,
                        height: 100.w,
                        // color: Colors.red,
                        child: AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {
                            _fetchPosUser();
                            // var _checkTime = timeCheck();
                            // print("timeCheck=$_checkTime");
                          },
                          iconType: IconType.animatedOnTap,
                          // height: 8.w,
                          width: 8.w,
                          color: Colors.blue,
                          animateIcon: AnimateIcons.refresh,
                        )),
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  child: AutoSizeText("${storage.read("unregistered")}",
                      style: TextStyle(
                          color: Color(0xff1d1a56),
                          fontWeight: FontWeight.bold,
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 16.sp
                              : 18.sp),
                      minFontSize: 10,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
        ));
  }

  handleReturnData({required String route, required int arg}) async {
    var data = await Get.toNamed(route, arguments: arg);
    // print("data-canteen=$data");
    if (data == true) {
      setState(() {
        _fetchPosUser();
      });
    }
  }

  _buildUrlImages(String urlImage) {
    return Container(
      child: CachedNetworkImage(
        height: 10.h,
        width: 10.h,
        imageUrl: urlImage,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset("assets/icons/login_icon/logo_no_background.png"),
      ),
    );
  }

  Future<void> _fetchPosUser() async {
    await fetchPos(route: "user").then((value) {
      try {
        // print("value.status=${value.status}");
        setState(() {
          // value.canteenMenu
          if (!isFirstLoading) {
            _recCanteenMenu.addAll(value.canteenMenu);
            _recCanteenMenu.forEachIndexed((index, element) {
              menuCanteenList[index].title = element.title;
              menuCanteenList[index].subtitle = element.subtitle;
              storage.write("unregistered", value.unregistered);
              // print('index=$index');
            });
            isFirstLoading = true;
          }
          posSessionOrderId = value.posSessionOrderId;
          posSessionTopUpId = value.posSessionTopUpId;
          posUserMessage = value.message;
          _recPosUserData.addAll(value.response);
          // menuCanteenList[0].title='dara';
          _balance = value.response[0].balanceCard;
          storage.write("campus", value.response[0].campus);
          storage.write("available_balance", f.format(_balance));
          storage.write("term_condition", value.termCondition);
          storage.write("instruction", value.instruction);
          storage.write("pre_order_instruction", value.preOrderInstruction);
          storage.write("purchase_limit", value.response[0].purchaseLimit);
          storage.write("card_no", value.response[0].cardNo);
          storage.write("pick_up", value.pickUp);
          storage.write("product_id", value.productId);
          storage.write(
              "message_pre_order_closed", value.messagePreOrderClosed);
          storage.write("message_top_up_closed", value.messageTopUpClosed);
          storage.write(
              "message_pre_order_time_closed", value.messagePreOrderTimeClosed);
          storage.write("pre_order_time_from", value.preOrderTimeFrom);
          storage.write("pre_order_time_to", value.preOrderTimeTo);
          productCount = value.productsCount;
          isLoading = true;
        });
      } catch (err) {
        print("err=$err");
        Get.defaultDialog(
          title: "Oops!",
          middleText: "Something went wrong.\nPlease try again later.",
          barrierDismissible: false,
          confirm: reloadBtn(),
        );
      }
    });
  }

  bool timeCheck() {
    bool diff = true;
    DateTime now = new DateTime.now();
    String formattedDateTimeNow = DateFormat('y-MM-d kk:mm').format(now);
    String formattedDateNow = DateFormat('y-MM-d').format(now);
    DateTime dt = DateTime.parse(formattedDateTimeNow);
    DateTime dtFrom = DateTime.parse(
        "$formattedDateNow ${storage.read("pre_order_time_from")}");
    DateTime dtTo = DateTime.parse(
        "$formattedDateNow ${storage.read("pre_order_time_to")}");
    // print("dt1=$dt1");
    // print("dt2=$dt2");
    bool diffBefore = dt.isBefore(dtFrom);
    bool diffAfter = dt.isAfter(dtTo);

    // print("diffBefore=$diffBefore");
    // print("diffAfter=$diffAfter");
    if (!diffBefore && !diffAfter) // Ex: can order from 10:00 to 12:00
      diff = false;
    return diff;
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          Navigator.of(context).pop();
          // _fetchPos();
        },
        child: Text("OK"));
  }

  void message({required String title, required String body}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            // clipBehavior: Clip.antiAliasWithSaveLayer,
            content: InteractiveViewer(
              child: Container(
                padding: EdgeInsets.all(8.0),
                width: 80.w,
                height: 20.h,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$body',
                            style: myTextStyleHeaderRed[phoneSize]),
                      ),
                    ),
                    Positioned(
                      right: -5,
                      top: -5,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            key: const Key('closeIconKey'),
                            radius: 15,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
