import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:school/utils/function/function.dart';
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
        width: 100.h,
        height: 100.w,
        child: Stack(
          children: [
            Container(
              color: AppColor.primaryColor,
              child: Hero(
                tag: controller.tagId.value,
                child: Container(
                  height: 100.h,
                  child: PageView(
                    // physics: NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      controller.urlImage.value =
                          controller.gallaryDetail.value.data![value].image!;
                      controller.tagId.value = "$value";
                      controller.scrllcontroller.value.animateTo(200,
                          duration: Duration(milliseconds: 100),
                          curve: Curves.ease);
                    },
                    controller: pageViewController,
                    children: controller.gallaryDetail.value.data!
                        .asMap()
                        .entries
                        .map((e) {
                      return GestureDetector(
                        onTap: () {
                          controller.isTapImage.value =
                              !controller.isTapImage.value;
                          controller.isTapSave.value = false;
                        },
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
                                    "https://images.lifestyleasia.com/wp-content/uploads/sites/5/2022/08/01134813/BLACKPINK-1-1600x898.jpeg",
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
            ),
            AnimatedPositioned(
              top: controller.isTapImage.value ? -80 : 0,
              left: 0,
              duration: Duration(milliseconds: 200),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: controller.isTapImage.value ? 0 : 1,
                child: Container(
                  padding: EdgeInsets.only(top: 20, right: 10),
                  height: 80,
                  width: 100.w,
                  color: AppColor.primaryColor.withOpacity(1),
                  child: Row(children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        )),
                    Spacer(),
                    Text(
                      "${int.parse(controller.tagId.value) + 1} / ${controller.gallaryDetail.value.data!.length}",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        controller.isTapSave.value =
                            !controller.isTapSave.value;
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Save",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
            AnimatedPositioned(
                duration: Duration(milliseconds: 250),
                bottom: controller.isTapSave.value ? 100 : 7.5.h,
                child: AnimatedOpacity(
                  opacity: controller.isTapSave.value ? 1 : 0,
                  duration: Duration(milliseconds: 250),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          downloadImage02(
                              // url:
                              //     "https://images.lifestyleasia.com/wp-content/uploads/sites/5/2022/08/01134813/BLACKPINK-1-1600x898.jpeg");
                              );
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 7.5.h,
                          width: 100.w - 40,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(70)),
                          child: Center(
                              child: Text(
                            "Save This Photo",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          for (int i = 0;
                              i < controller.listImage.length;
                              ++i) {
                            downloadImage(url: "${controller.listImage[i]}");
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 7.5.h,
                          width: 100.w - 40,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(70)),
                          child: Center(
                              child: Text(
                            "Save ${controller.gallaryDetail.value.data!.length} Photo",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15),
                          )),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
