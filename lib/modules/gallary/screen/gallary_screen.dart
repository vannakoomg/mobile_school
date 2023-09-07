import 'package:cached_network_image/cached_network_image.dart';
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
  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 10), () {
      controller.getGallary().then((value) => {controller.update()});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GallaryController>(
      builder: (controller) {
        return Scaffold(
            backgroundColor: AppColor.backgroundColor,
            appBar: AppBar(
              title: Text(
                "Gallary",
                style: TextStyle(
                  fontSize: SizerUtil.deviceType == DeviceType.tablet ? 24 : 16,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    controller.islist.value = !controller.islist.value;
                    controller.islist.refresh();
                    controller.update();
                  },
                  icon: Icon(
                      !controller.islist.value ? Icons.menu : Icons.list_alt),
                )
              ],
            ),
            body: controller.isloading.value
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.white,
                  ))
                : controller.gallary.value.data!.isEmpty
                    ? Center(
                        child: Text("No Gallary"),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20,
                              right: controller.islist.value ? 0 : 10,
                              left: 10),
                          child: !controller.islist.value
                              ? Wrap(
                                  children: controller.gallary.value.data!
                                      .map((data) {
                                    return GallaryCard(
                                        listOfGallary: data.gallary!,
                                        yearMonth: data.yearMonth!);
                                  }).toList(),
                                )
                              : Wrap(
                                  children: controller.gallary.value.data02!
                                      .map((data) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.toNamed(
                                          'gallary_datail',
                                          arguments: {
                                            "id": "${data.id}",
                                            "title": data.title
                                          },
                                        );
                                      },
                                      child: Container(
                                        width: (100.w - 10) / 3,
                                        padding: EdgeInsets.only(right: 5),
                                        margin: EdgeInsets.only(bottom: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              clipBehavior: Clip.antiAlias,
                                              width: double.infinity,
                                              height: 40.w,
                                              child: CachedNetworkImage(
                                                imageUrl: "${data.image!}",
                                                fit: BoxFit.cover,
                                              ),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: controller.getColor(),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              data.title!,
                                              style: TextStyle(
                                                color: AppColor.primaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    SizerUtil.deviceType ==
                                                            DeviceType.tablet
                                                        ? 18
                                                        : 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                        ),
                      ));
      },
    );
  }
}
