import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:school/modules/gallary/screen/view_image.dart';
import '../../../utils/function/function.dart';
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
    controller.getGallaryDetail('${argument['id']}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text("${argument['title']}"),
        ),
        body: controller.isloadingGallaryDetail.value
            ? CircularProgressIndicator()
            : Container(
                child: ListView.builder(
                  itemCount: controller.gallaryDetail.value.data!.length ~/ 2,
                  itemBuilder: (context, i) {
                    return GestureDetector(
                      onTap: () {},
                      child: ImageCard(
                        tag01: "${2 * (i + 1) - 1 - 1}",
                        tag02: "${2 * (i + 1) - 1}",
                        image01: controller.gallaryDetail.value
                            .data![2 * (i + 1) - 1 - 1].image!,
                        image02: controller
                            .gallaryDetail.value.data![2 * (i + 1) - 1].image!,
                        colors01: controller.getColor(),
                        colors02: controller.getColor(),
                        flex01: Random().nextInt(3) + 1,
                        flex02: Random().nextInt(3) + 1,
                        high: getHigh(),
                        ontap01: () {
                          controller.tagId.value = "${2 * (i + 1) - 1 - 1}";
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
      ),
    );
  }
}
