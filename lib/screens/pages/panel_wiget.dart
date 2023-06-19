// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:open_document/my_files/init.dart';
import 'package:school/repos/assignment_remove_file.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/AssignmentDetailDB.dart';
import '../../models/AssignmentFilesSubmitDB.dart';
import '../../repos/assignment_files_submit.dart';
import '../../repos/assignment_text_submit.dart';
import '../../repos/image_repos.dart';
import '../../config/theme/theme.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final bool isOpen;
  final AssignmentDetailDb recAssignedDetail;

  const PanelWidget(
      {Key? key,
      required this.controller,
      required this.panelController,
      required this.isOpen,
      required this.recAssignedDetail})
      : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  late bool _isOpen;
  TextEditingController _textEditingController = TextEditingController();
  List<Asset> images = [];
  File? _file;
  final _focusNodeAnswer = FocusNode();
  late AssignmentDetailDb _recAssignedDetail;
  DefaultCacheManager manager = new DefaultCacheManager();
  List<Datum> _data = [];
  List<Map<String, dynamic>> _mapAttachment = [];
  final storage = GetStorage();
  late final PhoneSize phoneSize;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    manager.emptyCache();
    // print("answer=${storage.read('answer')}");
    // storage.write('reloadAssignment', false);
    _recAssignedDetail = widget.recAssignedDetail;
    _isOpen = widget.isOpen;

    if (_recAssignedDetail.mResult.turnedin == "1") {
      if (storage.read('answer') == null)
        _textEditingController.text = _recAssignedDetail.mResult.remark;
      else
        _textEditingController.text = storage.read('answer');
    } else {
      _textEditingController.text = storage.read('answer') ?? '';
    }

    _recAssignedDetail.mResult.attachments.forEach((element) {
      // print("element.filename=${element.link}");
      _mapAttachment.add({
        'id': '${element.id}',
        'filename': element.filename,
        'link': element.link
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 1.h,
            ),
            buildDragHandle(),
            new Divider(
              color: Colors.grey.shade700,
            ),
            _buildTurnedIn,
            _recAssignedDetail.completed == 0 ? uploadButton() : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget uploadButton() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(
          horizontal: SizerUtil.deviceType == DeviceType.tablet ? 30.sp : 10,
          vertical: 10),
      child: ElevatedButton(
        onPressed: () {
          _assignmentTextSubmit(
              answer: _textEditingController.text,
              resultId: '${_recAssignedDetail.mResult.id}');
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
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
            _recAssignedDetail.mResult.turnedin == "1" ? 'RESUBMIT' : "SUBMIT",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizerUtil.deviceType == DeviceType.tablet ? 18 : 14),
          ),
        ),
      ),
    );
  }

  Widget buildDragHandle() {
    return GestureDetector(
      child: Container(
        // alignment: Alignment.topCenter,
        padding: EdgeInsets.only(left: 8, right: 8),
        height: 9.h,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Your Work', style: myTextStyleBody[phoneSize]),
            Container(
                alignment: Alignment.topCenter,
                height: 100.h,
                // color: Colors.red,
                child: FaIcon(
                  widget.isOpen
                      ? FontAwesomeIcons.chevronUp
                      : FontAwesomeIcons.chevronDown,
                  color: Colors.grey.shade700,
                )),
            (_recAssignedDetail.mResult.turnedin == "1" &&
                    _recAssignedDetail.mResult.mStatus == 'Done')
                ? Text('__/${_recAssignedDetail.marks}',
                    style: myTextStyleBody[phoneSize])
                : (_recAssignedDetail.mResult.turnedin == "1" &&
                        _recAssignedDetail.mResult.mStatus != 'Done')
                    ? Text('${_recAssignedDetail.mResult.mStatus}',
                        style: myTextStyleBody[phoneSize])
                    : Text('${_recAssignedDetail.mResult.mStatus}',
                        style: myTextStyleBody[phoneSize]),
          ],
        ),
      ),
      onTap: () {
        setState(() {
          // print("_isOpen=$_isOpen");
          if (!_isOpen) storage.write('answer', _textEditingController.text);
          _isOpen = !_isOpen;
        });
        togglePanel();
      },
    );
  }

  void togglePanel() {
    // print(widget.panelController.isPanelShown);
    _isOpen ? widget.panelController.close() : widget.panelController.open();
  }

  get _buildTurnedIn {
    return Column(
      children: [
        _recAssignedDetail.completed == 0
            ? Container(
                constraints: BoxConstraints(maxHeight: 30.h),
                padding: EdgeInsets.all(10),
                child: KeyboardActions(
                  // tapOutsideBehavior: TapOutsideBehavior.opaqueDismiss,
                  config: KeyboardActionsConfig(
                    keyboardSeparatorColor: Colors.purple,
                    actions: [
                      KeyboardActionsItem(
                        focusNode: _focusNodeAnswer,
                      ),
                    ],
                  ),
                  child: TextFormField(
                    // readOnly: _recAssignedDetail.completed == 0 ? false : true,
                    minLines: 8,
                    maxLines: 8,
                    controller: _textEditingController,
                    focusNode: _focusNodeAnswer,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: 'Enter answers here.',
                        hintStyle: TextStyle(color: Colors.grey),
                        // errorText: _validate ? 'Message Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    style: myTextStyleBody[phoneSize],
                  ),
                ),
              )
            : Container(
                child: Text('${_recAssignedDetail.mResult.remark}'),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(8.0),
              ),
        _recAssignedDetail.mResult.teacherComment != ""
            ? Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                alignment: Alignment.centerLeft,
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Comment',
                      style: myTextStyleHeader[phoneSize],
                    ),
                    Container(
                      width: 100.w,
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          border: Border.all(
                            color: Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Text(
                        '${_recAssignedDetail.mResult.teacherComment}',
                        style: myTextStyleBody[phoneSize],
                      ),
                    ),
                  ],
                ))
            : Container(),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          alignment: Alignment.centerLeft,
          child: InkWell(
            onTap: () => _recAssignedDetail.completed == 0
                ? _showImageSourceActionSheet
                : null,
            child: Row(
              children: [
                Text(
                  'Add Attach File ',
                  style: myTextStyleHeader[phoneSize],
                ),
                _recAssignedDetail.completed == 0
                    ? Icon(
                        Icons.add_box,
                        color: Color(0xff3f51b5),
                        // size: 20.sp,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _mapAttachment.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.all(5),
                // padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                height: 5.h,
                // color: Colors.white,
                child: Card(
                  child: Row(
                    children: [
                      InkWell(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          // color: Colors.red,
                          width: 85.w,
                          // height: 100.h,
                          child: Text(
                            _mapAttachment[index]['filename'],
                            style: TextStyle(
                                fontSize:
                                    SizerUtil.deviceType == DeviceType.tablet
                                        ? 15.0
                                        : 12.0,
                                decoration: TextDecoration.underline,
                                color: Colors.blueAccent),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        onTap: () async {
                          // _pushScreen();
                          initPlatformState(url: _mapAttachment[index]['link']);
                          // Navigator.of(context).push(
                          //   MaterialPageRoute<void>(
                          //     builder: (_) => FileViewPage(controller: FileViewController.network(_mapAttachment[index]['link'])),
                          //   ),
                          // );
                          // final name = await OpenDocument.getNameFile(url: _mapAttachment[index]['link']);
                          // _pushScreen();
                          // customLaunch(Uri.encodeFull(_mapAttachment[index]['link']));
                          // viewImage(_mapAttachment[index]['link']);
                        },
                      ),
                      Expanded(
                          child: InkWell(
                        child: Container(
                          child: _recAssignedDetail.completed == 0
                              ? Icon(Icons.close)
                              : SizedBox(),
                          // color: Colors.blue,
                          height: 100.h,
                        ),
                        onTap: () {
                          if (_recAssignedDetail.completed == 0) {}
                          _assignmentRemoveFile(
                              attachmentId: _mapAttachment[index]['id'],
                              index: index);
                        },
                      )),
                    ],
                  ),
                ),
              );
            })
      ],
    );
  }

  void viewImage(String image) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            backgroundColor: Colors.transparent,
            content: InteractiveViewer(
              child: Container(
                  width: 80.w,
                  child: CachedNetworkImage(
                    imageUrl: image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Container(),
                  )),
            ),
          );
        });
  }

  void _assignmentTextSubmit(
      {required String answer, required String resultId}) async {
    EasyLoading.show(status: 'Loading');
    await assignmentTextSubmit(remark: answer, resultId: resultId)
        .then((value) {
      try {
        print("value==${value.status}");
        EasyLoading.showSuccess('Submitted');
        storage.write('reloadAssignment', true);
        EasyLoading.dismiss();
      } catch (err) {
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

  void _assignmentRemoveFile(
      {required String attachmentId, required int index}) async {
    EasyLoading.show(status: 'Loading');
    await assignmentRemoveFiles(attachmentId: attachmentId).then((value) {
      try {
        print("value==${value.status}");
        setState(() {
          _mapAttachment.removeAt(index);
        });
        // Get.back(result: 'testing');
        EasyLoading.showSuccess('Remove');
        EasyLoading.dismiss();
      } catch (err) {
        // setState(() {
        //   _isDisableButton = false;
        // });
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

  void _assignmentFilesSubmit(
      {required String resultId, String doc = 'Image'}) async {
    EasyLoading.show(status: 'Loading');
    await assignmentFilesSubmit(
      file: _file,
      resultId: resultId,
      doc: doc,
    ).then((value) {
      try {
        print("value==${value.status}");
        _data.addAll(value.data);
        setState(() {
          _mapAttachment.add({
            'id': '${_data.last.id}',
            'filename': _data.last.filename,
            'link': _data.last.link
          });
        });
        EasyLoading.showSuccess('Attached');
        EasyLoading.dismiss();
      } catch (err) {
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
        },
        child: Text("OK"));
  }

  void _onClickImageGallery() async {
    File? file = await getImageNetwork();
    if (file != null) {
      setState(() {
        _file = file;
        _assignmentFilesSubmit(resultId: '${_recAssignedDetail.mResult.id}');
      });
    }
  }

  void _onClickCamera() async {
    File? file = await getImageNetwork(imageSource: ImageSource.camera);
    if (file != null) {
      setState(() {
        _file = file;
        _assignmentFilesSubmit(resultId: '${_recAssignedDetail.mResult.id}');
      });
    }
  }

  void _getFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png',
        'pdf',
        'docx',
        'doc',
        'xlsx',
        'xls',
        'pptx',
        'ppt',
        'pub',
        'txt'
      ],
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // print("file=$file");
      _file = file;
      _assignmentFilesSubmit(
          resultId: '${_recAssignedDetail.mResult.id}', doc: 'File');
    } else {
      // User canceled the picker
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
          ListTile(
            leading: Icon(Icons.upload_sharp),
            title: Text('File'),
            onTap: () {
              Get.back();
              _getFile();
            },
          ),
        ],
      ),
    ));
  }

  Future<void> customLaunch(command) async {
    if (await canLaunch(command)) {
      await launch(command, forceSafariVC: false);
    } else {
      print(' could not launch $command');
    }
  }

  Future<void> initPlatformState({required String url}) async {
    String filePath;
    // final url =
    //     "https://fase.org.br/wp-content/uploads/2014/05/exemplo-de-pdf.pdf";
    //final url = "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-zip-file.zip";
    //
    // Platform messages may fail, so we use a try/catch PlatformException.
    //"https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_5000.xls";
    //"https://file-examples-com.github.io/uploads/2017/02/file_example_XLS_5000.xls";
    //"https://file-examples-com.github.io/uploads/2017/02/zip_10MB.zip";

    final name = await OpenDocument.getNameFile(url: url);

    final path = await OpenDocument.getPathDocument();

    filePath = "$path/$name";

    final isCheck = await OpenDocument.checkDocument(filePath: filePath);

    // debugPrint("Exist: $isCheck \nPath: $filePath");
    try {
      if (!isCheck) {
        filePath = await downloadFile(filePath: "$filePath", url: url);
      }
      await OpenDocument.openDocument(
        filePath: filePath,
      );
    } on OpenDocumentException {
      // debugPrint("ERROR: ${e.errorMessage}");
      filePath = 'Failed to get platform version.';
    }
  }

  Future<String> downloadFile(
      {required String filePath, required String url}) async {
    // CancelToken cancelToken = CancelToken();
    Dio dio = new Dio();
    await dio.download(
      url,
      filePath,
      onReceiveProgress: (count, total) {
        // debugPrint('---Download----Rec: $count, Total: $total');
        setState(() {});
      },
    );

    return filePath;
  }
}
