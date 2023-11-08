import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:school/modules/gallary/models/gallary_detail_model.dart';
import 'package:sizer/sizer.dart';

class Viewimage extends StatefulWidget {
  const Viewimage({Key? key}) : super(key: key);

  @override
  State<Viewimage> createState() => _ViewimageState();
}

class _ViewimageState extends State<Viewimage>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(GallaryController());
  TransformationController? transcontroller;
  AnimationController? animatedController;
  Animation<Matrix4>? animation;
  final double minScale = 1;
  final double maxScale = 4;
  @override
  void initState() {
    super.initState();
    transcontroller = TransformationController();
    controller.urlImage.value =
        "${controller.gallaryData[int.parse(controller.tagId.value)].image}";
    animatedController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() => transcontroller!.value = animation!.value);
  }

  @override
  void dispose() {
    transcontroller!.dispose();
    animatedController!.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    PageController pageViewController =
        PageController(initialPage: int.parse(controller.tagId.value));
    return Obx(
      () => Container(
        color: AppColor.primaryColor,
        child: SafeArea(
          child: Container(
            color: Colors.grey.withOpacity(0.2),
            width: 100.h,
            height: 100.w,
            child: Stack(
              children: [
                GestureDetector(
                  child: Container(
                    color: AppColor.backgroundColor,
                    child: Hero(
                      tag: controller.tagId.value,
                      child: Container(
                        height: 100.h,
                        child: PageView(
                          onPageChanged: (value) {
                            controller.urlImage.value =
                                controller.gallaryDataView[value].image!;
                            controller.tagId.value = "$value";
                            double jumpScrll = 0;
                            for (int j = 0; j < (value) ~/ 2; ++j) {
                              jumpScrll = jumpScrll + controller.highList[j];
                            }
                            jumpScrll = jumpScrll;
                            controller.scrllcontroller.value.jumpTo(jumpScrll);
                          },
                          controller: pageViewController,
                          children: controller.gallaryDataView
                              .asMap()
                              .entries
                              .map((e) {
                            return GestureDetector(
                              onTap: () {
                                controller.isTapImage.value =
                                    !controller.isTapImage.value;
                                controller.isTapSave.value = false;
                              },
                              onDoubleTap: () {
                                if (controller.isTapImage.value == false &&
                                    controller.isTapSave.value) {
                                  controller.isTapSave.value = false;
                                  controller.isTapImage.value = true;
                                } else {
                                  controller.isTapSave.value = true;
                                  controller.isTapImage.value = false;
                                }
                              },
                              child: InteractiveViewer(
                                transformationController: transcontroller,
                                onInteractionEnd: (value) {
                                  debugPrint("b sl soy ");
                                  reset();
                                },
                                maxScale: 5,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage("${e.value.image}"),
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
                ),
                AnimatedPositioned(
                  top: controller.isTapImage.value ? -80 : 0,
                  left: 0,
                  duration: Duration(milliseconds: 200),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: controller.isTapImage.value ? 0 : 1,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(right: 10),
                      height: 60,
                      width: 100.w,
                      color: AppColor.primaryColor,
                      child: Row(children: [
                        IconButton(
                            onPressed: () {
                              controller.isTapSave.value = false;
                              Get.back();
                            },
                            icon: Icon(
                              Icons.close,
                              size: SizerUtil.deviceType == DeviceType.tablet
                                  ? 33
                                  : 22,
                              color: Colors.white,
                            )),
                        Spacer(),
                        Text(
                          "${int.parse(controller.tagId.value) + 1} / ${controller.gallaryDataView.length}",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  SizerUtil.deviceType == DeviceType.tablet
                                      ? 22
                                      : 16),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            controller.isTapSave.value =
                                !controller.isTapSave.value;
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 40,
                            child: Center(
                              child: Icon(
                                Icons.download,
                                color: Colors.white,
                              ),
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
                          onTap: () async {
                            controller.saveThisPhoto();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            width: 100.w - 40,
                            decoration: BoxDecoration(
                                color: Color(0xff1f487e).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(70)),
                            child: Center(
                                child: Text(
                              "Download Photo",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 22
                                          : 15),
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () async {
                            controller.saveAllPhoto();
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            width: 100.w - 40,
                            decoration: BoxDecoration(
                                color: Color(0xff1f487e).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(70)),
                            child: Center(
                                child: Text(
                              "Download All Photos (${controller.gallaryData.length})",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      SizerUtil.deviceType == DeviceType.tablet
                                          ? 20
                                          : 15),
                            )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                if (controller.imageSave.value > 0)
                  Positioned(
                    bottom: 00,
                    child: Container(
                      padding: EdgeInsets.only(left: 20),
                      height: 40,
                      width: 100.w,
                      color: controller.saveDone.value
                          ? Colors.blue
                          : AppColor.primaryColor,
                      child: Row(children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white)),
                          child: Center(
                              child: Text("${controller.imageSave.value}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12))),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          controller.saveDone.value
                              ? "Done"
                              : "Downloading ...",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        )
                      ]),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void reset() {
    animation = Matrix4Tween(
      begin: transcontroller!.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animatedController!, curve: Curves.ease));
    animatedController!.forward(from: 0);
  }
}
