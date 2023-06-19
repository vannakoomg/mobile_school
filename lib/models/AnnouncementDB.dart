class AnnouncementDb {
  AnnouncementDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory AnnouncementDb.fromMap(Map<String, dynamic> json) => AnnouncementDb(
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
    required this.userId,
    required this.title,
    required this.body,
    required this.thumbnail,
    required this.createdAt,
    required this.updatedAt,
    required this.fullImage,
    required this.date,
    required this.time,
  });

  int id;
  int userId;
  String title;
  String body;
  String thumbnail;
  DateTime createdAt;
  String updatedAt;
  String fullImage;
  String date;
  String time;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    title: json["title"],
    body: json["body"],
    thumbnail: json["thumbnail"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
    fullImage: json["full_image"],
    date: json["date"],
    time: json["time"],
  );
}

