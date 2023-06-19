// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:school/screens/pages/pos_cart_page.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import '../../models/posDB.dart';
import '../../repos/pos_data.dart';
import '../theme/theme.dart';

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
  final ScrollController _scrollController = ScrollController();
  late final PhoneSize phoneSize;
  late List<PosData> _recPosData = [];
  bool isLoading = false;
  int tab = 0, _items = 0;
  double subTotal = 0, _fontSize = 0;

  var f = NumberFormat("##0.00", "en_US");
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  int _currentIndex = 0;
  int _shadowIndex = 0;

  @override
  void initState() {
    super.initState();
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
          : Column(
              children: <Widget>[
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
            ),
      bottomNavigationBar: _items != 0 ? _buildButtonAddToCard() : null,
    );
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
              _items <= 1 ? "$_items Item" : "$_items Items",
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
                    _recPosData.forEach((element) {
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
                  child: Text("ADD TO CART : \$${f.format(subTotal)}",
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
          total: subTotal,
        ));
    if (data == true) {
      setState(() {
        Get.back(result: true);
      });
    }
  }

  List<Tab> tabMaker() {
    List<Tab> tabs = [];
    for (var i = 0; i < _recPosData.length; i++) {
      tabs.add(Tab(
        child: Text(
          _recPosData[i].group,
          style: TextStyle(fontSize: _fontSize),
        ),
      ));
    }
    return tabs;
  }

  get _buildBody {
    return ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        itemPositionsListener: _itemPositionsListener,
        itemCount: _recPosData.length,
        itemBuilder: (context, index) {
          return StickyHeader(
            header: Container(
              height: 8.h,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${_recPosData[index].group}',
                style: myTextStyleHeader[phoneSize],
              ),
            ),
            content: Container(
              // height: 50,
              child: ListView.builder(
                  controller: _scrollController,
                  physics: PageScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _recPosData[index].list.length,
                  itemBuilder: (context, index2) => Container(
                        child: _buildItem(_recPosData[index].list[index2]),
                      )),
            ),
          );
        });
  }

  _buildItem(item) {
    return InkWell(
      child: Card(
        color: item.amount != 0 ? Colors.grey.shade200 : null,
        elevation: 5,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              // height: 120,
              child: Row(
                children: [
                  // SizedBox(
                  //   child: _buildUrlImages(
                  //       "https://media.istockphoto.com/id/1190330112/photo/fried-pork-and-vegetables-on-white-background.jpg?s=612x612&w=0&k=20&c=TzvLLGGvPAmxhKJ6fz91UGek-zLNNCh4iq7MVWLnFwo="),
                  //   // child: _buildUrlImages("http://202.62.45.129:8069/web/image?model=product.product&id=6878&field=image_512"),
                  // ),
                  Container(
                    width: 12.h,
                    height: 12.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        // boxShadow: [
                        //   BoxShadow(
                        //       blurRadius: 5,
                        //       color: Colors.grey,
                        //       offset: Offset(1, 3))
                        // ],
                        image: DecorationImage(
                          image: imageFromBase64String(jsonDecode(item.image)),
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Container(
                      // width: 300,
                      // color: Colors.red,
                      height: 12.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "${item.name}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: myTextStyleHeader[phoneSize],
                              )),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "\$${f.format(item.lstPrice)}",
                              style: myTextStyleBody[phoneSize],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  item.amount != 0 ? _markOrder(item) : _addButton(item),
                ],
              ),
            ),
          ],
        ),
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
                setState(() {
                  item.amount = item.amount - 1;
                  subTotal = subTotal - item.lstPrice;
                  _items--;
                });
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
                  _items++;
                  subTotal = subTotal + item.lstPrice;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton(item) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 8.0,
          backgroundColor: Colors.white,
          shape: CircleBorder(),
        ),
        onPressed: () {
          setState(() {
            item.amount = 1;
            _items++;
            subTotal = subTotal + item.lstPrice;
          });
        },
        child: Icon(
          Icons.add,
          color: Color(0xff1d1a56),
        ));
  }

  void scrollTo(int index) {
    // print("indexindex=$index");
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
          _recPosData.addAll(value.response);
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
                        // padding: EdgeInsets.all(8.0),
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
                              // fontWeight: FontWeight.bold,
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
                            // print(url);
                            customLaunch(url);
                            //open URL in webview, or launch URL in browser, or any other logic here
                          },
                          // onImageTap: (img){
                          //   print('Image $img');
                          // },
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
