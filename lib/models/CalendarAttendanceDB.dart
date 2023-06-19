class CalendarAttendanceDb {
  CalendarAttendanceDb({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory CalendarAttendanceDb.fromMap(Map<String, dynamic> json) => CalendarAttendanceDb(
    status: json["status"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.present,
    required this.excused,
    required this.unexcused,
  });

  List<Attendance> present;
  List<Attendance> excused;
  List<Attendance> unexcused;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    present: List<Attendance>.from(json["present"].map((x) => Attendance.fromMap(x))),
    excused: List<Attendance>.from(json["excused"].map((x) => Attendance.fromMap(x))),
    unexcused: List<Attendance>.from(json["unexcused"].map((x) => Attendance.fromMap(x))),
  );
}

class Attendance {
  Attendance({
    required this.date,
    required this.dateFormat,
    required this.timeFormat,
  });

  DateTime date;
  String dateFormat;
  String timeFormat;

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
    date: DateTime.parse(json["date"]),
    dateFormat: json["date_format"],
    timeFormat: json["time_format"],
  );
}
