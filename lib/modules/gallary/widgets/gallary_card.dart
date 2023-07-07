import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$yearMonth",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: listOfGallary.map((data) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(
                    'gallary_datail',
                    arguments: {"id": data.id, "title": data.title},
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(left: 10, top: 10, right: 10),
                        width: double.infinity,
                        height: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                          image: DecorationImage(
                              image: NetworkImage(
                                "${data.image!}",
                              ),
                              fit: BoxFit.cover),
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
