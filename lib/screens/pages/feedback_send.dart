import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:school/repos/feedback.dart';
import 'package:school/repos/image_repos.dart';
import 'package:school/screens/theme/theme.dart';
import 'package:sizer/sizer.dart';

class FeedbackSendPage extends StatefulWidget {
  final List<String> sortFilter;

  const FeedbackSendPage({Key? key, required this.sortFilter})
      : super(key: key);

  @override
  _FeedbackSendPageState createState() => _FeedbackSendPageState();
}

class _FeedbackSendPageState extends State<FeedbackSendPage> {
  File? _file;
  final picker = ImagePicker();
  late final PhoneSize phoneSize = PhoneSize.iphone;
  TextEditingController _textEditingController = TextEditingController();
  final storage = GetStorage();
  String? _value;
  bool _validate = false;
  dynamic selectedValue = 'Other';
  late bool _isDisableButton = false;
  final _focusNodeFeedback = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Feedback"),
        ),
        body: _buildBody,
      ),
    );
  }

  void _sendFeedback() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _textEditingController.text.isEmpty
          ? _validate = true
          : _validate = false;
    });
    if (_textEditingController.text.isEmpty) _isDisableButton = false;
    if (_textEditingController.text.isNotEmpty) {
      EasyLoading.show(status: 'Loading');
      await sendFeedback(
              file: _file,
              category: _value ?? 'Other',
              question: _textEditingController.text)
          .then((value) {
        try {
          print('value=${value.status}');
          EasyLoading.showSuccess('Thank You for the Feedback');
          Get.back(result: true);
          setState(() {
            _textEditingController.text = '';
            _value = 'Other';
            _file = null;
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
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
        },
        child: Text("Reload"));
  }

  get _buildBody {
    return SingleChildScrollView(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              openDialog();
            },
            child: Container(
                height: 7.h,
                width: 100.w,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff1d1a56)),
                ),
                // width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _value ?? 'Other',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1d1a56)),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xff1d1a56),
                      ),
                    ],
                  ),
                )),
          ),
          Container(
            constraints: BoxConstraints(maxHeight: 45.h),
            padding: EdgeInsets.all(8),
            child: KeyboardActions(
              config: KeyboardActionsConfig(
                keyboardSeparatorColor: Colors.purple,
                actions: [
                  KeyboardActionsItem(
                    focusNode: _focusNodeFeedback,
                  ),
                ],
              ),
              child: TextFormField(
                // textInputAction: TextInputAction.newline,
                focusNode: _focusNodeFeedback,
                controller: _textEditingController,
                minLines: 13,
                maxLines: 17,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                    hintText: 'Enter a message here.',
                    hintStyle: TextStyle(color: Colors.grey),
                    errorText: _validate ? 'Message Can\'t Be Empty' : null,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)))),
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(8),
              child: InkWell(
                onTap: () => _showImageSourceActionSheet,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Add Attach file',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xff3f51b5)),
                        ),
                        Icon(
                          Icons.add_box,
                          color: Color(0xff3f51b5),
                          size: 20.sp,
                        ),
                      ],
                    ),
                    InkWell(
                      child: Text(
                        '${_file != null ? _file!.path.split("/").last : ''}',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.blueAccent),
                      ),
                      onTap: () {
                        if (_file != null) viewImage();
                      },
                    )
                  ],
                ),
              )),
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.symmetric(
                horizontal:
                    SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 10,
                vertical: 10),
            child: ElevatedButton(
              onPressed: () {
                if (_isDisableButton == false) {
                  setState(() {
                    _isDisableButton = true;
                  });
                  _sendFeedback();
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  // side: BorderSide(color: Colors.red)
                )),
              ),
              child: Container(
                alignment: Alignment.center,
                height: SizerUtil.deviceType == DeviceType.tablet ? 60.0 : 50.0,
                width: 100.w,
                decoration: new BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: new LinearGradient(
                      colors: [Color(0xff1a237e), Colors.lightBlueAccent],
                    )),
                padding: const EdgeInsets.all(0),
                child: Text(
                  "FEEDBACK",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize:
                          SizerUtil.deviceType == DeviceType.tablet ? 18 : 14),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void openDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            content: Container(
                width: 70.w,
                height: 40.h,
                child: Column(
                  children: [
                    Text('Category'),
                    Divider(
                      color: Colors.blueGrey,
                      height: 1.h,
                      thickness: 0.2.h,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (ctx, index) {
                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              selectedValue = widget.sortFilter[index];
                              Navigator.pop(context);
                              setState(() {
                                _value = widget.sortFilter[index];
                              });
                            },
                            child: Container(
                              color: selectedValue == widget.sortFilter[index]
                                  ? Colors.green[100]
                                  : null,
                              child: Row(
                                children: <Widget>[
                                  Radio(
                                      value: widget.sortFilter[index],
                                      groupValue: selectedValue,
                                      onChanged: (s) {
                                        selectedValue = s;
                                      }),
                                  Text(widget.sortFilter[index])
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: widget.sortFilter.length,
                      ),
                    )
                  ],
                )),
          );
        });
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
                  fit: BoxFit.cover,
                )),
          );
        });
  }

  void _onClickImageGallery() async {
    File? file = await getImageNetwork();
    if (file != null) {
      setState(() {
        print("file=$file");
        _file = file;
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
            title: Text('Camera'),
            onTap: () {
              Get.back();
              _onClickCamera();
            },
          ),
          ListTile(
            leading: Icon(Icons.image),
            title: Text('Gallery'),
            onTap: () {
              Get.back();
              _onClickImageGallery();
            },
          ),
        ],
      ),
    ));
  }
}
