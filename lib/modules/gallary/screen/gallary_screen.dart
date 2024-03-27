import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:sizer/sizer.dart';
import '../widgets/gallary_card.dart';

class GallaryScreen extends StatefulWidget {
  const GallaryScreen({Key? key}) : super(key: key);

  @override
  State<GallaryScreen> createState() => _GallaryScreenState();
}

class _GallaryScreenState extends State<GallaryScreen> {
  final controller = Get.put(GallaryController());
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    controller.islist.value = false;
    controller.isloading.value;
    controller.galleryByMount.clear();
    controller.nectPageBymount.value = 0;
    controller.currentPageBymount.value = 1;
    Future.delayed(const Duration(milliseconds: 10), () {
      controller.getGallary().then((value) => {
            controller.update(),
            debugPrint("end scrooler ${controller.gallary.value.lastPage} "),
          });
    });
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        controller.nectPageBymount.value =
            controller.currentPageBymount.value + 1;
        debugPrint("end scrooler ${controller.nectPageBymount} ");
        if (controller.nectPageBymount.value <=
            controller.gallary.value.lastPage!) {
          debugPrint("fetch gallery ");
          controller.getGallary(page: controller.nectPageBymount.value);
          controller.currentPageBymount.value =
              controller.nectPageBymount.value;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GallaryController>(builder: (controller) {
      return Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              "Gallery",
              style: TextStyle(
                fontSize: SizerUtil.deviceType == DeviceType.tablet ? 24 : 16,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  controller.islist.value = !controller.islist.value;
                },
                child: Icon(
                    !controller.islist.value ? Icons.menu : Icons.list_alt),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          body: controller.isloading.value && controller.galleryByMount.isEmpty
              ? Center(
                  child: CircularProgressIndicator(
                  color: AppColor.primaryColor,
                ))
              : controller.galleryByMount.isEmpty
                  ? Center(
                      child: Text("No Gallery"),
                    )
                  : Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => controller.refreshIndicator(),
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: controller.galleryByMount.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      if (index == 0)
                                        SizedBox(
                                          height: 10,
                                        ),
                                      Container(
                                          // padding: EdgeInsets.only(top: 10),
                                          child: GallaryCard(
                                              isList: controller.islist.value,
                                              listOfGallary: controller
                                                  .galleryByMount[index]
                                                  .gallary!,
                                              yearMonth: controller
                                                  .galleryByMount[index]
                                                  .yearMonth!)),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          if (controller.isloading.value &&
                              controller.galleryByMount.isNotEmpty)
                            CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            )
                        ],
                      ),
                    ),
        ),
      );
    });
  }
}
