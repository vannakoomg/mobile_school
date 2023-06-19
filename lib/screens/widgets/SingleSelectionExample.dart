// import 'package:flutter/material.dart';

// class SingleSelectionExample extends StatefulWidget {
//   List<String> sortFilter;

//   SingleSelectionExample(this.sortFilter);

//   @override
//   _SingleSelectionExampleState createState() => _SingleSelectionExampleState();
// }

// class _SingleSelectionExampleState extends State<SingleSelectionExample> {
//   dynamic selectedValue;

//   @override
//   void initState() {
//     super.initState();

//     // print('globals.isLoggedIn==${globals.isLoggedIn}');

//     selectedValue = 'Sort by Ratings';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemBuilder: (ctx, index) {
//         print('ctx=$ctx');
//         return GestureDetector(
//           behavior: HitTestBehavior.opaque,
//           onTap: () {
//             selectedValue = widget.sortFilter[index];
//             setState(() {
//               print('selectedValue=$selectedValue');
//             });
//           },
//           child: Container(
//             color: selectedValue == widget.sortFilter[index]
//                 ? Colors.green[100]
//                 : null,
//             child: Row(
//               children: <Widget>[
//                 Radio(
//                     value: widget.sortFilter[index],
//                     groupValue: selectedValue,
//                     onChanged: (s) {
//                       selectedValue = s;
//                       setState(() {
//                         print('ssss=$s');
//                       });
//                     }),
//                 Text(widget.sortFilter[index])
//               ],
//             ),
//           ),
//         );
//       },
//       itemCount: widget.sortFilter.length,
//     );
//   }
// }
