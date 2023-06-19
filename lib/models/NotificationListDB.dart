class NotificationListDb {
  NotificationListDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  NotificationListDbData data;

  factory NotificationListDb.fromMap(Map<String, dynamic> json) => NotificationListDb(
    status: json["status"],
    message: json["message"],
    data: NotificationListDbData.fromMap(json["data"]),
  );
}

class NotificationListDbData {
  NotificationListDbData({
    required this.currentPage,
    required this.data,
    this.nextPageUrl,
    this.total,
  });

  int currentPage;
  List<Datum> data;
  dynamic nextPageUrl;
  dynamic total;

  factory NotificationListDbData.fromMap(Map<String, dynamic> json) => NotificationListDbData(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    nextPageUrl: json["next_page_url"],
    total: json["total"],
  );
}

class Datum {
  Datum({
    required this.id,
    required this.notifiableId,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
    required this.date,
    required this.time,
  });

  String id;
  int notifiableId;
  DatumData data;
  dynamic readAt;
  DateTime createdAt;
  DateTime updatedAt;
  String date;
  String time;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    notifiableId: json["notifiable_id"],
    data: DatumData.fromMap(json["data"]),
    readAt: json["read_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    date: json["date"],
    time: json["time"],
  );
}

class DatumData {
  DatumData({
    required this.title,
    required this.message,
    required this.appname,
    required this.trid,
    required this.image,
    required this.fullimage,
  });

  String title;
  String message;
  String appname;
  dynamic trid;
  String image;
  String fullimage;

  factory DatumData.fromMap(Map<String, dynamic> json) => DatumData(
    title: json["title"],
    message: json["message"],
    appname: json["appname"],
    trid: json["trid"],
    image: json["image"],
    fullimage: json["fullimage"],
  );
}
