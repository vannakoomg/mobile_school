import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            backgroundColor: Colors.white,
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
                              left: 10,
                              right: controller.islist.value ? 0 : 10),
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
                                        width: (100.w - 40) / 3,
                                        margin: EdgeInsets.only(
                                            bottom: 20, right: 10),
                                        child: Stack(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, top: 10, right: 10),
                                              width: double.infinity,
                                              height: 40.w,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: controller.getColor(),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    "${data.image!}",
                                                  ),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10,
                                                                right: 10,
                                                                top: 5,
                                                                bottom: 5),
                                                        child: Text(
                                                          data.title!,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: SizerUtil
                                                                        .deviceType ==
                                                                    DeviceType
                                                                        .tablet
                                                                ? 18
                                                                : 12,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                  ]),
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
