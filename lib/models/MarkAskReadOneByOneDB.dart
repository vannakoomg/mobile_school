class MarkAskReadOneByOne {
  MarkAskReadOneByOne({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory MarkAskReadOneByOne.fromMap(Map<String, dynamic> json) => MarkAskReadOneByOne(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.id,
  });

  String id;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
  );
}
