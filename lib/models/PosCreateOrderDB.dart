class PosCreateOrderDb {
  PosCreateOrderDb({
    required this.status,
    required this.message,
    required this.description,
  });

  int status;
  String message;
  String description;

  factory PosCreateOrderDb.fromMap(Map<String, dynamic> json) => PosCreateOrderDb(
    status: json["status"],
    message: json["message"],
    description: json["description"],
  );
}
