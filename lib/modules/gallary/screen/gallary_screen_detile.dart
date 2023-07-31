import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:school/modules/gallary/screen/view_image.dart';
import 'package:sizer/sizer.dart';
import '../widgets/image_card.dart';

class GallaryDetail extends StatefulWidget {
  const GallaryDetail({Key? key}) : super(key: key);
  @override
  State<GallaryDetail> createState() => _GallaryDetailState();
}

class _GallaryDetailState extends State<GallaryDetail> {
  final controller = Get.put(GallaryController());

  final argument = Get.arguments;
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      controller.getGallaryDetail('${argument['id']}');
      controller.highList.clear();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.backgroundColor,
        appBar: AppBar(
          title: Text(
            "${argument['title']}",
            style: TextStyle(
              fontSize: SizerUtil.deviceType == DeviceType.tablet ? 24 : 16,
            ),
          ),
        ),
        body: controller.isloadingGallaryDetail.value
            ? Center(
                child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ))
            : Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: SingleChildScrollView(
                  controller: controller.scrllcontroller.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Text(
                          "${controller.gallaryDetail.value.description}",
                          key: controller.textKey,
                          style: TextStyle(
                            color: AppColor.primaryColor.withOpacity(0.8),
                            fontSize: SizerUtil.deviceType == DeviceType.tablet
                                ? 20
                                : 16,
                          ),
                        ),
                      ),
                      for (int i = 0;
                          i < controller.gallaryDetail.value.data!.length ~/ 2;
                          ++i)
                        ImageCard(
                          tag01: "${2 * (i + 1) - 1 - 1}",
                          tag02: "${2 * (i + 1) - 1}",
                          image01: controller.gallaryDetail.value
                              .data![2 * (i + 1) - 1 - 1].image!,
                          image02: controller.gallaryDetail.value
                              .data![2 * (i + 1) - 1].image!,
                          colors01: controller.getColor(),
                          colors02: controller.getColor(),
                          flex01: Random().nextInt(3) + 2,
                          flex02: Random().nextInt(3) + 2,
                          high: controller.getHigh(),
                          ontap01: () {
                            controller.tagId.value = "${2 * (i + 1) - 1 - 1}";
                            if (controller
                                    .gallaryDetail.value.data!.last.image ==
                                '') {
                              controller.gallaryDetail.value.data!.removeLast();
                            }
                            debugPrint(
                                "vannak ${controller.textKey.currentContext!.size!.height}");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Viewimage(),
                              ),
                              // PageRouteBuilder(
                              //   pageBuilder:
                              //       (context, animation1, animation2) =>
                              //           Viewimage(),
                              //     transitionsBuilder: (context, animation, secondaryAnimation, child) => ,
                              // ),
                            );
                          },
                          ontap02: () {
                            controller.tagId.value = "${2 * (i + 1) - 1}";
                            if (controller
                                    .gallaryDetail.value.data!.last.image ==
                                '') {
                              controller.gallaryDetail.value.data!.removeLast();
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Viewimage(),
                              ),
                              // PageRouteBuilder(
                              //   pageBuilder:
                              //       (context, animation1, animation2) =>
                              //           Viewimage(),
                              //   transitionDuration: Duration.zero,
                              //   reverseTransitionDuration: Duration.zero,
                              // ),
                            );
                          },
                        ),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
