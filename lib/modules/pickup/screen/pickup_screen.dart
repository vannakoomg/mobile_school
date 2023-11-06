import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_document/my_files/init.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/pickup/controller/pickup_controller.dart';
import 'package:school/screens/pages/pick_up_card_page.dart';
import 'package:sizer/sizer.dart';

class PickUpCard extends StatefulWidget {
  const PickUpCard({Key? key}) : super(key: key);

  @override
  State<PickUpCard> createState() => _PickUpCardState();
}

class _PickUpCardState extends State<PickUpCard> {
  final controller = Get.put(PickUpController());
  Timer? timer;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick Up")),
      body: Obx(() => Container(
            child: Column(children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        Spacer(),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                              child: Text(
                            "M",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          )),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              curve: Curves.ease,
                              duration: Duration(seconds: 1),
                              margin: EdgeInsets.only(top: 20, bottom: 5),
                              height: 1,
                              width: controller.distan.value < 100
                                  ? ((100.w - 80) *
                                          (100 - controller.distan.value)) /
                                      100
                                  : 100.w - 80,
                              color: Colors.black,
                            ),
                            Text("${controller.distan.value.toInt()} m")
                          ],
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: Text("ICS")),
                        )
                      ]),
                      GestureDetector(
                        onTap: () {
                          debugPrint("pick up done");
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                              color: controller.distan.value > 100
                                  ? Colors.grey
                                  : AppColor.primary,
                              borderRadius: BorderRadius.circular(80)),
                          child: Center(
                              child: Text(
                            "Pick Up",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )),
                          margin: EdgeInsets.only(top: 100),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.to(ScanScreen());
                },
                child: Container(
                  height: 80,
                  color: AppColor.primary,
                  child: Center(
                      child: Text(
                    "Scan QR",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )),
                ),
              )
            ]),
          )),
    );
  }
}
