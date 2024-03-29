import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/gallary/controller/gallary_controller.dart';
import 'package:sizer/sizer.dart';

import '../models/gallary_model.dart';

class GallaryCard extends StatelessWidget {
  final List<Gallary> listOfGallary;
  final String yearMonth;
  final isList;
  const GallaryCard({
    Key? key,
    required this.listOfGallary,
    required this.yearMonth,
    required this.isList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GallaryController());
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (yearMonth != "")
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "$yearMonth",
                  style: TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        SizerUtil.deviceType == DeviceType.tablet ? 22 : 14,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          isList == false
              ? Container(
                  // margin: EdgeInsets.only(bottom: 10),
                  child: Column(
                    children: listOfGallary.map((data) {
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
                          margin: EdgeInsets.only(bottom: 10),
                          clipBehavior: Clip.antiAlias,
                          width: double.infinity,
                          height: 50.w,
                          decoration: BoxDecoration(
                              color: controller.getColor(),
                              borderRadius: BorderRadius.circular(15)),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                height: 50.w,
                                width: 100.w,
                                imageUrl: "${data.image}",
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Container(),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.black.withOpacity(0.7)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 5, bottom: 5),
                                  child: Text(
                                    "${data.title!}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: SizerUtil.deviceType ==
                                              DeviceType.tablet
                                          ? 18
                                          : 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                )
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: listOfGallary.map((data) {
                    return GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          'gallary_datail',
                          arguments: {
                            "id": "${data.id}",
                            "title": data.title,
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(right: 10, bottom: 10),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          width: (100.w - 50) / 3,
                          height: 30.w + 30.w / 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.getColor(),
                          ),
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                height: 30.h,
                                width: 100.w,
                                imageUrl: "${data.image}",
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Container(),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: 5, right: 5, top: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: Colors.black.withOpacity(0.7)),
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
                            ],
                          ),
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
