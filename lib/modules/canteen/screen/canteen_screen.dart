import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_document/my_files/init.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/canteen/controller/canteen_controller.dart';
import 'package:school/modules/canteen/screen/style_card.dart';
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

class _CanteenScreenState extends State<CanteenScreen>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(CanteenController());
  TransformationController? transcontroller;
  AnimationController? animatedController;
  Animation<Matrix4>? animation;
  final double minScale = 1;
  final double maxScale = 4;
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
    transcontroller = TransformationController();

    animatedController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => transcontroller!.value = animation!.value);
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColor.primary, // Set your desired color here
      statusBarIconBrightness:
          Brightness.light, // Change the color of the icons
    ));
    return !isLoading
        ? LoadingCanteen()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, right: 20, top: 0),
                          height: 25.h,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.black, // Left border color
                                width: 0.1, // Left border width
                              ),
                            ),
                          ),
                          child: Column(
                            children: [
                              Container(
                                // color: AppColor.primaryColor,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 20),
                                      child: GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Icon(
                                          device == 'iOS'
                                              ? Icons.arrow_back_ios
                                              : Icons.arrow_back,
                                          size: 25,
                                          color: AppColor.primary,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text('${storage.read("isName")}',
                                            style: TextStyle(
                                                color: AppColor.primary
                                                    .withOpacity(0.9),
                                                overflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w500,
                                                fontSize:
                                                    SizerUtil.deviceType ==
                                                            DeviceType.tablet
                                                        ? 14.sp
                                                        : 16.sp)),
                                      ),
                                    ),
                                    Obx(() => Container(
                                          child: CupertinoSwitch(
                                            activeColor: Colors.blue,
                                            trackColor: Colors.red,
                                            value: controller
                                                        .isMuteCanteen.value ==
                                                    1
                                                ? true
                                                : false,
                                            onChanged: (value) {
                                              controller.updateNotificationMenu(
                                                  value: value);
                                            },
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Spacer(),
                              _buildMainBalance,
                              Spacer(),
                            ],
                          ),
                        ),
                        _buildBodyListExtend,
                      ],
                    ),
                  ),
                  Obx(() => controller.isShowMenu.value
                      ? GestureDetector(
                          onTap: () {
                            controller.ontapMenu();
                          },
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 5.0,
                                sigmaY:
                                    5.0), // Adjust the blur radius as needed
                            child: Container(
                              color: Colors.black.withOpacity(0.9),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "Menu Today",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 10.sp
                                          : 18.sp,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Container(
                                        height: 30.h,
                                        color: Colors.pink,
                                        child: CarouselSlider.builder(
                                          itemCount: controller
                                              .menu.value.image!.length,
                                          itemBuilder:
                                              (contestxt, index, realIndex) {
                                            return Stack(
                                              children: [
                                                InteractiveViewer(
                                                  transformationController:
                                                      transcontroller,
                                                  onInteractionEnd: (value) {
                                                    reset();
                                                  },
                                                  maxScale: 5,
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 30.h,
                                                      width: double.infinity,
                                                      color: Colors.white,
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${controller.menu.value.image![index]}",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0,
                                                  bottom: 0,
                                                  child: CustomPaint(
                                                    painter: StyleCardMeun(),
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: 50,
                                                          width: 50,
                                                        ),
                                                        Positioned(
                                                          right: 5,
                                                          bottom: 5,
                                                          child: Text(
                                                            "${index + 1}",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            );
                                          },
                                          options: CarouselOptions(
                                              height: SizerUtil.deviceType ==
                                                      DeviceType.tablet
                                                  ? 130.sp
                                                  : 180.sp,
                                              viewportFraction: 1,
                                              autoPlay: true,
                                              onPageChanged:
                                                  (index, reason) {}),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox())
                ],
              ),
            ),
          );
  }

  void reset() {
    animation = Matrix4Tween(
      begin: transcontroller!.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animatedController!, curve: Curves.ease));
    animatedController!.forward(from: 0);
  }

  get _buildBodyListExtend {
    return _recPosUserData[0].cardId != ""
        ? Expanded(
            child: RefreshIndicator(
              onRefresh: (() => _fetchPosUser()),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: menuCanteenList.length,
                      itemBuilder: (context, index) => Container(
                        child: Column(
                          children: [
                            _buildItem(index),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () => controller.isNoMenu.value == false
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Menu Today",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withOpacity(0.9),
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 10.sp
                                          : 12.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.ontapMenu();
                                  },
                                  child: Container(
                                    height: 25.h,
                                    width: MediaQuery.of(context).size.width,
                                    child: CarouselSlider.builder(
                                        itemCount:
                                            controller.menu.value.image!.length,
                                        itemBuilder:
                                            (contestxt, index, realIndex) {
                                          return Stack(
                                            children: [
                                              Container(
                                                height: 200,
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${controller.menu.value.image![index]}",
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                bottom: 0,
                                                child: CustomPaint(
                                                  painter: StyleCardMeun(),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: 50,
                                                        width: 50,
                                                      ),
                                                      Positioned(
                                                        right: 5,
                                                        bottom: 5,
                                                        child: Text(
                                                          "${index + 1}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                        options: CarouselOptions(
                                            height: SizerUtil.deviceType ==
                                                    DeviceType.tablet
                                                ? 130.sp
                                                : 180.sp,
                                            viewportFraction: 1,
                                            autoPlay:
                                                !controller.isShowMenu.value,
                                            onPageChanged: (index, reason) {})),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 25.h,
                              child: Center(
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffe85d04),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                      "Menu for today not yet available !",
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.9),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )),
                              )),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          )
        : SizedBox();
  }

  _buildItem(int index) {
    return InkWell(
      child: Container(
          // color: AppColor.primaryColor,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 8, right: 8),
          height: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(int.parse(menuCanteenList[index].color)),
                        shape: BoxShape.circle),
                    child: SizedBox(
                        height: 6.w,
                        child: Image.asset(
                          '${menuCanteenList[index].img}',
                          color: Colors.white,
                        )),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${menuCanteenList[index].title}',
                          style: myTextStyleHeader[phoneSize]!
                              .copyWith(color: Colors.black)),
                      SizedBox(
                        height: 1.h,
                      ),
                      Container(
                        width: 70.w,
                        child: AutoSizeText(
                          '${menuCanteenList[index].subtitle}',
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 15
                                      : 11),
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
                  size: 22, color: AppColor.mainColor.withOpacity(0.6))
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
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      width: 90.w,
      height: 13.h,
      child: _recPosUserData[0].cardId != ""
          ? Column(
              children: [
                Text("\$${f.format(_balance)}",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 35.sp
                          : 30.sp,
                    )),
                Text("Available Balance",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.withOpacity(1),
                      fontSize: SizerUtil.deviceType == DeviceType.tablet
                          ? 15.sp
                          : 13.sp,
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
    debugPrint("kkk");
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
