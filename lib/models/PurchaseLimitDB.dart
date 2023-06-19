class PurchaseLimitDb {
  PurchaseLimitDb({
    required this.status,
    required this.message,
  });

  int status;
  bool message;

  factory PurchaseLimitDb.fromMap(Map<String, dynamic> json) => PurchaseLimitDb(
    status: json["status"],
    message: json["message"],
  );
}
