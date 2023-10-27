// ignore_for_file: deprecated_member_use

import 'dart:html';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:school/config/app_colors.dart';

class CustomContact extends StatefulWidget {
  final String image;
  final Function ontap;
  const CustomContact({Key? key, required this.image, required this.ontap})
      : super(key: key);

  @override
  State<CustomContact> createState() => _CustomContactState();
}

class _CustomContactState extends State<CustomContact> {
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          isHover = false;
        });
      },
      child: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: isHover ? Colors.white : AppColor.primaryColor,
              border: Border.all(
                width: 0.5,
                color: Colors.white,
              ),
              shape: BoxShape.circle),
          child: Center(
            child: SvgPicture.asset(
              "${widget.image}",
              color: isHover ? AppColor.primaryColor : Colors.white,
              height: 30,
              width: 30,
            ),
          )),
    );
  }
}
