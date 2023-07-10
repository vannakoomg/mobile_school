import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:school/modules/gallary/widgets/gallary_card.dart';

class GallaryScreen extends StatefulWidget {
  const GallaryScreen({Key? key}) : super(key: key);

  @override
  State<GallaryScreen> createState() => _GallaryScreenState();
}

class _GallaryScreenState extends State<GallaryScreen> {
  final controller = Get.put(GallaryController());

  @override
  void initState() {
    controller.getGallary();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.primaryColor.withOpacity(1),
        appBar: AppBar(
          title: Text("Gallary"),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.only(right: 10),
          //     child: GestureDetector(
          //         onTap: () {
          //           controller.islist.value = !controller.islist.value;
          //         },
          //         child: controller.islist.value
          //             ? Icon(Icons.menu)
          //             : Icon(Icons.grid_on)),
          //   )
          // ],
        ),
        body: controller.isloading.value
            ? CircularProgressIndicator()
            : SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 20, left: 10, right: 10),
                  child: Column(
                      children: controller.gallary.value.data!.map((data) {
                    return GallaryCard(
                        listOfGallary: data.gallary!,
                        yearMonth: data.yearMonth!);
                  }).toList()),
                ),
              ),
      ),
    );
  }
}
