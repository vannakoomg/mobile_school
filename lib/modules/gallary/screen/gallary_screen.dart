import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:school/modules/gallary/widgets/gallary_card.dart';

class GallaryScreen extends StatelessWidget {
  const GallaryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GallaryController());
    return Obx(
      () => Scaffold(
        backgroundColor: AppColor.primaryColor.withOpacity(1),
        appBar: AppBar(
          title: Text("Gallary"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: GestureDetector(
                  onTap: () {
                    controller.islist.value = !controller.islist.value;
                  },
                  child: controller.islist.value
                      ? Icon(Icons.menu)
                      : Icon(Icons.grid_on)),
            )
          ],
        ),
        body: Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: controller.islist.value ? 3 : 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: controller.islist.value ? 150 : 180,
            ),
            children: [
              GallaryCard(
                islist: controller.islist.value,
                title: "Trip to Parri",
                image:
                    "https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Hibbing_High_School_2014.jpg/1200px-Hibbing_High_School_2014.jpg",
                ontapp: () {
                  debugPrint("ddd");
                  Get.toNamed('gallary_datail', arguments: "Trip to Parri");
                },
              ),
              GallaryCard(
                islist: controller.islist.value,
                title: "Good action",
                image:
                    "https://gdb.voanews.com/51CB82F4-70B8-4886-B9BC-D0E58469D0E4_cx0_cy6_cw0_w1200_r1.jpg",
                ontapp: () {},
              ),
              GallaryCard(
                islist: controller.islist.value,
                title: "School",
                image:
                    "https://www.kark.com/wp-content/uploads/sites/85/2021/02/classroom_1542034403442_61914801_ver1.0.jpg?strip=1",
                ontapp: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
