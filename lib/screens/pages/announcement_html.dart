import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/models/AnnouncementDetailDB.dart';
import 'package:school/repos/announcement_detail.dart';
import 'package:school/screens/theme/theme.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AnnouncementHtml extends StatefulWidget {
  final String item;
  const AnnouncementHtml({Key? key, required this.item}) : super(key: key);

  @override
  _AnnouncementHtmlState createState() => _AnnouncementHtmlState();
}

class _AnnouncementHtmlState extends State<AnnouncementHtml> {
  late WebViewController controller;
  late String _item;
  late final PhoneSize phoneSize;
  late Data _announcementDetail;
  bool isLoading = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: _buildBody1,
    );
  }

  void _fetchAnnouncementDetail(String id) {
    fetchAnnouncementDetail(announcementID: '$id').then((value) {
      setState(() {
        try {
          print("value.data.data=${value.data}");
          _announcementDetail = value.data;
          isLoading = true;
        } catch (err) {
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

  @override
  void dispose() {
    super.dispose();
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          _fetchAnnouncementDetail(_item);
        },
        child: Text("Reload"));
  }

  get _buildBody1 {
    return !isLoading
        ? Center(child: CircularProgressIndicator())
        : WebView(
            javascriptMode: JavascriptMode.unrestricted,
            // initialUrl: 'http://schoolapp.ics.edu.kh/login',
            onWebViewCreated: (controller) {
              this.controller = controller;
              loadLocalHtml();
            },
          );
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _item = widget.item;
    _fetchAnnouncementDetail(_item);
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
  }

  void loadLocalHtml() async {
    final url = Uri.dataFromString(
      '''<!DOCTYPE html>
      <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- CSS only -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
      </head>
      <body style="margin: 0; padding: 0;">
        <img src="${_announcementDetail.fullImage}" class="img-responsive" alt="Responsive image" style="width: auto; width: 100%;">
        <div style="margin: 10px; padding: 0;">
        <h3 style="padding-top: 10px; color:#00008B;">${_announcementDetail.title}</h3>
        <div style="margin: 2px; color:#9AA5B1;"><span><i class="fa fa-calendar-o fa-lg"></i>&nbsp;&nbsp;${_announcementDetail.date}</span></div>
        <div style="margin: 2px; color:#9AA5B1;"><span><i class="fa fa-clock-o fa-lg"></i>&nbsp;&nbsp;${_announcementDetail.time}</span></div>
        <hr style="margin: 5px;"/>
          ${_announcementDetail.body}
      </div>
      </body>
    </html>''',
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    controller.loadUrl(url);
  }
}
