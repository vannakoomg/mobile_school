// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_document/open_document.dart';
import 'package:open_document/open_document_exception.dart';
import 'package:school/screens/pages/panel_wiget.dart';
import 'package:school/utils/widgets/custom_dialog.dart';
import 'package:sizer/sizer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../models/AssignmentDetailDB.dart';
import '../../repos/assignment_detail.dart';
import 'package:html/dom.dart' as dom;
import '../../config/theme/theme.dart';

class HomeworkDetailPage extends StatefulWidget {
  final int assignmentId;

  const HomeworkDetailPage({Key? key, required this.assignmentId})
      : super(key: key);

  @override
  _HomeworkDetailPageState createState() => _HomeworkDetailPageState();
}

class _HomeworkDetailPageState extends State<HomeworkDetailPage>
    with TickerProviderStateMixin {
  DefaultCacheManager manager = new DefaultCacheManager();
  final panelController = PanelController();
  bool _isOpen = true;
  bool isLoading = false;
  late int _assignmentId;
  late AssignmentDetailDb _recAssignedDetail;
  late List<Attachment> _recAssignedAttachment = [];
  late WebViewController controller;
  late final PhoneSize phoneSize;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    manager.emptyCache();
    storage.remove('answer');
    _assignmentId = widget.assignmentId;
    _fetchAssignmentDetail('$_assignmentId');
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        title: Text("${isLoading ? _recAssignedDetail.name : ''}"),
      ),
      body: _buildTabAssignment,
    );
  }

  get _buildTabAssignment {
    return !isLoading
        ? Center(child: CircularProgressIndicator())
        : SlidingUpPanel(
            isDraggable: _isOpen,
            controller: panelController,
            maxHeight: 90.h,
            minHeight: 10.h,
            parallaxEnabled: true,
            parallaxOffset: .5,
            body: SingleChildScrollView(
              child: Container(
                // color: Colors.grey.withOpacity(0.2),
                child: Column(
                  children: [
                    _buildTitle,
                    _buildAssignment,
                    SizedBox(
                      height: 20.h,
                    ),
                  ],
                ),
              ),
            ),
            onPanelOpened: () {
              setState(() {
                // print("onPanelOpened");
                // _isDisabled[1] = true;
                _isOpen = false;
              });
            },
            onPanelClosed: () {
              setState(() {
                // _isDisabled[1] = false;
                // print("onPanelClosed");
                _fetchAssignmentDetailClose('$_assignmentId');
                _isOpen = true;
              });
            },
            panelBuilder: (controller) {
              var panelWidget = PanelWidget(
                controller: controller,
                panelController: panelController,
                isOpen: _isOpen,
                recAssignedDetail: _recAssignedDetail,
              );

              // print("panelWidget=${panelWidget.isOpen}");
              return panelWidget;
            },
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          );
  }

  void _fetchAssignmentDetail(String id) {
    fetchAssignmentDetail(id: '$id').then((value) {
      setState(() {
        try {
          print("value.data=${value.id}");
          _recAssignedDetail = value;
          _recAssignedAttachment.addAll(value.attachments);
          isLoading = true;
        } catch (err) {
          CustomDialog.error(
              title: "Error",
              message: "$value",
              context: context,
              barrierDismissible: true,
              bottonTitle: "Reload",
              ontap: () {
                Get.back();
                _fetchAssignmentDetail('$_assignmentId');
              });
        }
      });
    });
  }

  void _fetchAssignmentDetailClose(String id) {
    fetchAssignmentDetail(id: '$id').then((value) {
      setState(() {
        try {
          // print("value.data=${value.id}");
          _recAssignedDetail = value;
          // _recAssignedAttachment.addAll(value.attachments);
          // isLoading = true;
        } catch (err) {
          print("err==$err");
        }
      });
    });
  }

  get _buildTitle {
    return Container(
      height: 20.h,
      width: 100.w,
      decoration: BoxDecoration(
        color: Color(0xff3f51b5),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Text(
              'Due Date: ${_recAssignedDetail.mDuedate}',
              style: myTextStyleHeaderWhite[phoneSize],
            ),
            alignment: Alignment.center,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            height: 0.15.h,
            width: 100.w,
            color: Colors.white,
          ),
          Container(
            child: Text('${_recAssignedDetail.course.name}',
                style: myTextStyleHeaderWhite[phoneSize]),
            alignment: Alignment.center,
          ),
          // _space,
          Container(
            child: Text('Lecturer: ${_recAssignedDetail.mTeacher}',
                style: myTextStyleHeaderWhite[phoneSize]),
            alignment: Alignment.centerLeft,
          ),
          //_space,
          Container(
            child: Text('Class: ${_recAssignedDetail.mClassname}',
                style: myTextStyleHeaderWhite[phoneSize]),
            alignment: Alignment.centerLeft,
          ),
          Container(
            child: Text('Marks: ${_recAssignedDetail.marks}',
                style: myTextStyleHeaderAmberAccent[phoneSize]),
            alignment: Alignment.centerLeft,
          ),
        ],
      ),
    );
  }

  get _buildAssignmentWithAttached {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _recAssignedAttachment.length,
        itemBuilder: (BuildContext context, int index) {
          // print("link=${_recAssignedAttachment[index].link}");
          return InkWell(
            child: Card(
              child: Container(
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                height: 5.h,
                color: Colors.grey.shade100,
                child: Row(
                  children: [
                    Container(
                      width: SizerUtil.deviceType == DeviceType.tablet
                          ? 85.w
                          : 78.w,
                      child: Text(
                        _recAssignedAttachment[index].filename,
                        style: myTextStyleBodyBlue[phoneSize],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Icon(
                      Icons.open_in_new,
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              // customLaunch(Uri.encodeFull(_recAssignedAttachment[index].link));
              initPlatformState(url: _recAssignedAttachment[index].link);
            },
          );
        });
  }

  get _buildAssignment {
    // print("_recAssignedDetail.description=${_recAssignedDetail.description}");
    return Container(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      // margin: EdgeInsets.all(1),
      // color: Colors.green,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        // color: Colors.redAccent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Assignment   ',
                    style: myTextStyleHeader[phoneSize],
                  ),
                  Icon(
                    Icons.assignment,
                    color: Color(0xff3f51b5),
                  ),
                ],
              ),
            ),
            new Divider(
              color: Colors.grey.shade700,
            ),
            Html(
              data: _recAssignedDetail.description,
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
            _space,
            _recAssignedAttachment.length > 0
                ? Container(
                    // margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          'Attachment ',
                          style: myTextStyleHeader[phoneSize],
                        ),
                        Icon(
                          Icons.attachment,
                          color: Color(0xff3f51b5),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
            _buildAssignmentWithAttached,
            SizedBox(
              height: 10.h,
            ),
          ],
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

    setState(() {});
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

Widget get _space => const SizedBox(height: 10);
