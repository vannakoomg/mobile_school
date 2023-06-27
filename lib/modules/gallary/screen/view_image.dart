import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';

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
      () => Center(
        child: Hero(
          tag: controller.tagId.value,
          child: Container(
            height: 500,
            child: PageView(
              onPageChanged: (value) {
                controller.tagId.value = "$value";
              },
              controller: pageViewController,
              children: controller.listOfImage.asMap().entries.map((e) {
                return Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
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
      ),
    );
  }
}
