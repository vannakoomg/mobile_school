import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import '../../repos/pos_create_order.dart';
import '../../config/theme/theme.dart';

class PosCart extends StatefulWidget {
  final List<Map<String, dynamic>> elements;
  final double total;

  const PosCart({Key? key, required this.elements, required this.total})
      : super(key: key);

  @override
  _PosCartState createState() => _PosCartState();
}

class _PosCartState extends State<PosCart> {
  final storage = GetStorage();
  DefaultCacheManager manager = new DefaultCacheManager();
  late final PhoneSize phoneSize;
  List<Map<String, dynamic>> _elements = [];
  TextEditingController _textEditingController = TextEditingController();
  var f = NumberFormat("##0.00", "en_US");
  List<Map<String, dynamic>> lines = [];
  late Map<String, dynamic> value;
  late bool _isDisableButton = false;
  double amountPaid = 0;
  int selectedIndex = 0;
  String pickUpTime = '';

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;

    manager.emptyCache();
    _elements = widget.elements;
    int i = 0;
    _elements.forEach((element) {
      i++;
      value = {
        "qty": element['amount'],
        "price_unit": element['lst_price'],
        "price_subtotal": f.format(element['amount'] * element['lst_price']),
        "price_subtotal_incl":
            f.format(element['amount'] * element['lst_price']),
        "product_id": element['id'],
        "line_id": i
      };
      amountPaid = amountPaid +
          double.parse(f.format(element['amount'] * element['lst_price']));
      lines.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Order Confirmation")),
      body: _buildBody,
      bottomNavigationBar: _buildBottomNavigationBar,
    );
  }

