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
    controller.gallaryData.clear();
    controller.nextPage.value = 0;
    controller.currentPage.value = 1;
    controller.hight.clear();
    controller.flex01.clear();
    controller.flex02.clear();
    Future.delayed(const Duration(milliseconds: 10), () {
      controller.getGallaryDetail(id: '${argument['id']}');
      controller.highList.clear();
    });
    controller.scrllcontroller.value.addListener(() {
      if (controller.scrllcontroller.value.position.pixels ==
          controller.scrllcontroller.value.position.maxScrollExtent) {
        controller.nextPage.value = controller.currentPage.value + 1;
        if (controller.nextPage.value >
            controller.gallaryDetail.value.lastPage!.toInt()) {}
        if (controller.nextPage.value <=
            controller.gallaryDetail.value.lastPage!.toInt())
          controller.getGallaryDetail(
              id: '${argument['id']}', page: controller.nextPage.value);
        controller.currentPage.value = controller.nextPage.value;
      }
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
        body: controller.isloadingGallaryDetail.value &&
                controller.gallaryData.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                color: AppColor.primaryColor,
              ))
            : Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      key: controller.textKey,
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      child: Text(
                        "${controller.gallaryDetail.value.description}",
                        style: TextStyle(
                          color: AppColor.primaryColor.withOpacity(0.8),
                          fontSize: SizerUtil.deviceType == DeviceType.tablet
                              ? 20
                              : 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        physics: AlwaysScrollableScrollPhysics(),
                        controller: controller.scrllcontroller.value,
                        itemCount: controller.gallaryData.length ~/ 2,
                        itemBuilder: (context, i) {
                          return Container(
                            child: ImageCard(
                              tag01: "${2 * (i + 1) - 1 - 1}",
                              tag02: "${2 * (i + 1) - 1}",
                              image01: controller
                                  .gallaryData[2 * (i + 1) - 1 - 1].image!,
                              image02: controller
                                  .gallaryData[2 * (i + 1) - 1].image!,
                              colors01: controller.getColor(),
                              colors02: controller.getColor(),
                              flex01: controller.flex01[i],
                              flex02: controller.flex02[i],
                              high: controller.hight[i],
                              ontap01: () {
                                controller.tagId.value =
                                    "${2 * (i + 1) - 1 - 1}";
                                controller.gallaryDataView.clear();
                                for (int i = 0;
                                    i < controller.gallaryData.length;
                                    ++i) {
                                  debugPrint(
                                      "image : ${controller.gallaryData[i].image}");
                                  if (controller.gallaryData[i].image != "")
                                    controller.gallaryDataView
                                        .add(controller.gallaryData[i]);
                                }
                                debugPrint(
                                    "image : ${controller.gallaryDataView.length}");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Viewimage(),
                                  ),
                                );
                              },
                              ontap02: () {
                                controller.tagId.value = "${2 * (i + 1) - 1}";
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Viewimage(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    if (controller.isloadingGallaryDetail.value &&
                        controller.gallaryData.isNotEmpty)
                      Container(
                        height: 30,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      )
                  ],
                ),
              ),
      ),
    );
  }
}
