// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school/utils/widgets/custom_botton.dart';
import 'package:school/utils/widgets/custom_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html/dom.dart' as dom;

import '../../models/ABAQRDB.dart';
import '../../repos/aba.dart';
import '../../repos/image_repos.dart';
import '../../repos/pos_create_order.dart';
import '../../config/theme/theme.dart';

class TopUp extends StatefulWidget {
  const TopUp({Key? key}) : super(key: key);

  @override
  _TopUpState createState() => _TopUpState();
}

class _TopUpState extends State<TopUp> with TickerProviderStateMixin {
  late final PhoneSize phoneSize;
  late String device;
  final storage = GetStorage();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  late List<ABA> _recAbaData = [];
  late bool _isDisableButton = false;
  bool _isSelect = false;
  double _fontSize = 0;
  File? _file;
  List<Map<String, dynamic>> menu = [];
  DefaultCacheManager manager = new DefaultCacheManager();
  TextEditingController _textEditingController = TextEditingController();
  bool _validate = false;

  List<Map<String, dynamic>> lines = [];
  late Map<String, dynamic> value;
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

    _fetchABA();
    _tabController = TabController(length: 2, vsync: this);
    _fontSize = SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 11.sp;
    // menu = [
    //   {
    //     'amount': 20,
    //     'image': "${baseUrlSchool + 'ABA_20.jpg'}",
    //     'link':
    //         "https://link.payway.com.kh/aba?id=0B399F9E2E59&code=887909&acc=000223222&amount=20.0"
    //   },
    //   {
    //     'amount': 50,
    //     'image': "${baseUrlSchool + 'ABA_50.jpg'}",
    //     'link':
    //         "https://link.payway.com.kh/aba?id=0B399F9E2E59&code=080985&acc=000223222&amount=50.0"
    //   },
    //   {
    //     'amount': 100,
    //     'image': "${baseUrlSchool + 'ABA_100.jpg'}",
    //     'link':
    //         "https://link.payway.com.kh/aba?id=0B399F9E2E59&code=039859&acc=000223222&amount=100.0"
    //   }
    // ];

