import 'dart:convert';

class PosDb {
  PosDb({
    required this.status,
    required this.message,
    required this.sessionId,
    required this.response,
  });

  int status;
  bool message;
  int sessionId;
  List<PosData> response;

  factory PosDb.fromMap(Map<String, dynamic> json) => PosDb(
    status: json["status"],
    message: json["message"],
    sessionId: json["session_id"],
    response: List<PosData>.from(json["response"].map((x) => PosData.fromMap(x))),
  );
}

class PosData {
  PosData({
    required this.group,
    required this.list,
  });

  String group;
  List<ListElement> list;

  factory PosData.fromMap(Map<String, dynamic> json) => PosData(
    group: json["group"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromMap(x))),
  );
}

class ListElement {
  ListElement({
    required this.id,
    required this.name,
    required this.lstPrice,
    required this.image,
    required this.amount,
  });

  int id;
  String name;
  double lstPrice;
  String image;
  int amount;

  factory ListElement.fromMap(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    name: json["name"],
    lstPrice: json["lst_price"].toDouble(),
    image: jsonEncode(json["image"]),
    amount: 0,
  );
}
