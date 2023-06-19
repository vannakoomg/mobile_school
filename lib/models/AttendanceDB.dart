class AttendanceDb {
  AttendanceDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory AttendanceDb.fromMap(Map<String, dynamic> json) => AttendanceDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.currentPage,
    required this.data,
    required this.nextPageUrl,
  });

  int currentPage;
  List<Datum> data;
  dynamic nextPageUrl;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    nextPageUrl: json["next_page_url"],
  );
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.date,
    required this.studentId,
    required this.status,
    required this.dateFormat,
    required this.timeFormat,
  });

  int id;
  int userId;
  DateTime date;
  int studentId;
  String status;
  String dateFormat;
  String timeFormat;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    date: DateTime.parse(json["date"]),
    studentId: json["student_id"],
    status: json["status"],
    dateFormat: json["date_format"],
    timeFormat: json["time_format"],
  );
}
