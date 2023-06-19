class FeedbackListDb {
  FeedbackListDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory FeedbackListDb.fromMap(Map<String, dynamic> json) => FeedbackListDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    this.nextPageUrl,
    required this.total,
  });

  int currentPage;
  List<Datum> data;
  dynamic nextPageUrl;
  int total;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    nextPageUrl: json["next_page_url"],
    total: json["total"],
  );
}

class Datum {
  Datum({
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
    required this.fullImage,
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
  String fullImage;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
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
    fullImage: json["fullimage"],
  );
}
