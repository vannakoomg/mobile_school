import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:sizer/sizer.dart';

class Viewimage extends StatefulWidget {
  const Viewimage({Key? key}) : super(key: key);

  @override
  State<Viewimage> createState() => _ViewimageState();
}

class _ViewimageState extends State<Viewimage> {
  final controller = Get.put(GallaryController());
  final _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  void _handleDoubleTap() {
    setState(() {
      debugPrint("okokok");
      if (_transformationController.value != Matrix4.identity()) {
        _transformationController.value = Matrix4.identity();
      } else {
        final position = _doubleTapDetails!.localPosition;
        _transformationController.value = Matrix4.identity()
          ..translate(-position.dx * 2, -position.dy * 2)
          ..scale(3.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController pageViewController =
        PageController(initialPage: int.parse(controller.tagId.value));
    return Obx(
      () => Container(
        color: AppColor.primaryColor,
        // margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            // Spacer(),
            // Row(
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         Get.back();
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(5),
            //         decoration: BoxDecoration(
            //             shape: BoxShape.circle, color: Color(0XFFdee2e6)),
            //         child: Center(
            //           child: Icon(
            //             Icons.close,
            //             size: 20,
            //             color: Colors.black.withOpacity(0.5),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Spacer(),
            //     GestureDetector(
            //       onTap: () {
            //         downloadImage(url: controller.urlImage.value);
            //       },
            //       child: Container(
            //         padding: EdgeInsets.all(5),
            //         decoration: BoxDecoration(
            //             shape: BoxShape.circle, color: Color(0XFFdee2e6)),
            //         child: Center(
            //           child: Icon(
            //             Icons.download_rounded,
            //             size: 20,
            //             color: Colors.black.withOpacity(0.5),
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Hero(
              tag: controller.tagId.value,
              child: Container(
                height: 100.h,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  onPageChanged: (value) {
                    controller.urlImage.value =
                        controller.gallaryDetail.value.data![value].image!;
                    controller.tagId.value = "$value";
                  },
                  controller: pageViewController,
                  children: controller.gallaryDetail.value.data!
                      .asMap()
                      .entries
                      .map((e) {
                    return GestureDetector(
                      onDoubleTapDown: (d) => _doubleTapDetails = d,
                      onDoubleTap: _handleDoubleTap,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        child: Container(
                          // height: 500,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image: NetworkImage(
                                  "https://lh3.googleusercontent.com/XQw8genSC_U7estWtZ3jCHRkovpxiIchI86miUmYz5qC3B7ilN3x-93xRid9gTLOKlkYPfDwKe8G41ynZ1XKrdSy7WYo3w0njmQ0JFYJNt67r_Hy=w960-rj-nu-e365",
                                ),
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
