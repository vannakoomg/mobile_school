import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../models/AssignmentListDB.dart';
import '../../repos/assignment_list.dart';
import '../../config/theme/theme.dart';
import 'blank_page.dart';

class ClassResultsPage extends StatefulWidget {
  const ClassResultsPage({Key? key}) : super(key: key);

  @override
  _ClassResultsPageState createState() => _ClassResultsPageState();
}

class _ClassResultsPageState extends State<ClassResultsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Assigned> _recDoneList = [];
  List<Map<String, dynamic>> _mapResultTerm1 = [],
      _mapResultTerm2 = [],
      _mapResultTerm3 = [],
      _mapResultTerm4 = [];
  int? _emptyTerm1, _emptyTerm2, _emptyTerm3, _emptyTerm4;
  var newMapTerm1, newMapTerm2, newMapTerm3, newMapTerm4;
  bool isLoading = false;
  late final PhoneSize phoneSize;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;
    _tabController = TabController(length: 4, vsync: this);
    _fetchAssignmentDone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Assignment Results"),
      ),
      body: Column(
        children: <Widget>[
          Container(
            constraints: BoxConstraints.expand(height: 6.h),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.deepPurpleAccent,
              unselectedLabelColor: Colors.blueGrey,
              labelStyle: myTextStyleHeader[phoneSize],
              indicatorColor: Colors.deepPurpleAccent,
              tabs: [
                Tab(text: "Term 1"),
                Tab(text: "Term 2"),
                Tab(text: "Term 3"),
                Tab(text: "Term 4"),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: TabBarView(controller: _tabController, children: [
                Tab(
                    child: _emptyTerm1 == 0
                        ? BlankPage()
                        : (!isLoading
                            ? Center(child: CircularProgressIndicator())
                            : bodyResult(newMapTerm1))),
                Tab(
                    child: _emptyTerm2 == 0
                        ? BlankPage()
                        : (!isLoading
                            ? Center(child: CircularProgressIndicator())
                            : bodyResult(newMapTerm2))),
                Tab(
                    child: _emptyTerm3 == 0
                        ? BlankPage()
                        : (!isLoading
                            ? Center(child: CircularProgressIndicator())
                            : bodyResult(newMapTerm3))),
                Tab(
                    child: _emptyTerm4 == 0
                        ? BlankPage()
                        : (!isLoading
                            ? Center(child: CircularProgressIndicator())
                            : bodyResult(newMapTerm4))),
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget bodyResult(var newMap) {
    return Container(
      height: 100.h,
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: newMap.length,
          physics: PageScrollPhysics(),
          itemBuilder: (context, index) {
            var string = '${newMap.keys}';
            var result = string.substring(1, string.length - 1);
            final splitted = result.split(',');
            print("splitted=$newMap");
            return Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 7.h,
                  color: Colors.teal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.book_outlined, color: Colors.white),
                      Padding(padding: const EdgeInsets.only(right: 5.0)),
                      Text('${splitted[index].trim()}',
                          style: myTextStyleHeaderWhite[phoneSize]),
                    ],
                  ),
                ),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // scrollDirection: Axis.horizontal,
                  itemCount: newMap['${splitted[index].trim()}'].length,
                  itemBuilder: (context, index2) => Container(
                    // width: 100.w,
                    child: Card(
                        // color: Colors.blue,
                        child: Row(
                      children: [
                        SizedBox(
                          height: 10.h,
                          width: 1.5.w,
                          child: const DecoratedBox(
                            decoration:
                                const BoxDecoration(color: Colors.blueGrey),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          width: 95.w,
                          height: 10.h,
                          // color: Colors.yellow,
                          child: Row(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 60.w,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${newMap['${splitted[index].trim()}'][index2]['title']}',
                                        style: myTextStyleBody[phoneSize]),
                                    Text(
                                      '${newMap['${splitted[index].trim()}'][index2]['m_createdate']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: myTextStyleBody[phoneSize],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    // color: Colors.red,
                                    // width: 30.w,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${newMap['${splitted[index].trim()}'][index2]['score']}/${newMap['${splitted[index].trim()}'][index2]['marks']}',
                                        style: myTextStyleHeader[phoneSize])),
                              )
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _fetchAssignmentDone() {
    fetchAssignment().then((value) {
      setState(() {
        try {
          _recDoneList.addAll(value.done);
          _recDoneList.forEach((element) {
            if (element.term == 'Term 1' && element.completed == 1)
              _mapResultTerm1.add({
                'course': element.course.name,
                'title': element.name,
                'marks': element.marks,
                'score': element.mResult.score,
                'm_status': element.mResult.mStatus,
                'm_duedate': element.mDuedate,
                'm_createdate': element.mCreatedate,
              });
            else if (element.term == 'Term 2' && element.completed == 1)
              _mapResultTerm2.add({
                'course': element.course.name,
                'title': element.name,
                'marks': element.marks,
                'score': element.mResult.score,
                'm_status': element.mResult.mStatus,
                'm_duedate': element.mDuedate,
                'm_createdate': element.mCreatedate,
              });
            else if (element.term == 'Term 3' && element.completed == 1)
              _mapResultTerm3.add({
                'course': element.course.name,
                'title': element.name,
                'marks': element.marks,
                'score': element.mResult.score,
                'm_status': element.mResult.mStatus,
                'm_duedate': element.mDuedate,
                'm_createdate': element.mCreatedate,
              });
            else if (element.term == 'Term 4' && element.completed == 1)
              _mapResultTerm4.add({
                'course': element.course.name,
                'title': element.name,
                'marks': element.marks,
                'score': element.mResult.score,
                'm_status': element.mResult.mStatus,
                'm_duedate': element.mDuedate,
                'm_createdate': element.mCreatedate,
              });
          });
          _emptyTerm1 = _mapResultTerm1.length;
          _emptyTerm2 = _mapResultTerm2.length;
          _emptyTerm3 = _mapResultTerm3.length;
          _emptyTerm4 = _mapResultTerm4.length;

          newMapTerm1 = groupBy(_mapResultTerm1, (Map obj) => obj['course'])
              .map((k, v) => MapEntry(
                  k,
                  v.map((item) {
                    item.remove('course');
                    return item;
                  }).toList()));

          newMapTerm2 = groupBy(_mapResultTerm2, (Map obj) => obj['course'])
              .map((k, v) => MapEntry(
                  k,
                  v.map((item) {
                    item.remove('course');
                    return item;
                  }).toList()));
          newMapTerm3 = groupBy(_mapResultTerm3, (Map obj) => obj['course'])
              .map((k, v) => MapEntry(
                  k,
                  v.map((item) {
                    item.remove('course');
                    return item;
                  }).toList()));
          newMapTerm4 = groupBy(_mapResultTerm4, (Map obj) => obj['course'])
              .map((k, v) => MapEntry(
                  k,
                  v.map((item) {
                    item.remove('course');
                    return item;
                  }).toList()));
          // var newMap = groupBy(data, (Map obj) => obj['DateOfBirth']);
          // var test  = [{'assignment_name': 'Ass 50', 'marks': 80, 'score': 47, 'm_duedate': '11 December 2022 05:11 PM', 'm_createdate': '08 December 2022 05:13 PM'}];
          // // print("newMap=${test.length}");
          // print("newMap-keys=${newMap.keys}");
          // print("newMap-length=${newMap.length}");
          // print("newMap-Physics-length=${newMap['Physics'].length}");
          // print("newMap-Physics-name=${newMap['Physics'][0]['assignment_name']}");

          // var string = '${newMap.keys}';
          // // var result = string.length; // 'artlang'
          // var result = string.substring(1, string.length -1); // 'art'
          // print("result=$result");
          //
          // // const string1 = 'Hello world!';
          // final splitted = result.split(',');
          // print(splitted[1].trim()); // [Hello, world!];
          isLoading = true;

          // print('_recDoneList=${_mapResult}');
        } catch (err) {}
      });
    });
  }
}
