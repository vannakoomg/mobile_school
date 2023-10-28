// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:school/config/app_colors.dart';
import 'package:school/modules/dasborad/controller/dashborad_controller.dart';
import 'package:school/modules/dasborad/widgets/card_title.dart';
import 'package:school/modules/dasborad/widgets/custom_class_type.dart';
import 'package:school/modules/dasborad/widgets/custom_contact.dart';
import 'package:school/modules/dasborad/widgets/custom_title.dart';
import 'package:school/modules/dasborad/widgets/style.dart';
import 'package:url_launcher/url_launcher.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final controller = Get.put(DashboardController());
  final ScrollController scrollerController = ScrollController();

  @override
  void initState() {
    controller.animatedController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    scrollerController.addListener(() {
      // Future.delayed(Duration(milliseconds: 200), () {
      //   controller.scrollPixel.value = scrollerController.offset;
      // });
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => Container(
            color: Colors.white,
            child: Stack(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: AppColor.primaryColor,
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/logo.svg",
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Home of High Achievers",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.getFont('Merriweather',
                                  color: Colors.white, fontSize: 22),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomContact(
                                    image: "assets/dashboard/telegram.svg",
                                    ontap: () async {
                                      debugPrint("KHmer khmekrekr");
                                      const url = 'https://flutter.io';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                      // js.context.callMethod(
                                      //     'open', ['https://stackoverflow.com']);

                                      // final Uri url =
                                      //     Uri.parse('https://flutter.dev');
                                      // if (!await launchUrl(url)) {
                                      //   throw Exception('Could not launch $url');
                                      // }
                                    }),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomContact(
                                    image: "assets/dashboard/facebook.svg",
                                    ontap: () {}),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomContact(
                                    image: "assets/dashboard/youtub.svg",
                                    ontap: () {}),
                                SizedBox(
                                  width: 10,
                                ),
                                CustomContact(
                                    image: "assets/dashboard/instargram.svg",
                                    ontap: () {}),
                              ],
                            ),
                            SizedBox(
                              height: 60,
                            ),
                            Text(
                              "ICS School is an independent, college preparatory, coeducational boarding and day school for students in grades 1-12 and postgraduate",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 17),
                            ),
                          ]),
                    ),
                    Text(
                      "Copyright  2023 ICS International School.  All Rights Reserved.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
              SingleChildScrollView(
                controller: scrollerController,
                child: Container(
                  child: Column(
                    children: [
                      // Container(
                      //   padding: EdgeInsets.only(left: 20),
                      //   height: 70,
                      //   color: Colors.white,
                      //   child: Row(
                      //     children: [
                      //       Expanded(
                      //           flex: 2,
                      //           child: Row(
                      //             children: [
                      //               SvgPicture.asset("assets/logo.svg"),
                      //             ],
                      //           )),
                      //     ],
                      //   ),
                      // ),
                      Container(
                        color: Colors.white,
                        child: Column(children: [
                          Container(
                            child: Column(
                              children: [
                                Image.network(
                                  "https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/343408128_1588789444950165_953376270099143187_n.jpg?_nc_cat=100&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeE1Gr28066ZrCz6AKKTYuYOpp3y-DU6xK2mnfL4NTrErRUOSGZfkC9WPoG2yUch8axA6hnDyWaXeX2h2129e6Kn&_nc_ohc=jUPnIB0cNRQAX8Ihxe7&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfDcV7_G4coqTm03Tj0uDS3-R8ELbweQ6uHlnKBJsgQuEA&oe=653FE28C",
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.width / 2.5,
                                  fit: BoxFit.fill,
                                ),
                                SizedBox(
                                  height: 100,
                                ),
                                CustomTitle(
                                    title:
                                        "Private International School in Phnom Penh With Cambridge Curriculum",
                                    subTitle:
                                        "Invictus International School Phnom Penh offers private international education from Early Years (Kindergarten) through to Year 13. The school is located in central Phnom Penh and is equipped with modern learning facilities and qualified educators who are experienced in delivering holistic English curricula to cultivate international learners. French and Chinese are offered as additional languages from Reception through to Cambridge A-Levels.",
                                    image:
                                        "https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/368239670_683660400460386_8136182567574491745_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEDSzGC9d75RN7AKLdsTJOiWRnyqMxt64pZGfKozG3risC6LiJv9uWVOzyeO_xXSiuQIWcGZpWG0f1oTEIpY4mg&_nc_ohc=tSMMP1I7W1AAX9NCy6-&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfCrU7NVQfMfRCU1lYBUkYhF6q3aj0IS-b4etG5vW-zCqQ&oe=6540E0DA",
                                    imageFirst: true),
                                SizedBox(
                                  height: 40,
                                ),
                                CustomTitle(
                                    title:
                                        "Private International School in Phnom Penh With Cambridge Curriculum",
                                    subTitle:
                                        "Invictus International School Phnom Penh offers private international education from Early Years (Kindergarten) through to Year 13. The school is located in central Phnom Penh and is equipped with modern learning facilities and qualified educators who are experienced in delivering holistic English curricula to cultivate international learners. French and Chinese are offered as additional languages from Reception through to Cambridge A-Levels.",
                                    image:
                                        "https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/386995711_713971207429305_294402202910423810_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEYpOJ-KCFmfveL79nL0GxmmBc0T-Jx1H-YFzRP4nHUf2HHwi9ZPA0UOd79FUKMHEIfxJj_CIklDZsgurQk2Y2V&_nc_ohc=Unugzxj2bh8AX_wgrLb&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfDG3ysfTSFiYuRNhOhF2gZ8r53R51_EEQdkoX9JkVWlOQ&oe=653FCF44",
                                    imageFirst: false),
                                SizedBox(
                                  height: 40,
                                ),
                                CustomTitle(
                                    title:
                                        "Private International School in Phnom Penh With Cambridge Curriculum",
                                    subTitle:
                                        "Invictus International School Phnom Penh offers private international education from Early Years (Kindergarten) through to Year 13. The school is located in central Phnom Penh and is equipped with modern learning facilities and qualified educators who are experienced in delivering holistic English curricula to cultivate international learners. French and Chinese are offered as additional languages from Reception through to Cambridge A-Levels.",
                                    image:
                                        "https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/386995711_713971207429305_294402202910423810_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeEYpOJ-KCFmfveL79nL0GxmmBc0T-Jx1H-YFzRP4nHUf2HHwi9ZPA0UOd79FUKMHEIfxJj_CIklDZsgurQk2Y2V&_nc_ohc=Unugzxj2bh8AX_wgrLb&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfDG3ysfTSFiYuRNhOhF2gZ8r53R51_EEQdkoX9JkVWlOQ&oe=653FCF44",
                                    imageFirst: true),
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 60),
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            child: CustomPaint(
                              size:
                                  Size(MediaQuery.of(context).size.width, 700),
                              painter: RPSCustomPainter(),
                              child: Container(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CustomCardTitle(
                                            descrtion: "Campuses",
                                            title: "2",
                                          ),
                                          CustomCardTitle(
                                            descrtion: "Nationalities",
                                            title: "3",
                                          ),
                                          CustomCardTitle(
                                            descrtion: "student",
                                            title: "1000 +",
                                          ),
                                          CustomCardTitle(
                                            descrtion: "teacher",
                                            title: "100 +",
                                          )
                                        ]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ),
                      Container(
                        child: Row(children: [
                          CustomClassType(
                            iamge:
                                'https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/361095156_661808992645527_9110966978413085742_n.jpg?_nc_cat=102&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeH7YPc3fp_bRic-6mjXTZ67hiuBv-KBpD-GK4G_4oGkP6-2zc6T582nktyZ7I39Y0j3heji_LMSHX3KgZxvjCP9&_nc_ohc=jbDKJRuhHt0AX897QrG&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfABkGcJ-2Zx0ONW1Dozb3NXPSMgh8PKy52DRLb6_1l7LA&oe=653E9D99',
                            title: 'Primary',
                            subTitle: 'Age 5-11',
                            ontap: () {},
                          ),
                          CustomClassType(
                            iamge:
                                'https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/364055082_673804864779273_1469968374578706045_n.jpg?_nc_cat=108&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGuxcpP1RgPL9jmyfEqkmpurItI6IxpOmusi0jojGk6a-b1RqqgTj_BtnV64tvQGsoqz56Qak-cGwjUxHrQopcl&_nc_ohc=dOmU2ZXyzgQAX93_wSy&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfAlxSTy27fdx8wfFupU5xMtDwfNFee20lojtFIM2CNyTQ&oe=653EF1B7',
                            title: 'Screeoo',
                            subTitle: 'Age 12-14',
                            ontap: () {},
                          ),
                          CustomClassType(
                            iamge:
                                'https://scontent.fpnh24-1.fna.fbcdn.net/v/t39.30808-6/364051537_673798084779951_7907194626722596781_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=5f2048&_nc_eui2=AeGWVkc_fAfV65_aKz09FynXkaCp_uOQcHaRoKn-45Bwdr_Vs9Ei4C2clRmeMJpRxkdS_2yjbszIUyrpobJl7PaG&_nc_ohc=hBqiiobWX6MAX-S45pW&_nc_ht=scontent.fpnh24-1.fna&oh=00_AfBrHtTsHItAZMC9YNfQciT1ZEFEIu4oABmqS_mVj0YNJA&oe=653F0087',
                            title: 'High School',
                            subTitle: '15-18',
                            ontap: () {},
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedPositioned(
                right: controller.isShowMore.value
                    ? -MediaQuery.of(context).size.width
                    : 10,
                top: controller.isShowMore.value
                    ? -MediaQuery.of(context).size.height
                    : 10,
                duration: Duration(milliseconds: 400),
                child: GestureDetector(
                  onTap: () {
                    controller.handleOnPressed();

                    controller.isShowMore.value = !controller.isShowMore.value;
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    height: controller.isShowMore.value
                        ? MediaQuery.of(context).size.height * 3
                        : 50,
                    width: controller.isShowMore.value
                        ? MediaQuery.of(context).size.width * 3
                        : 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      color: AppColor.primaryColor.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    controller.handleOnPressed();

                    controller.isShowMore.value = !controller.isShowMore.value;
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: null),
                    child: Center(
                        child: AnimatedIcon(
                      icon: AnimatedIcons.menu_close,
                      color: Colors.white,
                      progress: controller.animatedController!,
                    )),
                  ),
                ),
              ),
              if (controller.scrollPixel.value > 20)
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      debugPrint("dddddd");
                      scrollerController.animateTo(0,
                          duration: Duration(seconds: 1), curve: Curves.ease);
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: AppColor.primaryColor),
                      child: Center(
                          child: Icon(
                        Icons.arrow_upward_outlined,
                        color: Colors.white,
                      )),
                    ),
                  ),
                )
            ]),
          )),
    );
  }
}
