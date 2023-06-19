class TopUpHistoryDb {
  TopUpHistoryDb({
    required this.status,
    required this.message,
    required this.response,
  });

  int status;
  bool message;
  List<TopUpHistoryData> response;

  factory TopUpHistoryDb.fromMap(Map<String, dynamic> json) => TopUpHistoryDb(
    status: json["status"],
    message: json["message"],
    response: List<TopUpHistoryData>.from(json["response"].map((x) => TopUpHistoryData.fromMap(x))),
  );
}

class TopUpHistoryData {
  TopUpHistoryData({
    required this.posReference,
    required this.date,
    required this.amountPaid,
    required this.statePreOrder,
  });

  String posReference;
  String date;
  String amountPaid;
  String statePreOrder;

  factory TopUpHistoryData.fromMap(Map<String, dynamic> json) => TopUpHistoryData(
    posReference: json["pos_reference"],
    date: json["date"],
    amountPaid: json["amount_paid"],
    statePreOrder: json["state_pre_order"],
  );
}
