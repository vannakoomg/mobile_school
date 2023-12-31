import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../models/TopUpHistoryDB.dart';
import '../../repos/pos_data.dart';
import '../../config/theme/theme.dart';

class TopUpHistory extends StatefulWidget {
  const TopUpHistory({Key? key}) : super(key: key);

  @override
  _TopUpHistoryState createState() => _TopUpHistoryState();
}

class _TopUpHistoryState extends State<TopUpHistory> {
  late final PhoneSize phoneSize;
  late List<TopUpHistoryData> _recTopUpHistoryData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;

    _fetchTopUpHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("History")),
      body:
          !isLoading ? Center(child: CircularProgressIndicator()) : _buildBody,
    );
  }

  get _buildBody {
    return Container(
      // height: 50,
      child: ListView.builder(
          physics: PageScrollPhysics(),
          shrinkWrap: true,
          itemCount: _recTopUpHistoryData.length,
          itemBuilder: (context, index) => Container(
                child: _buildItem(_recTopUpHistoryData[index]),
              )),
    );
  }

  _buildItem(item) {
    return InkWell(
      child: Card(
        elevation: 3,
        child: Container(
          padding: EdgeInsets.all(8),
          // height: 10.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                      height: 5.h,
                      child:
                          Image.asset('assets/icons/canteen/iwallet_card.png')),
                  SizedBox(
                    width: 3.w,
                  ),
                  Container(
                    // width: 300,
                    // color: Colors.red,
                    height: 7.h,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${item.posReference}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: myTextStyleHeader[phoneSize],
                        ),
                        Text(
                          "${item.date}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: myTextStyleBody[phoneSize],
                        )
                      ],
                    ),
                  )
                ],
              ),
              item.statePreOrder == "draft"
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "\$${item.amountPaid}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: myTextStyleBodyBlueGray[phoneSize],
                        ),
                        Text('On Hold',
                            textAlign: TextAlign.right,
                            style: myTextStyleHeaderGreenItalic[phoneSize])
                      ],
                    )
                  : Text(
                      "\$${item.amountPaid}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: myTextStyleHeader[phoneSize],
                    )
            ],
          ),
        ),
      ),
      onTap: () => viewImage(urlImage: ''),
    );
  }

  void viewImage({required String urlImage}) {
    showDialog(
        // constraints: BoxConstraints(maxHeight: 100.0),
        context: context,
        builder: (ctx) {
          return Dialog(
            child: Container(
              color: Colors.red,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 80.w,
                    child: FadeInImage(
                      image: NetworkImage(urlImage),
                      placeholder: AssetImage(
                        "assets/icons/canteen/red_color.png",
                      ),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/icons/canteen/red_color.png',
                          fit: BoxFit.fitWidth,
                          color: Colors.red,
                        );
                      },
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _fetchTopUpHistory() {
    fetchPos(route: "top_up_history").then((value) {
      setState(() {
        try {
          // print("value123=${value.status}");
          _recTopUpHistoryData.addAll(value.response);
          // print("_recPosOrderHistoryData.length=${_recPosOrderHistoryData.length}");
          isLoading = true;
        } catch (err) {
          print("err=$err");
          Get.defaultDialog(
            title: "Oops!",
            middleText: "Something went wrong.\nPlease try again later.",
            barrierDismissible: false,
            confirm: reloadBtn(),
          );
        }
      });
    });
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget reloadBtn() {
    return ElevatedButton(
        onPressed: () {
          Get.back();
          Navigator.of(context).pop();
          // _fetchPos();
        },
        child: Text("OK"));
  }
}
