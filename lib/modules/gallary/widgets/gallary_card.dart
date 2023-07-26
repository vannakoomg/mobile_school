import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:sizer/sizer.dart';

import '../models/gallary_model.dart';

class GallaryCard extends StatelessWidget {
  final List<Gallary> listOfGallary;
  final String yearMonth;
  const GallaryCard({
    Key? key,
    required this.listOfGallary,
    required this.yearMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GallaryController());
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$yearMonth",
            style: TextStyle(
              color: AppColor.backgroundColor,
              fontWeight: FontWeight.bold,
              fontSize: SizerUtil.deviceType == DeviceType.tablet ? 22 : 14,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: listOfGallary.map((data) {
              return GestureDetector(
                onTap: () {
                  debugPrint("kkkkk ${data.id}");
                  Get.toNamed(
                    'gallary_datail',
                    arguments: {"id": "${data.id}", "title": data.title},
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        width: double.infinity,
                        height: 30.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: controller.getColor(),
                          image: DecorationImage(
                            image: NetworkImage(
                              "${data.image!}",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.5)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  child: Text(
                                    data.title!,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 18
                                          : 12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }
}
