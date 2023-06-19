import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:school/repos/pos_set_purchase_limit.dart';
import 'package:sizer/sizer.dart';

import '../theme/theme.dart';

class LimitPurchase extends StatefulWidget {
  const LimitPurchase({Key? key}) : super(key: key);

  @override
  _LimitPurchaseState createState() => _LimitPurchaseState();
}

class _LimitPurchaseState extends State<LimitPurchase> {
  TextEditingController _textEditingController = TextEditingController();
  late final PhoneSize phoneSize;
  late String device;
  final storage = GetStorage();
  late bool _isDisableButton = false;
  var f = NumberFormat("##0.00", "en_US");

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

    // print("sdfs=${storage.read("purchase_limit")}");
    if (storage.read("purchase_limit") == 0.0)
      _textEditingController.text = "";
    else
      _textEditingController.text =
          "${f.format(storage.read("purchase_limit"))}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        // appBar: AppBar(title: Text("Top Up"),),
        body: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  _buildHeader,
                  _buildBodyExtend,
                  // _buildBodyListExtend
                ],
              ),
              // _buildBalanceCard,
              _buildCloseButton,
            ],
          ),
        ),
      ),
    );
  }

  get _buildCloseButton {
    return Positioned(
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
    );
  }

  get _buildHeader {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 100.w,
      height: 30.h,
      color: Color(0xff1d1a56),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/canteen/limit_purchase.png',
            height: 15.h,
            color: Colors.white,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Daily Purchase Limit",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize:
                    SizerUtil.deviceType == DeviceType.tablet ? 16.sp : 18.sp),
          ),
        ],
      ),
    );
  }

  get _buildBodyExtend {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
            color: Colors.white,
            child: TextField(
              controller: _textEditingController,
              enableInteractiveSelection: false,
              // maxLength: 5,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9]+[,.]{0,1}[0-9]*')),
                TextInputFormatter.withFunction(
                  (oldValue, newValue) => newValue.copyWith(
                    text: newValue.text.replaceAll(',', '.'),
                  ),
                ),
              ],

              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(),
                labelText: _textEditingController.text.isEmpty
                    ? 'Unlimited'
                    : 'Maximum purchase amount limit',
                hintText: '',
                prefixIcon: Icon(Icons.currency_exchange_sharp),
              ),
            ),
          ),
          Container(
              color: Color(0xff1d1a56),
              height: 7.h,
              width: 100.w,
              child: ElevatedButton(
                onPressed: () {
                  var value = _textEditingController.text.isNotEmpty
                      ? double.parse(_textEditingController.text)
                      : 0.0;
                  // print("value=$value");
                  if (!_isDisableButton)
                    _setPurchaseLimit(purchaseLimit: value);
                  // if(_isDisableButton == false){
                  //   setState(() {
                  //     _isDisableButton = true;
                  //   });
                  //   var value = _textEditingController.text.isNotEmpty ? double.parse(_textEditingController.text) : 0.0;
                  //   print("value=$value");
                  //   // _setPurchaseLimit(purchaseLimit: value);
                  // }
                },
                child: Text('SAVE'),
              ))
        ],
      ),
    );
  }

  void _setPurchaseLimit({required double purchaseLimit}) async {
    // if(_textEditingController.text.isEmpty)
    //   _isDisableButton = false;
    _isDisableButton = true;
    EasyLoading.show(status: 'Loading');
    await posPurchaseLimit(purchaseLimit: purchaseLimit).then((value) {
      setState(() {
        try {
          print('value-message=${value.message}');
          if (value.message == true) {
            EasyLoading.showSuccess('Saved');
            Get.back(result: true);
          }
          _isDisableButton = false;
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
    });
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("OK"));
  }
}
