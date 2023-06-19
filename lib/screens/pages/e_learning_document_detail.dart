import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/theme/theme.dart';
import 'package:school/models/eLearningCourseDB.dart';
import 'package:school/repos/e_learning_course.dart';
import 'package:school/screens/widgets/pdf_api.dart';
import 'package:school/screens/widgets/pdf_viewer_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ELearningDocumentDetail extends StatefulWidget {
  final String id, name;
  const ELearningDocumentDetail(
      {Key? key, required this.id, required this.name})
      : super(key: key);

  @override
  _ELearningDocumentDetailState createState() =>
      _ELearningDocumentDetailState();
}

class _ELearningDocumentDetailState extends State<ELearningDocumentDetail> {
  ScrollController _scrollController = ScrollController();
  late List<Datum> _eLearningCourseList = [];
  late final PhoneSize phoneSize;
  int _page = 1;
  bool isMoreLoading = true;
  bool isFirstLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: _buildBody,
    );
  }

  @override
  void initState() {
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;

    _firstLoad();
    _scrollController.addListener(() {
      if (!isFirstLoading) {
        setState(() {
          isMoreLoading = true;
          isFirstLoading = true;
        });
      }
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          isMoreLoading) {
        fetchELearningCourse(
                pageNo: (++_page).toString(),
                courseId: widget.id,
                category: 'document')
            .then((value) {
          setState(() {
            value.data.nextPageUrl == null
                ? isMoreLoading = false
                : isMoreLoading = true;
            _eLearningCourseList.addAll(value.data.data);
          });
        });
      }
    });
    super.initState();
  }

  get _buildBody {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          isMoreLoading = true;
          _page = 1;
          _firstLoad();
        });
      },
      child: Container(
        alignment: Alignment.center,
        child: _buildListView(_eLearningCourseList),
      ),
    );
  }

  void _firstLoad() {
    fetchELearningCourse(courseId: widget.id, category: 'document')
        .then((value) {
      _eLearningCourseList.clear();
      setState(() {
        try {
          print("value.data.list=${value.data.data}");
          _eLearningCourseList.addAll(value.data.data);
          isFirstLoading = false;
          isMoreLoading = false;
        } catch (err) {
          isMoreLoading = false;
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

  _buildListView(List<Datum> items) {
    return ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return _buildProgressIndicator();
          } else {
            return _buildItem(items[index], index);
          }
        });
  }

  _buildItem(Datum item, int index) {
    return Card(
      margin: EdgeInsets.all(5),
      elevation: 5,
      child: ListTile(
        title: Text("${index + 1}. ${item.description}",
            style: myTextStyleBody[phoneSize]),
        onTap: () {
          _pdfView(item.url);
        },
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isMoreLoading ? 1.0 : 00,
          child: Shimmer.fromColors(
            child: ListTile(
              leading: Icon(
                Icons.image,
                size: 50.0,
              ),
              title: SizedBox(
                child: Container(
                  color: Colors.grey.shade300,
                ),
                height: 10,
              ),
              subtitle: SizedBox(
                child: Container(
                  color: Colors.grey.shade300,
                ),
                height: 10,
              ),
            ),
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
          ),
        ),
      ),
    );
  }

  void _pdfView(String url) async {
    final file = await PDFApi.loadNetwork(url);
    openPDF(context, file);
  }

  void openPDF(BuildContext context, File file) => Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file)),
      );

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          _firstLoad();
        },
        child: Text("Reload"));
  }
}
