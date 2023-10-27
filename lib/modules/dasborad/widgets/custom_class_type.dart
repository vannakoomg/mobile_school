import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:school/config/app_colors.dart';

class CustomClassType extends StatefulWidget {
  final String iamge;
  final String title;
  final String subTitle;
  final Function ontap;
  const CustomClassType(
      {Key? key,
      required this.iamge,
      required this.title,
      required this.subTitle,
      required this.ontap})
      : super(key: key);

  @override
  State<CustomClassType> createState() => _CustomClassTypeState();
}

bool ishover = false;

class _CustomClassTypeState extends State<CustomClassType> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      margin: EdgeInsets.only(left: 1, right: 1),
      decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
              image: NetworkImage(widget.iamge), fit: BoxFit.cover)),
      height: MediaQuery.of(context).size.width / 3 - 1,
      child: GestureDetector(
        onTap: () {
          widget.ontap();
        },
        child: AnimatedContainer(
          curve: Curves.easeIn,
          padding: EdgeInsets.only(left: 20, right: 20),
          duration: Duration(milliseconds: 200),
          color: ishover
              ? AppColor.primaryColor.withOpacity(0.8)
              : AppColor.primaryColor.withOpacity(0.4),
          child: MouseRegion(
            onEnter: (value) {
              setState(() {
                ishover = true;
              });
            },
            onExit: (value) {
              setState(() {
                ishover = false;
              });
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.title}",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.subTitle}",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 22),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    width: 140,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange, width: 2),
                      color: ishover
                          ? Colors.orange
                          : Colors.white.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      "Lean More",
                      style: TextStyle(
                          color: ishover ? Colors.white : Colors.orange,
                          fontWeight: FontWeight.w500),
                    )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
