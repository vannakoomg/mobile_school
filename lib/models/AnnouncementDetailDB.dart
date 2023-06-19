class AnnouncementDetailDb {
  AnnouncementDetailDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory AnnouncementDetailDb.fromMap(Map<String, dynamic> json) => AnnouncementDetailDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.title,
    required this.body,
    required this.createdAt,
    required this.fullImage,
    required this.date,
    required this.time,
  });

  String title;
  String body;
  DateTime createdAt;
  String fullImage;
  String date;
  String time;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    title: json["title"],
    body: json["body"],
    createdAt: DateTime.parse(json["created_at"]),
    fullImage: json["full_image"],
    date: json["date"],
    time: json["time"],
  );
}
