// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sizer/sizer.dart';
//
// class DatabaseManager {
//   final CollectionReference dataList =
//       FirebaseFirestore.instance.collection('MaintenanceMode');
//
//   Future showDialogMode(BuildContext context) async {
//     await FirebaseFirestore.instance
//         .collection('ShowDialogMode')
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         print(doc.metadata.isFromCache ? "NOT FROM NETWORK" : "FROM NETWORK");
//         print("doc[isShow]=${doc["isShow"]}");
//         if (!doc['isShow']) return;
//
//         showDialog(
//           barrierDismissible: true,
//           context: context,
//           builder: (context) => AlertDialog(
//             contentPadding: EdgeInsets.zero,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0))),
//             content: Container(
//               width: SizerUtil.deviceType == DeviceType.tablet ? 80.w : 100.w,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   CachedNetworkImage(
//                     width: 100.w,
//                     height: 150.sp,
//                     imageUrl: doc['image'],
//                     imageBuilder: (context, imageProvider) => Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         image: DecorationImage(
//                             image: imageProvider, fit: BoxFit.cover),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => Icon(Icons.error),
//                   ),
//                   SizedBox(
//                     height: 1.h,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       '${doc['message']}',
//                       style: TextStyle(
//                         fontSize: SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 12.sp,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     height: 7.h,
//                     width: 100.w,
//                     child: TextButton(
//                       // color: Colors.transparent,
//                       // splashColor: Colors.black26,
//                       onPressed: () {
//                         Get.back();
//                       },
//                       style: ButtonStyle(
//                         // splashColor: Colors.transparent,
//                         foregroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
//                         overlayColor: MaterialStateProperty.all(Colors.black26),
//
//                       ),
//                       child: Text(
//                         'CLOSE',
//                         style: TextStyle(
//                             color: Color(0xff1d1a56),
//                             fontSize: SizerUtil.deviceType == DeviceType.tablet ? 9.sp : 12.sp,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       });
//     });
//   }
//
//   Future maintenanceMode() async {
//     // await dataList
//     //     .get()
//     //     .then((QuerySnapshot querySnapshot) {
//     //   querySnapshot.docs.forEach((doc) {
//     //     print(doc.metadata.isFromCache ? "NOT FROM NETWORK" : "FROM NETWORK");
//     //     print("isMaintenance=${doc['isMaintenance']}");
//     //
//     //     if (doc['isMaintenance']) {
//     //       Get.defaultDialog(
//     //         title: "${doc['title']}",
//     //         middleText: "${doc['message']}",
//     //         barrierDismissible: false,
//     //         confirm: reloadBtn(),
//     //       );
//     //     }
//     //   });
//     // });
//     await for (var snapshot in FirebaseFirestore.instance
//         .collection('MaintenanceMode')
//         .snapshots()) {
//       for (var message in snapshot.docs) {
//         print("isMaintenance=${message['isMaintenance']}");
//         if (message['isMaintenance']) {
//           Get.defaultDialog(
//             title: "${message['title']}",
//             middleText: "${message['message']}",
//             barrierDismissible: false,
//             confirm: reloadBtn(),
//           );
//         }
//       }
//     }
//   }
//
//   Widget reloadBtn() {
//     return ElevatedButton(
//         onPressed: () {
//           exit(0);
//         },
//         child: Text("OK"));
//   }
// }
