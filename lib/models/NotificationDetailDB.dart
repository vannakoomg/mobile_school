class NotificationDetailDb {
  NotificationDetailDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  NotificationDetailDbData data;

  factory NotificationDetailDb.fromMap(Map<String, dynamic> json) => NotificationDetailDb(
    status: json["status"],
    message: json["message"],
    data: NotificationDetailDbData.fromMap(json["data"]),
  );
}

class NotificationDetailDbData {
  NotificationDetailDbData({
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
  DataData data;
  dynamic readAt;
  DateTime createdAt;
  DateTime updatedAt;
  String date;
  String time;

  factory NotificationDetailDbData.fromMap(Map<String, dynamic> json) => NotificationDetailDbData(
    id: json["id"],
    notifiableId: json["notifiable_id"],
    data: DataData.fromMap(json["data"]),
    readAt: json["read_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    date: json["date"],
    time: json["time"],
  );
}

class DataData {
  DataData({
    required this.title,
    required this.message,
    required this.image,
    required this.fullimage,
  });

  String title;
  String message;
  String image;
  String fullimage;

  factory DataData.fromMap(Map<String, dynamic> json) => DataData(
    title: json["title"],
    message: json["message"],
    image: json["image"],
    fullimage: json["fullimage"],
  );
}
