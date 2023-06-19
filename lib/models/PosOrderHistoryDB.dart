class PosOrderHistoryDb {
  PosOrderHistoryDb({
    required this.status,
    required this.message,
    required this.response,
  });

  int status;
  bool message;
  List<PosOrderHistoryData> response;

  factory PosOrderHistoryDb.fromMap(Map<String, dynamic> json) => PosOrderHistoryDb(
    status: json["status"],
    message: json["message"],
    response: List<PosOrderHistoryData>.from(json["response"].map((x) => PosOrderHistoryData.fromMap(x))),
  );
}

class PosOrderHistoryData {
  PosOrderHistoryData({
    required this.receipt,
    required this.date,
    required this.amountPaid,
    required this.list,
  });

  String receipt;
  String date;
  String amountPaid;
  List<ListElement> list;

  factory PosOrderHistoryData.fromMap(Map<String, dynamic> json) => PosOrderHistoryData(
    receipt: json["receipt"],
    date: json["date"],
    amountPaid: json["amount_paid"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromMap(x))),
  );
}

class ListElement {
  ListElement({
    required this.name,
    required this.qty,
    required this.priceUnit,
    required this.priceSubtotal,
    required this.image,
  });

  String name;
  int qty;
  String priceUnit;
  String priceSubtotal;
  String image;

  factory ListElement.fromMap(Map<String, dynamic> json) => ListElement(
    name: json["name"],
    qty: json["qty"],
    priceUnit: json["price_unit"],
    priceSubtotal: json["price_subtotal"],
    image: json["image"],
  );
}