  get _buildBottomNavigationBar {
    return Container(
      height: 13.h,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          )),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Container(
          height: 10.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: myTextStyleHeader[phoneSize]),
                  Text("\$${f.format(widget.total)}",
                      style: myTextStyleHeader[phoneSize]),
                ],
              ),
              SizedBox(
                height: 6.h,
                width: 100.w,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 8.0,
                      backgroundColor: Color(0xff1d1a56),
                    ),
                    onPressed: () {
                      var _checkTime = timeCheck();
                      if (!_checkTime)
                        message(
                            title: '',
                            body:
                                storage.read("message_pre_order_time_closed"));
                      else {
                        if (_isDisableButton == false) {
                          setState(() {
                            _isDisableButton = true;
                          });
                          _createOrder(
                              lines: lines,
                              amountPaid: amountPaid,
                              pickUp: pickUpTime,
                              comment: _textEditingController.text,
                              topUpAmount: 0.0,
                              statePreOrder: 'draft');
                        }
                      }
                    },
                    child: Text("ORDER NOW",
                        style: myTextStyleHeaderWhite[phoneSize])),
              ),
            ],
          ),
        ),
      ),
    );
  }

  get _buildBody {
    return Container(
      // height: 100.h,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                // physics: AlwaysScrollableScrollPhysics(),
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: _elements.length,
                itemBuilder: (context, index) => Container(
                      child: _buildItem(_elements[index], index),
                    )),
            // Padding(
            //     padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            //     child: Text('Pick Up', style: myTextStyleHeader[phoneSize])),
            // SizedBox(
            //   height: 8.h,
            //   // width: 100.w,
            //   child: ListView.builder(
            //     // reverse: true,
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemCount: _strDate.length,
            //     itemBuilder: (context, index) {
            //       return Padding(
            //         padding: const EdgeInsets.all(6.0),
            //         child: SizedBox(
            //           width: 27.w,
            //           child: ElevatedButton(
            //             style: ElevatedButton.styleFrom(
            //               elevation: 8.0,
            //               backgroundColor: selectedIndex == index
            //                   ? Color(0xff1d1a56)
            //                   : Colors.white,
            //               foregroundColor: selectedIndex == index
            //                   ? Colors.white
            //                   : Color(0xff1d1a56),
            //             ),
            //             child: Text('${_strDate[index]}',
            //                 style: TextStyle(
            //                     fontSize: 11.sp, fontWeight: FontWeight.bold)),
            //             onPressed: () {
            //               setState(() {
            //                 selectedIndex = index;
            //                 pickUpTime = _strDate[index];
            //               });
            //             },
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            Padding(
                padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Text('Remark', style: myTextStyleHeader[phoneSize])),
            Padding(
              padding:
                  EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 8.0),
              child: TextFormField(
                minLines: 1,
                maxLines: 5,
                controller: _textEditingController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Please leave a message, if there is.',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildItem(item, index) {
    return InkWell(
      child: Card(
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
                          image:
                              imageFromBase64String(jsonDecode(item['image'])),
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
                                "${item['name']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: myTextStyleHeader[phoneSize],
                              )),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "X ${item['amount']}",
                              style: myTextStyleBody[phoneSize],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                      flex: 0,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              "\$${f.format(item['lst_price'] * item['amount'])}",
                              style: myTextStyleBody[phoneSize])))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // _buildUrlImages(String urlImage) {
  //   return Container(
  //     color: Colors.white,
  //     child: CachedNetworkImage(
  //       height: 12.h,
  //       width: 12.h,
  //       imageUrl: urlImage,
  //       imageBuilder: (context, imageProvider) => Container(
  //         decoration: BoxDecoration(
  //           image: DecorationImage(
  //             image: imageProvider,
  //             fit: BoxFit.cover,
  //           ),
  //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //           boxShadow: [
  //             BoxShadow(blurRadius: 5, color: Colors.grey, offset: Offset(1, 3))
  //           ],
  //         ),
  //       ),
  //       placeholder: (context, url) => Icon(
  //         Icons.photo_library_outlined,
  //         size: SizerUtil.deviceType == DeviceType.tablet ? 40.sp : 50.sp,
  //         color: Colors.grey.shade400,
  //       ),
  //       errorWidget: (context, url, error) =>
  //           Image.asset("assets/icons/login_icon/logo_with_radius.png"),
  //     ),
  //   );
  // }

  void _createOrder(
      {required List<Map<String, dynamic>> lines,
      required double amountPaid,
      required String pickUp,
      required String comment,
      required double topUpAmount,
      required String statePreOrder}) async {
    EasyLoading.show(status: 'Loading');
    await posCreateOrder(
            lines: lines,
            amountPaid: amountPaid,
            pickUp: pickUp,
            comment: comment,
            topUpAmount: topUpAmount,
            statePreOrder: statePreOrder,
            imageEncode: '',
            type: 'prepaid')
        .then((value) {
      try {
        print('value-message=${value.message}');
        if (value.message == "Success") {
          EasyLoading.showSuccess('${value.description}',
              duration: Duration(seconds: 5));
          Get.back(result: true);
        } else if (value.message == "Session Closed") {
          EasyLoading.showInfo('${value.description}',
              duration: Duration(seconds: 5));
        } else if (value.message == "Balance") {
          EasyLoading.showInfo('${value.description}',
              duration: Duration(seconds: 5));
        } else if (value.message == "Purchase Limit") {
          EasyLoading.showInfo('${value.description}',
              duration: Duration(seconds: 5));
        } else {
          EasyLoading.showInfo(
              'Your Order is not complete.\nPlease Try again!!!',
              duration: Duration(seconds: 5));
        }
        setState(() {
          _isDisableButton = false;
        });
        EasyLoading.dismiss();
      } catch (err) {
        setState(() {
          _isDisableButton = false;
        });
        EasyLoading.dismiss();
        Get.defaultDialog(
          title: "Error",
          middleText: "$value",
          barrierDismissible: true,
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

  bool timeCheck() {
    bool diff = true;
    DateTime now = new DateTime.now();
    String formattedDateTimeNow = DateFormat('y-MM-dd kk:mm').format(now);
    String formattedDateNow = DateFormat('y-MM-dd').format(now);
    DateTime dt = DateTime.parse(formattedDateTimeNow);
    DateTime dtFrom = DateTime.parse(
        "$formattedDateNow ${storage.read("pre_order_time_from")}");
    DateTime dtTo = DateTime.parse(
        "$formattedDateNow ${storage.read("pre_order_time_to")}");
    bool diffBefore = dt.isBefore(dtFrom);
    bool diffAfter = dt.isAfter(dtTo);

    // print("diffBefore=$diffBefore");
    // print("diffAfter=$diffAfter");
    if (!diffBefore && !diffAfter) // Ex: can order from 10:00 to 12:00
      diff = false;
    return diff;
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

  static MemoryImage imageFromBase64String(String base64String) {
    return MemoryImage(base64Decode(base64String));
  }
}
