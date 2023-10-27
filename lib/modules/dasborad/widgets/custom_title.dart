import 'package:flutter/material.dart';
import 'package:gallery_saver/files.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/utils/widgets/selecte_text.dart';

class CustomTitle extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final bool imageFirst;
  const CustomTitle(
      {Key? key,
      required this.title,
      required this.subTitle,
      required this.image,
      required this.imageFirst})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          imageFirst ? EdgeInsets.only(right: 40) : EdgeInsets.only(left: 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imageFirst)
            Expanded(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 5,
                  width: MediaQuery.of(context).size.width / 3,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                            "$image",
                          ),
                          fit: BoxFit.fill)),
                ),
              ),
            ),
          Expanded(
            child: Container(
              margin: !imageFirst
                  ? EdgeInsets.only(right: 20)
                  : EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SelectableText(
                    '$title',
                    style: GoogleFonts.getFont('Roboto',
                        fontSize: 34,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primaryColor),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SelectableText(
                    '$subTitle',
                    style: GoogleFonts.getFont('Lato',
                        fontSize: 19,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.65)),
                  ),
                ],
              ),
            ),
          ),
          if (!imageFirst)
            Expanded(
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.width / 5,
                  width: MediaQuery.of(context).size.width / 3,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(
                            "$image",
                          ),
                          fit: BoxFit.fill)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
