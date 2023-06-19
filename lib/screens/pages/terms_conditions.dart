// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import '../../config/theme/theme.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions>
    with TickerProviderStateMixin {
  late final PhoneSize phoneSize;
  late String device;
  final storage = GetStorage();

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            'assets/icons/canteen/term_condition.png',
            height: 15.h,
            color: Colors.white,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Terms & Conditions",
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
      child: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Html(
              data: storage.read("term_condition"),
              tagsList: Html.tags,
              style: {
                "body": Style(
                  fontSize: FontSize(
                    SizerUtil.deviceType == DeviceType.tablet ? 18.0 : 14.0,
                  ),
                  // fontWeight: FontWeight.bold,
                ),
                'html': Style(backgroundColor: Colors.white12),
                'table': Style(backgroundColor: Colors.grey.shade200),
                'td': Style(
                  backgroundColor: Colors.grey.shade400,
                  padding: EdgeInsets.all(10),
                ),
                'th': Style(padding: EdgeInsets.all(10), color: Colors.black),
                'tr': Style(
                    backgroundColor: Colors.grey.shade300,
                    border:
                        Border(bottom: BorderSide(color: Colors.greenAccent))),
              },
              onLinkTap: (String? url, RenderContext context,
                  Map<String, String> attributes, dom.Element? element) {
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
        ),
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
}
