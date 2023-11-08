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
      controller.getGallary().then((value) => {
            controller.update(),
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GallaryController>(builder: (controller) {
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
              ),
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
                  : Container(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: ListView.builder(
                        itemCount: controller.gallary.value.data!.length,
                        itemBuilder: (context, index) {
                          return Container(
                              padding: EdgeInsets.only(top: 10),
                              child: GallaryCard(
                                  isList: controller.islist.value,
                                  listOfGallary: controller
                                      .gallary.value.data![index].gallary!,
                                  yearMonth: controller
                                      .gallary.value.data![index].yearMonth!));
                        },
                      )));
    });
  }
}
