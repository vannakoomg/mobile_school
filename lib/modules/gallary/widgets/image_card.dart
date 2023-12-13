import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final double high;
  final int flex01;
  final int flex02;
  final Color colors01;
  final Color colors02;
  final String image01;
  final String image02;
  final String tag01;
  final String tag02;
  final Function ontap01;
  final Function ontap02;
  const ImageCard({
    Key? key,
    required this.high,
    required this.flex01,
    required this.tag01,
    required this.tag02,
    required this.flex02,
    required this.colors01,
    required this.colors02,
    required this.image01,
    this.image02 = "",
    required this.ontap01,
    required this.ontap02,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: high,
      child: Row(
        children: [
          Expanded(
            flex: flex01,
            child: Hero(
              tag: "$tag01",
              child: GestureDetector(
                onTap: () {
                  ontap01();
                },
                child: Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: colors01,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: CachedNetworkImageProvider("$image01"),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          if (image02 != '')
            Expanded(
              flex: flex02,
              child: Hero(
                tag: "$tag02",
                child: GestureDetector(
                  onTap: () {
                    ontap02();
                  },
                  child: Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),

                      color: colors02,
                      // borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(image02),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
