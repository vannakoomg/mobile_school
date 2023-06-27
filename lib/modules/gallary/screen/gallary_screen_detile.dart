import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:school/modules/gallary/screen/view_image.dart';

import '../widgets/image_card.dart';

class GallaryDetail extends StatelessWidget {
  const GallaryDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = Get.arguments;
    final controller = Get.put(GallaryController());
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: controller.listOfImage.length ~/ 2,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {},
              child: ImageCard(
                tag01: "${2 * (i + 1) - 1 - 1}",
                tag02: "${2 * (i + 1) - 1}",
                image01: controller.listOfImage[2 * (i + 1) - 1 - 1],
                image02: controller.listOfImage[2 * (i + 1) - 1],
                colors01: controller.getColor(),
                colors02: controller.getColor(),
                flex01: controller.getflex(),
                flex02: controller.getflex(),
                high: controller.getHigh(),
                ontap01: () {
                  controller.tagId.value = "${2 * (i + 1) - 1 - 1}";
                  debugPrint("tage id :${controller.tagId.value}");
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
    );
  }
}
