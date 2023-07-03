import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';

import '../../../utils/function/function.dart';

class Viewimage extends StatefulWidget {
  const Viewimage({Key? key}) : super(key: key);

  @override
  State<Viewimage> createState() => _ViewimageState();
}

class _ViewimageState extends State<Viewimage> {
  final controller = Get.put(GallaryController());

  @override
  Widget build(BuildContext context) {
    PageController pageViewController =
        PageController(initialPage: int.parse(controller.tagId.value));
    return Obx(
      () => Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          children: [
            Spacer(),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0XFFdee2e6)),
                    child: Center(
                      child: Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    downloadImage(url: controller.urlImage.value);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Color(0XFFdee2e6)),
                    child: Center(
                      child: Icon(
                        Icons.download_rounded,
                        size: 20,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Hero(
              tag: controller.tagId.value,
              child: Container(
                height: 500,
                child: PageView(
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
                    return Container(
                      height: 500,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                            image: NetworkImage(
                              "${e.value}",
                            ),
                            fit: BoxFit.cover),
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
