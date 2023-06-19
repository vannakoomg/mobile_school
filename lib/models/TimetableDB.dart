class TimetableDb {
  TimetableDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory TimetableDb.fromMap(Map<String, dynamic> json) => TimetableDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.dataClass,
    required this.timetables,
  });

  Class dataClass;
  List<Timetable> timetables;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    dataClass: Class.fromMap(json["class"]),
    timetables: List<Timetable>.from(json["timetables"].map((x) => Timetable.fromMap(x))),
  );
}

class Class {
  Class({
    required this.name,
    required this.campus,
    this.roomNo,
    required this.levelType,
    required this.homeroom,
    required this.khmerTeacher,
    required this.teacherAide,
    required this.scheduleTemplate,
  });

  String name;
  String campus;
  dynamic roomNo;
  String homeroom;
  String levelType;
  String khmerTeacher;
  String teacherAide;
  List<ScheduleTemplate> scheduleTemplate;

  factory Class.fromMap(Map<String, dynamic> json) => Class(
    name: json["name"],
    campus: json["campus"],
    roomNo: json["roomno"] == null ? '' : json["roomno"],
    homeroom: json["homeroom"],
    levelType: json["level_type"],
    khmerTeacher: json["khmer_teacher"],
    teacherAide: json["teacher_aide"],
    scheduleTemplate: List<ScheduleTemplate>.from(json["schedule_template"].map((x) => ScheduleTemplate.fromMap(x))),
  );
}

class ScheduleTemplate {
  ScheduleTemplate({
    required this.type,
  });

  String type;

  factory ScheduleTemplate.fromMap(Map<String, dynamic> json) => ScheduleTemplate(
    type: json["type"],
  );
}

class Timetable {
  Timetable({
    required this.startTime,
    required this.endTime,
    required this.breakTime,
    required this.teacherName,
    required this.subject,
    required this.time,
  });

  String startTime;
  String endTime;
  String breakTime;
  String teacherName;
  String subject;
  String time;

  factory Timetable.fromMap(Map<String, dynamic> json) => Timetable(
    startTime: json["start_time"],
    endTime: json["end_time"],
    breakTime: json["breaktime"],
    teacherName: json["teacher_name"],
    subject: json["subject"],
    time: json["time"],
  );
}