    manager.emptyCache();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  _buildHeader,
                  _buildBodyExtend,
                ],
              ),
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
            'assets/icons/canteen/top_up.png',
            height: 15.h,
            color: Colors.white,
          ),
          SizedBox(
            height: 2.h,
          ),
          Text(
            "Top Up",
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
        children: <Widget>[
          Material(
            elevation: 3,
            child: Container(
              alignment: Alignment.center,
              color: Colors.white,
              // constraints: BoxConstraints.expand(height: 8.h),
              child: TabBar(
                controller: _tabController,
                unselectedLabelColor: Color(0xff1d1a56),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Color(0xff1d1a56),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: Colors.redAccent,
                    border: Border.all(color: Color(0xff1d1a56))),
                tabs: [
                  Tab(
                    child: Text(
                      'Top Up',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: _fontSize),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'Instructions',
                      style: TextStyle(
                          fontWeight: FontWeight.w800, fontSize: _fontSize),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            // flex: 1,
            child: TabBarView(
              controller: _tabController,
              children: [tabTopUp, tabInfo],
            ),
          ),
        ],
      ),
    );
  }

  get tabInfo {
    return Scrollbar(
      thumbVisibility: true,
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Html(
            data: storage.read("instruction"),
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
              customLaunch(url);
              //open URL in webview, or launch URL in browser, or any other logic here
            },
            onImageError: (exception, stacktrace) {
              print(exception);
            },
          ),
        ),
      ),
    );
  }

  get tabTopUp {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            child: ListView.builder(
                controller: _scrollController,
                physics: PageScrollPhysics(),
                shrinkWrap: true,
                itemCount: _recAbaData.length,
                itemBuilder: (context, index) => Container(
                      child: _buildItem(_recAbaData[index]),
                    )),
          ),
        ),
        _file != null
            ? _buildButtonSubmit()
            : Container(
                color: Color(0xff1d1a56),
                height: 7.h,
                width: 100.w,
                child: CustomButton(
                  onTap: () {
                    _showImageSourceActionSheet;
                  },
                  title: "UPLOAD YOUR RECEIPT",
                ))
      ],
    );
  }

  _buildButtonSubmit() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 20.0),
          color: Colors.white,
          child: TextField(
            enabled: false,
            controller: _textEditingController,
            enableInteractiveSelection: false,
            maxLength: 5,
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
              labelText: 'Amount',
              hintText: '',
              errorText: _validate ? 'Message Can\'t Be Empty' : null,
              prefixIcon: Icon(Icons.currency_exchange_sharp),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          alignment: Alignment.center,
          height: 5.h,
          child: Card(
            child: Row(
              children: [
                InkWell(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    width: 85.w,
                    child: Text(
                      '${_file != null ? _file!.path.split("/").last : ''}',
                      style: TextStyle(
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 15.0
                              : 12.0,
                          decoration: TextDecoration.underline,
                          color: Colors.blueAccent),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  onTap: () {
                    if (_file != null) viewImage();
                  },
                ),
                Expanded(
                    child: InkWell(
                  child: Container(
                    child: Icon(Icons.close),
                    height: 100.h,
                  ),
                  onTap: () {
                    setState(() {
                      _file = null;
                      _isSelect = false;
                    });
                  },
                )),
              ],
            ),
          ),
        ),
        Container(
          color: Color(0xff1d1a56),
          height: 7.h,
          width: 100.w,
          child: CustomButton(
            onTap: () async {
              setState(() {
                _textEditingController.text.isEmpty
                    ? _validate = true
                    : _validate = false;
              });
              if (_textEditingController.text.isNotEmpty) {
                if (_isDisableButton == false) {
                  setState(() {
                    _isDisableButton = true;
                  });
                  value = {
                    "qty": 1,
                    "price_unit": _textEditingController.text,
                    "price_subtotal": _textEditingController.text,
                    "price_subtotal_incl": _textEditingController.text,
                    "product_id": storage.read("product_id"),
                    "line_id": 1
                  };
                  lines.add(value);
                  String image = await compressAndGetFile(_file!);
                  _createOrder(
                      lines: lines,
                      amountPaid: double.parse(_textEditingController.text),
                      pickUp: "",
                      comment: "Top Up",
                      topUpAmount: double.parse(_textEditingController.text),
                      statePreOrder: "draft",
                      imageEncode: image);
                }
              } else {
                message(title: "", body: "Please select amount");
              }
            },
            title: "SUBMIT",
          ),
        ),
      ],
    );
  }

  void _onClickImageGallery() async {
    File? file = await getImageNetwork();
    if (file != null) {
      setState(() {
        _file = file;
        _isSelect = true;
      });
    }
  }

  void _onClickCamera() async {
    File? file = await getImageNetwork(imageSource: ImageSource.camera);
    if (file != null) {
      setState(() {
        _file = file;
      });
    }
  }

  void viewImageLink({required String urlImage, required String link}) {
    showDialog(
        // constraints: BoxConstraints(maxHeight: 100.0),
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Container(
              color: Color(0xffdf1f25),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80.w,
                    child: FadeInImage(
                      image: NetworkImage(urlImage),
                      placeholder: AssetImage(
                        "assets/icons/canteen/red_color.png",
                      ),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/icons/canteen/red_color.png',
                          fit: BoxFit.fitWidth,
                          color: Color(0xffdf1f25),
                        );
                      },
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  InkWell(
                    onTap: () => customLaunch(link),
                    child: Container(
                      alignment: Alignment.center,
                      height: 7.h,
                      width: 80.w,
                      color: Color(0xffdf1f25),
                      child: Text('Link to ABA',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 9.sp
                                      : 11.sp)),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  void viewImage() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
                width: 80.w,
                // height: 60.h,
                child: Image.file(
                  _file!,
                  // fit: BoxFit.cover,
                )),
          );
        });
  }

  get _showImageSourceActionSheet {
    Get.bottomSheet(Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0)),
      ),
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          ListTile(
            leading: Icon(Icons.camera),
            title: Text('Use camera'),
            onTap: () {
              Get.back();
              _onClickCamera();
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Select photo'),
            onTap: () {
              Get.back();
              _onClickImageGallery();
            },
          ),
        ],
      ),
    ));
  }

  _buildItem(ABA menu) {
    return InkWell(
      onTap: () {
        if (!_isSelect) _textEditingController.text = "${menu.amount}";
        viewImageLink(urlImage: menu.image, link: menu.link);
        _textEditingController.text = "${menu.amount}";
      },
      child: Card(
        elevation: 5,
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(8),
            height: 8.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.currency_exchange,
                      color: Color(0xff1d1a56),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text('${menu.amount}', style: myTextStyleHeader[phoneSize]),
                  ],
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xff1d1a56),
                )
              ],
            )),
      ),
    );
  }

  void _createOrder(
      {required List<Map<String, dynamic>> lines,
      required double amountPaid,
      required String pickUp,
      required String comment,
      required double topUpAmount,
      required String statePreOrder,
      required String imageEncode}) async {
    if (_textEditingController.text.isEmpty) _isDisableButton = false;
    if (_textEditingController.text.isNotEmpty) {
      EasyLoading.show(status: 'Loading');
      await posCreateOrder(
              lines: lines,
              amountPaid: amountPaid,
              pickUp: pickUp,
              comment: comment,
              topUpAmount: topUpAmount,
              statePreOrder: statePreOrder,
              imageEncode: imageEncode,
              type: 'top_up')
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
          } else {
            EasyLoading.showInfo(
                'Your Order is not complete.\nPlease Try again!!!',
                duration: Duration(seconds: 5));
          }

          setState(() {
            _isDisableButton = false;
            // print("true");
          });
          EasyLoading.dismiss();
        } catch (err) {
          setState(() {
            _isDisableButton = false;
          });
          EasyLoading.dismiss();

          CustomDialog.error(
            title: "Error",
            message: "$value",
            context: context,
            barrierDismissible: true,
            ontap: () {
              Get.back();
              Navigator.of(context).pop();
            },
          );
        }
      });
    }
  }

  Future<void> _fetchABA() async {
    await fetchABA().then((value) {
      setState(() {
        try {
          _recAbaData.addAll(value.data);

          // isLoading = true;
        } catch (err) {
          CustomDialog.error(
            title: "Oops!",
            message: "Something went wrong.\nPlease try again later.",
            context: context,
            ontap: () {
              Get.back();
              Navigator.of(context).pop();
            },
          );
        }
      });
    });
  }

  Future<String> compressAndGetFile(File file) async {
    final dir = Directory.systemTemp;
    final targetPath = dir.absolute.path + "/temp.jpg";
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
    );

    var base64img = base64Encode(result!.readAsBytesSync());
    return base64img;
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
                width: 70.w,
                height: 15.h,
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('$body', style: myTextStyleHeader[phoneSize]),
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
