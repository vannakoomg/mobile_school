// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:school/modules/order_canteen/controller/order_canteen_controller.dart';
import 'package:school/screens/pages/pos_cart_page.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import '../../repos/pos_data.dart';
import '../../config/theme/theme.dart';

class PosOrder extends StatefulWidget {
  const PosOrder({Key? key}) : super(key: key);

  @override
  _PosOrderState createState() => _PosOrderState();
}

class _PosOrderState extends State<PosOrder> with TickerProviderStateMixin {
  final itemKey = GlobalKey();
  final ItemScrollController itemScrollController = ItemScrollController();
  DefaultCacheManager manager = new DefaultCacheManager();
  late TabController _tabController;
  late final PhoneSize phoneSize;
  // late List<PosData> _recPosData = [];
  bool isLoading = false;
  int tab = 0;
  double _fontSize = 0;
  var f = NumberFormat("##0.00", "en_US");
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentIndex = 0;
  int _shadowIndex = 0;
  final controller = Get.put(OrderCanteenController());
  @override
  void initState() {
    super.initState();
    controller.items.value = 0;
    controller.subTotal.value = 0;
    controller.recPosData.clear();
    _tabController =
        TabController(length: int.parse('${Get.arguments}'), vsync: this);
    _fetchPos();

    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 11.sp;
    _itemPositionsListener.itemPositions.addListener(() {
      _currentIndex =
          _itemPositionsListener.itemPositions.value.elementAt(0).index;
      if (_currentIndex > _shadowIndex || _currentIndex < _shadowIndex) {
        _shadowIndex = _currentIndex;
        setState(() {
          _tabController.index = _shadowIndex;
        });
        print("Move to $_shadowIndex");
      }
    });
    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Canteen"), actions: <Widget>[
          IconButton(
              onPressed: () {
                info();
              },
              icon: Icon(Icons.info_outline)),
        ]),
        body: !isLoading
            ? Center(child: CircularProgressIndicator())
            : Obx(() => Column(
                  children: [
                    Container(
                      constraints: BoxConstraints.expand(height: 6.h),
                      child: TabBar(
                        onTap: (index) async {
                          scrollTo(index);
                        },
                        controller: _tabController,
                        labelColor: Colors.blueAccent,
                        unselectedLabelColor: Colors.blueGrey,
                        indicatorColor: Colors.blueAccent,
                        isScrollable: true,
                        tabs: tabMaker(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: _buildBody,
                      ),
                    )
                  ],
                )),
        bottomNavigationBar: Obx(
          () => controller.items.value != 0
              ? _buildButtonAddToCard()
              : SizedBox(),
        ));
  }

  _buildButtonAddToCard() {
    return Container(
      height: 10.h,
      // padding: EdgeInsets.only(top: 30, bottom: 10),
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          )),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.items.value <= 1
                  ? "${controller.items.value} Item"
                  : "${controller.items.value} Items",
              style: myTextStyleHeader[phoneSize],
            ),
            Container(
              height: 8.h,
              width: 50.w,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 8.0,
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    List<Map<String, dynamic>> _itemSelected = [];
                    controller.recPosData.forEach((element) {
                      var items = element.list
                          .where((item) => item.amount > 0)
                          .toList();
                      items.forEach((element) {
                        _itemSelected.add({
                          'id': element.id,
                          'name': element.name,
                          'lst_price': element.lstPrice,
                          'image': element.image,
                          'amount': element.amount
                        });
                      });
                    });
                    handleReturnData(itemSelected: _itemSelected);
                  },
                  child: Text(
                      "ADD TO CART : \$${f.format(controller.subTotal.value)}",
                      style: myTextStyleHeader[phoneSize])),
            ),
          ],
        ),
      ),
    );
  }

  handleReturnData({required List<Map<String, dynamic>> itemSelected}) async {
    var data = await Get.to(() => PosCart(
          elements: itemSelected,
          total: controller.subTotal.value,
        ));
    if (data == true) {
      setState(() {
        Get.back(result: true);
      });
    }
  }

  List<Tab> tabMaker() {
    List<Tab> tabs = [];
    for (var i = 0; i < controller.recPosData.length; i++) {
      tabs.add(Tab(
        child: Text(
          controller.recPosData[i].group,
          style: TextStyle(fontSize: _fontSize),
        ),
      ));
    }
    return tabs;
  }

  get _buildBody {
    return Obx(
      () => ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemCount: controller.recPosData.length,
        itemBuilder: (context, index) {
          return StickyHeader(
            header: Container(
              height: 8.h,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${controller.recPosData[index].group}',
                style: myTextStyleHeader[phoneSize],
              ),
            ),
            content: Container(
                child: Column(
              children:
                  controller.recPosData[index].list.asMap().entries.map((e) {
                return Container(
                    child: InkWell(
                  child: Card(
                    color: controller.recPosData[index].list[e.key].amount != 0
                        ? Colors.grey.shade200
                        : null,
                    elevation: 5,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Container(
                                width: 12.h,
                                height: 12.h,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    image: DecorationImage(
                                      image: imageFromBase64String(jsonDecode(
                                          controller.recPosData[index]
                                              .list[e.key].image)),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  height: 12.h,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "${controller.recPosData[index].list[e.key].name}",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style: myTextStyleHeader[phoneSize],
                                          )),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          "\$${f.format(controller.recPosData[index].list[e.key].lstPrice)}",
                                          style: myTextStyleBody[phoneSize],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Obx(
                                () => controller.recPosData[index].list[e.key]
                                            .amount !=
                                        0
                                    ? _markOrder(controller
                                        .recPosData[index].list[e.key])
                                    : ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 8.0,
                                          backgroundColor: Colors.white,
                                          shape: CircleBorder(),
                                        ),
                                        onPressed: () {
                                          // setState(() {
                                          controller.recPosData[index]
                                              .list[e.key].amount++;
                                          debugPrint(
                                              "index $index ${e.key} :  ${controller.recPosData[index].list[e.key].amount}");
                                          controller.items.value++;
                                          controller.subTotal.value =
                                              controller.subTotal.value +
                                                  controller.recPosData[index]
                                                      .list[e.key].lstPrice;
                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Color(0xff1d1a56),
                                        )),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
              }).toList(),
            )),
          );
        },
      ),
    );
  }

  Widget _markOrder(item) {
    return Container(
      height: 5.h,
      width: 22.w,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              child: Icon(
                Icons.remove,
                color: Colors.black,
              ),
              onTap: () {
                // setState(() {
                item.amount = item.amount - 1;
                controller.subTotal.value =
                    controller.subTotal.value - item.lstPrice;
                controller.items.value--;
                // });
              },
            ),
            Text('${item.amount}', style: myTextStyleBody[phoneSize]),
            InkWell(
              child: Icon(
                Icons.add,
                color: Colors.blue,
              ),
              onTap: () {
                setState(() {
                  item.amount = item.amount + 1;
                  controller.items.value++;
                  controller.subTotal.value =
                      controller.subTotal.value + item.lstPrice;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _addButton(int i, int j) {
  //   return
  // }

  void scrollTo(int index) {
    itemScrollController.scrollTo(
        index: index,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOutCubic,
        alignment: 0);
  }

  void _fetchPos() {
    fetchPos().then((value) {
      setState(() {
        try {
          controller.recPosData.addAll(value.response);
          isLoading = true;
        } catch (err) {
          print("err=$err");
        }
      });
    });
  }

  void info() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: SingleChildScrollView(
              child: InteractiveViewer(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: 85.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 4.h,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(''),
                              Center(
                                  child: Text('     Instructions',
                                      style: myTextStyleHeader[phoneSize])),
                              GestureDetector(
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
                              )
                            ],
                          )),
                      new Divider(
                        color: Colors.grey.shade700,
                      ),
                      Container(
                        child: Html(
                          data: storage.read("pre_order_instruction"),
                          tagsList: Html.tags,
                          style: {
                            "body": Style(
                              fontSize: FontSize(
                                SizerUtil.deviceType == DeviceType.tablet
                                    ? 18.0
                                    : 14.0,
                              ),
                            ),
                            'html': Style(backgroundColor: Colors.white12),
                            'table':
                                Style(backgroundColor: Colors.grey.shade200),
                            'td': Style(
                              backgroundColor: Colors.grey.shade400,
                              padding: EdgeInsets.all(10),
                            ),
                            'th': Style(
                                padding: EdgeInsets.all(10),
                                color: Colors.black),
                            'tr': Style(
                                backgroundColor: Colors.grey.shade300,
                                border: Border(
                                    bottom:
                                        BorderSide(color: Colors.greenAccent))),
                          },
                          onLinkTap: (String? url,
                              RenderContext context,
                              Map<String, String> attributes,
                              dom.Element? element) {
                            customLaunch(url);
                            //open URL in webview, or launch URL in browser, or any other logic here
                          },
                          onImageError: (exception, stacktrace) {
                            print(exception);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Uint8List convertBase64Image(String base64String) {
  //   return Base64Decoder().convert(base64String.split(',').last);
  // }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  static MemoryImage imageFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }
}
