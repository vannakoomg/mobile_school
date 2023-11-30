import 'dart:io';

import 'package:animated_icon/animate_icon.dart';
import 'package:animated_icon/animate_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/canteen/controller/canteen_controller.dart';
import 'package:school/modules/canteen/widget/loading_canteen.dart';
import 'package:school/utils/function/function.dart';
import 'package:sizer/sizer.dart';
import '../../../models/PosUserDB.dart';
import '../../../models/menu_icon_list.dart';
import '../../../repos/pos_data.dart';
import '../../../config/theme/theme.dart';

class CanteenScreen extends StatefulWidget {
  const CanteenScreen({Key? key}) : super(key: key);

  @override
  _CanteenScreenState createState() => _CanteenScreenState();
}

class _CanteenScreenState extends State<CanteenScreen> {
  final controller = Get.put(CanteenController());
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
        ? SafeArea(child: LoadingCanteen())
        : SafeArea(
            child: Container(
              // height: 100.h,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    height: 30.h,
                    color: AppColor.primaryColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(
                                  device == 'iOS'
                                      ? Icons.arrow_back_ios
                                      : Icons.arrow_back,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Center(
                                child: Text('${storage.read("isName")}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizerUtil.deviceType ==
                                                DeviceType.tablet
                                            ? 14.sp
                                            : 18.sp)),
                              ),
                            ),
                            Obx(() => Container(
                                  child: CupertinoSwitch(
                                    activeColor: Colors.blue,
                                    trackColor: Colors.red,
                                    value: controller.isMuteCanteen.value == 1
                                        ? true
                                        : false,
                                    onChanged: (value) {
                                      controller.updateNotificationMenu(
                                          value: value);
                                    },
                                  ),
                                ))
                            //  Switch(
                            //       value: controller.isMuteCanteen.value == 1
                            //           ? true
                            //           : false,
                            //       onChanged: (value) {
                            //         controller.updateNotificationMenu(
                            //             value: value);
                            //       },
                            // activeColor: Colors.blue,
                            // inactiveThumbColor: Colors.red,
                            // inactiveTrackColor:
                            //     Colors.red.withOpacity(0.6),
                            //     )),
                          ],
                        ),
                        _buildMainBalance
                      ],
                    ),
                  ),
                  _buildBodyListExtend,
                ],
              ),
            ),
          );
  }

  get _buildBodyListExtend {
    return _recPosUserData[0].cardId != ""
        ? Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: menuCanteenList.length,
                    itemBuilder: (context, index) => Column(
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
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Menu Today",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColor.primaryColor.withOpacity(0.9),
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 10.sp
                              : 12.sp,
                        ),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 25.h,
                    child: CarouselSlider.builder(
                        itemCount: controller.menu.value.image!.length,
                        itemBuilder: (contestxt, index, realIndex) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl:
                                  "${controller.menu.value.image![index]}",
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                            height: SizerUtil.deviceType == DeviceType.tablet
                                ? 130.sp
                                : 180.sp,
                            viewportFraction: 1,
                            autoPlay: true,
                            onPageChanged: (index, reason) {})),
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          )
        : SizedBox();
  }

  _buildItem(int index) {
    return InkWell(
      child: Container(
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
                              color: Colors.grey,
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
              Icon(Icons.arrow_forward_ios,
                  size: 22, color: AppColor.primaryColor.withOpacity(0.9))
            ],
          )),
      onTap: () {
        tracking(menuCanteenList[index].title);
        if ((_recPosUserData[0].cardId != "" &&
            posSessionOrderId != 0 &&
            index == 0)) {
          handleReturnData(
              route: menuCanteenList[index].route, arg: productCount);
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
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 90.w,
      height: 13.h,
      child: _recPosUserData[0].cardId != ""
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 10.w,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Available Balance",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: AppColor.primaryColor.withOpacity(0.9),
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 10.sp
                              : 12.sp,
                        )),
                    Text("\$${f.format(_balance)}",
                        style: TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 14.sp
                                : 16.sp))
                  ],
                ),
                Container(
                    alignment: Alignment.topRight,
                    width: 10.w,
                    height: 100.w,
                    child: AnimateIcon(
                      key: UniqueKey(),
                      onTap: () {
                        _fetchPosUser();
                      },
                      iconType: IconType.animatedOnTap,
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
    );
  }

  handleReturnData({required String route, required int arg}) async {
    var data = await Get.toNamed(route, arguments: arg);
    if (data == true) {
      setState(() {
        _fetchPosUser();
      });
    }
  }

  Future<void> _fetchPosUser() async {
    await controller.fetchMenu();
    await fetchPos(route: "user").then((value) {
      try {
        setState(() {
          if (!isFirstLoading) {
            _recCanteenMenu.addAll(value.canteenMenu);
            _recCanteenMenu.forEachIndexed((index, element) {
              menuCanteenList[index].title = element.title;
              menuCanteenList[index].subtitle = element.subtitle;
              storage.write("unregistered", value.unregistered);
            });
            isFirstLoading = true;
          }
          posSessionOrderId = value.posSessionOrderId;
          posSessionTopUpId = value.posSessionTopUpId;
          posUserMessage = value.message;
          _recPosUserData.addAll(value.response);
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

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          Navigator.of(context).pop();
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
