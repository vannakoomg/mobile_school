// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:school/models/eLearningCourseDB.dart';
// import 'package:school/repos/e_learning_course.dart';
// import 'package:school/screens/theme/theme.dart';
// import 'package:sizer/sizer.dart';
//
// class ELearningCoursePage extends StatefulWidget {
//   const ELearningCoursePage({Key? key}) : super(key: key);
//
//   @override
//   _ELearningCoursePageState createState() => _ELearningCoursePageState();
// }
//
// class _ELearningCoursePageState extends State<ELearningCoursePage> with TickerProviderStateMixin{
//   late TabController _tabController;
//   late List<ListElement> _eLearningCourseList = [];
//   late bool view;
//   late double iconSize;
//   late final PhoneSize phoneSize;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Contact Us"),
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Colors.white,
//           tabs: [
//             Tab(text: "Video",),
//             Tab(text: "Document",),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           Tab(
//             child: _videoList,
//           ),
//           Tab(
//             child: _documentList,
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     phoneSize = SizerUtil.deviceType == DeviceType.tablet ? PhoneSize.ipad : PhoneSize.iphone;
//     _fetchELearningCourse();
//     // view = true;
//     // iconSize = SizerUtil.deviceType == DeviceType.tablet ? 15.sp : 20.sp;
//     // _fetchELearningSubject();
//   }
//
//   get _videoList {
//     return Container(
//       child: ListView.builder(
//           itemCount: _eLearningCourseList.length,
//           itemBuilder: (BuildContext context,int index){
//             return InkWell(
//               child: Card(
//                 margin: EdgeInsets.all(5),
//                 elevation: 5,
//                 child: Column(
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(8),
//                       // height: 120,
//                       child: Row(
//                         children: [
//                           SizedBox(
//                             child: Image.network(
//                               'http://schoolapp.ics.edu.kh/e_learning/${_eLearningCourseList[index].image}',
//                               height: SizerUtil.deviceType == DeviceType.tablet ? 100 : 80,
//                               width: SizerUtil.deviceType == DeviceType.tablet ? 100 : 80,
//                             ),
//                           ),
//                           SizedBox(width: 8,),
//                           Expanded(
//                             child: SizedBox(
//                               width: 300,
//                               child: Column(
//                                 children: [
//                                   Container(
//                                       alignment: Alignment.centerLeft,
//                                       child: Text(
//                                         _eLearningCourseList[index].lesson,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                         textAlign: TextAlign.left,
//                                         style: myTextStyleHeader[phoneSize],
//                                       )
//                                   ),
//                                   Container(
//                                     alignment: Alignment.centerLeft,
//                                     child: Text(
//                                       _eLearningCourseList[index].teacher,
//                                       maxLines: 2,
//                                       overflow: TextOverflow.ellipsis,
//                                       style: myTextStyleBody[phoneSize],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 50,
//                             child: Icon(Icons.navigate_next),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ), onTap: (){
//               Get.toNamed('e_learning_detail');
//             },
//             );
//           }
//       ),
//     );
//   }
//
//   get _documentList {
//     return Container();
//   }
//
//
//   void _fetchELearningCourse() {
//     fetchELearningCourse().then((value) {
//       _eLearningCourseList.clear();
//       setState(() {
//         try {
//           // print("value.data.list=${value.data.list}");
//           _eLearningCourseList.addAll(value.data.list);
//         } catch (err) {
//           Get.defaultDialog(
//             title: "Error",
//             middleText: "$value",
//             barrierDismissible: false,
//             confirm: reloadBtn(),
//           );
//         }
//       });
//     });
//   }
//
//   Widget reloadBtn() {
//     return ElevatedButton(
//         onPressed: () {
//           Get.back();
//           _fetchELearningCourse();
//         },
//         child: Text("Reload"));
//   }
//
//   _buildListView(List<ListElement> items) {
//     return ListView.builder(
//         padding: EdgeInsets.all(8),
//         // controller: _scrollController,
//         // physics: AlwaysScrollableScrollPhysics(),
//         itemCount: items.length + 1,
//         itemBuilder: (context, index) {
//           return _buildItem(items[index]);
//         });
//   }
//
//   _buildItem(ListElement item) {
//     return InkWell(
//       child: Card(
//         elevation: 5,
//         child: Column(
//           children: [
//             // Container(
//             //   child: Text(
//             //     DateFormat('MMMM dd,yyyy | HH:mm:ss').format(item.postDate),style: myTextStyleBody[phoneSize],),
//             //   height: 30,
//             //   alignment: Alignment.center,
//             // ),
//             Container(
//               padding: EdgeInsets.all(8),
//               // height: 120,
//               child: Row(
//                 children: [
//                   SizedBox(
//                     child: Image.asset(
//                       'assets/icons/home_screen_icon/temp_image.png',
//                       height: SizerUtil.deviceType == DeviceType.tablet ? 100 : 80,
//                       width: SizerUtil.deviceType == DeviceType.tablet ? 100 : 80,
//                     ),
//                   ),
//                   SizedBox(width: 8,),
//                   Expanded(
//                     child: SizedBox(
//                       width: 300,
//                       child: Column(
//                         children: [
//                           Container(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 item.lesson,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 textAlign: TextAlign.left,
//                                 style: myTextStyleHeader[phoneSize],
//                               )
//                           ),
//                           Container(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               item.teacher,
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: myTextStyleBody[phoneSize],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 50,
//                     child: Icon(Icons.navigate_next),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//       onTap: (){
//         // Get.to(() => AnnouncementDetail(item: item,));
//       },
//     );
//   }
// }
