import 'package:flutter/material.dart';
import 'package:school/utils/widgets/custom_dialog.dart';
import 'package:sizer/sizer.dart';

import '../../models/PosOrderHistoryDB.dart';
import '../../repos/pos_data.dart';
import '../../config/theme/theme.dart';

class PosHistory extends StatefulWidget {
  const PosHistory({Key? key}) : super(key: key);

  @override
  _PosHistoryState createState() => _PosHistoryState();
}

class _PosHistoryState extends State<PosHistory>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final PhoneSize phoneSize;
  late List<PosOrderHistoryData> _recPosOrderHistoryData = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneSize = SizerUtil.deviceType == DeviceType.tablet
        ? PhoneSize.ipad
        : PhoneSize.iphone;

    _fetchPosOrderHistory();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

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
        padding: EdgeInsets.only(top: 10),
        // physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _recPosOrderHistoryData.length,
        itemBuilder: (context, index) => Column(
          children: [
            Container(
              height: 8.h,
              color: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '${_recPosOrderHistoryData[index].receipt}',
                        style: myTextStyleHeader[phoneSize],
                      ),
                      Text(
                        '${_recPosOrderHistoryData[index].date}',
                        style: myTextStyleHeader[phoneSize],
                      ),
                    ],
                  ),
                  Text(
                    '\$${_recPosOrderHistoryData[index].amountPaid}',
                    style: myTextStyleHeader[phoneSize],
                  ),
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 10),
                itemCount: _recPosOrderHistoryData[index].list.length,
                itemBuilder: (context, index2) => Container(
                  child:
                      _buildItem(_recPosOrderHistoryData[index].list[index2]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildItem(item) {
    return Card(
      elevation: 3,
      child: Container(
        padding: EdgeInsets.all(8),
        // height: 120,
        child: Row(
          children: [
            // SizedBox(
            //   child: _buildUrlImages(
            //       "https://media.istockphoto.com/id/1190330112/photo/fried-pork-and-vegetables-on-white-background.jpg?s=612x612&w=0&k=20&c=TzvLLGGvPAmxhKJ6fz91UGek-zLNNCh4iq7MVWLnFwo="),
            //   // child: _buildUrlImages("http://202.62.45.129:8069/web/image?model=product.product&id=6878&field=image_512"),
            // ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Container(
                // width: 300,
                // color: Colors.red,
                height: 7.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${item.name}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: myTextStyleHeader[phoneSize],
                    ),
                    Text(
                      "X ${item.qty}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: myTextStyleBody[phoneSize],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 0,
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Text("\$${item.priceSubtotal}",
                        style: myTextStyleBody[phoneSize])))
          ],
        ),
      ),
    );
  }

  // _buildUrlImages(String urlImage) {
  //   return Container(
  //     // color: Colors.white,
  //     child: CachedNetworkImage(
  //       height: 5.h,
  //       width: 5.h,
  //       imageUrl: urlImage,
  //       imageBuilder: (context, imageProvider) => Container(
  //         decoration: BoxDecoration(
  //           // shape: BoxShape.circle,
  //           image: DecorationImage(
  //             alignment: Alignment.topCenter,
  //             image: imageProvider,
  //             fit: BoxFit.cover,
  //           ),
  //           borderRadius: BorderRadius.all(Radius.circular(50.0)),
  //           boxShadow: [
  //             BoxShadow(blurRadius: 5, color: Colors.grey, offset: Offset(1, 3))
  //           ],
  //         ),
  //       ),
  //       placeholder: (context, url) => CircularProgressIndicator(),
  //       errorWidget: (context, url, error) =>
  //           Image.asset("assets/icons/login_icon/logo_no_background.png"),
  //     ),
  //   );
  // }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _fetchPosOrderHistory() {
    fetchPos(route: "order_history").then((value) {
      setState(() {
        try {
          // print("value123=${value.status}");
          _recPosOrderHistoryData.addAll(value.response);
          // print("_recPosOrderHistoryData.length=${_recPosOrderHistoryData.length}");
          isLoading = true;
        } catch (err) {
          print("err=$err");

          CustomDialog.error(
              title: "Oops!",
              message: "Something went wrong.\nPlease try again later.",
              context: context,
              ontap: () {
                Navigator.of(context).pop();
                _fetchPosOrderHistory();
              });
        }
      });
    });
  }
}
