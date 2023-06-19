class LogoutDb {
  LogoutDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<dynamic> data;

  factory LogoutDb.fromMap(Map<String, dynamic> json) => LogoutDb(
    status: json["status"],
    message: json["message"],
    data: List<dynamic>.from(json["data"].map((x) => x)),
  );
}
