class ChangePasswordDb {
  ChangePasswordDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<dynamic> data;

  factory ChangePasswordDb.fromMap(Map<String, dynamic> json) => ChangePasswordDb(
    status: json["status"],
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );
}
