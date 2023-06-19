class FeedbackDetailDb {
  FeedbackDetailDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory FeedbackDetailDb.fromMap(Map<String, dynamic> json) => FeedbackDetailDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.id,
    required this.studentId,
    required this.question,
    required this.category,
    required this.reply,
    this.answer,
    required this.image,
    required this.createdAt,
    this.replyBy,
    this.repliedAt,
    required this.updatedAt,
    required this.date,
    required this.time,
    required this.fullimage,
  });

  int id;
  int studentId;
  String question;
  String category;
  int reply;
  dynamic answer;
  String image;
  DateTime createdAt;
  dynamic replyBy;
  dynamic repliedAt;
  DateTime updatedAt;
  String date;
  String time;
  String fullimage;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    id: json["id"],
    studentId: json["student_id"],
    question: json["question"],
    category: json["category"],
    reply: json["reply"],
    answer: json["answer"],
    image: json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    replyBy: json["reply_by"],
    repliedAt: json["replied_at"],
    updatedAt: DateTime.parse(json["updated_at"]),
    date: json["date"],
    time: json["time"],
    fullimage: json["fullimage"],
  );
}
