class FeedbackDb {
  FeedbackDb({
    required this.status,
    required this.message,
    // required this.data,
  });

  bool status;
  String message;
  // String data;

  factory FeedbackDb.fromMap(Map<String, dynamic> json) => FeedbackDb(
    status: json["status"],
    message: json["message"],
    // data: json["data"],
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "message": message,
    // "data": data,
  };
}
