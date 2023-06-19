import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class ELearningPage extends StatefulWidget {
  const ELearningPage({Key? key}) : super(key: key);

  @override
  _ELearningPageState createState() => _ELearningPageState();
}

class _ELearningPageState extends State<ELearningPage> {
  List<Map<String, dynamic>> _menu = [
    {
      'category': 'Video',
      'icon': 'assets/icons/home_screen_icon_one_color/icon_video.png',
      'route': 'e_learning_subject'
    },
    {
      'category': 'Document',
      'icon': 'assets/icons/home_screen_icon_one_color/icon_document.png',
      'route': 'e_learning_subject'
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Learning"),
      ),
      body: _buildBody,
    );
  }

  get _buildBody {
    return Container(
      // margin: EdgeInsets.only(top: 3.h),
      padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 2.h),
      color: Colors.grey.shade100,
      child: GridView.builder(
        itemCount: _menu.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Get.toNamed(_menu[index]['route'],
                  arguments: _menu[index]['category']);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 10,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 10.h,
                    child: Image.asset(_menu[index]['icon']),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    _menu[index]['category'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: SizerUtil.deviceType == DeviceType.tablet ? 3 : 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 1.h,
            mainAxisSpacing: 1.h),
      ),
    );
  }
}
