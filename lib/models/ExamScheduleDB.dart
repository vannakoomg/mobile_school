class ExamScheduleDb {
  ExamScheduleDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory ExamScheduleDb.fromMap(Map<String, dynamic> json) => ExamScheduleDb(
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
    this.date,
    required this.startTime,
    required this.endTime,
    required this.classId,
    required this.courseId,
    required this.title,
    this.room,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
    required this.datumClass,
    required this.course,
  });

  int id;
  int userId;
  dynamic date;
  String startTime;
  String endTime;
  int classId;
  int courseId;
  String title;
  dynamic room;
  int active;
  DateTime createdAt;
  DateTime updatedAt;
  Class datumClass;
  Class course;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    date: json["date"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    classId: json["class_id"],
    courseId: json["course_id"],
    title: json["title"],
    room: json["room"],
    active: json["active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    datumClass: Class.fromMap(json["class"]),
    course: Class.fromMap(json["course"]),
  );
}

class Class {
  Class({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Class.fromMap(Map<String, dynamic> json) => Class(
    id: json["id"],
    name: json["name"],
  );
}
