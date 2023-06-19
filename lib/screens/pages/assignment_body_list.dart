import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../models/AssignmentListDB.dart';
import '../theme/theme.dart';
import 'homework_detail.dart';

class AssignmentBodyList extends StatefulWidget {
  final List<Assigned> assignmentBody;
  const AssignmentBodyList({Key? key, required this.assignmentBody})
      : super(key: key);

  @override
  State<AssignmentBodyList> createState() => _AssignmentBodyListState();
}

class _AssignmentBodyListState extends State<AssignmentBodyList> {
  late final PhoneSize phoneSize;
  List<Assigned> assignments = [];

  @override
  void initState() {
    super.initState();
    assignments = widget.assignmentBody;
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 5,
              child: Container(
                // color: Colors.blue,
                height: 17.h,
                // width: 40.w,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.assignment,
                                color: Color(0xff3f51b5),
                                size: 13.sp,
                              ),
                              Container(
                                  width: 70.w,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '  ${assignments[index].course.name}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: myTextStyleHeader[phoneSize],
                                  )),
                            ],
                          ),
                          assignments[index].mResult.turnedin == "1"
                              ? Text('__/${assignments[index].marks}')
                              : Text(''),
                        ],
                      ),
                      Container(
                          width: 70.w,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${assignments[index].name}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: myTextStyleBody[phoneSize],
                          )),
                      Row(
                        children: [
                          Text(
                            'Assigned on ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${assignments[index].mDuedate}'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Due ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${assignments[index].mDuedate}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            onTap: () {
              Get.to(() => HomeworkDetailPage(
                    assignmentId: assignments[index].id,
                  ));
            },
          );
        });
  }
}
