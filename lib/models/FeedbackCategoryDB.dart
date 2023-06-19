class FeedbackCategoryDb {
  FeedbackCategoryDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<String> data;

  factory FeedbackCategoryDb.fromMap(Map<String, dynamic> json) => FeedbackCategoryDb(
    status: json["status"],
    message: json["message"],
    data: List<String>.from(json["data"].map((x) => x)),
  );
}
