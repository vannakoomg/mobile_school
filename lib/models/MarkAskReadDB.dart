class MarkAsReadDb {
  MarkAsReadDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<dynamic> data;

  factory MarkAsReadDb.fromMap(Map<String, dynamic> json) => MarkAsReadDb(
    status: json["status"],
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );

}
