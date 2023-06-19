
class AssignmentDetailDb {
  AssignmentDetailDb({
    required this.id,
    required this.term,
    required this.name,
    required this.description,
    required this.addedOnDate,
    required this.dueDate,
    required this.submitted,
    required this.status,
    required this.marks,
    required this.completed,
    required this.mTeacher,
    required this.mDuedate,
    required this.mCreatedate,
    required this.mClassname,
    required this.mResult,
    required this.attachments,
    required this.course,
    required this.assignmentDetailDbClass,
    required this.homeworkresult,
  });

  int id;
  String term;
  String name;
  String description;
  DateTime addedOnDate;
  DateTime dueDate;
  int submitted;
  int status;
  int marks;
  int completed;
  String mTeacher;
  String mDuedate;
  String mCreatedate;
  String mClassname;
  Result mResult;
  List<Attachment> attachments;
  Course course;
  Class assignmentDetailDbClass;
  List<Result> homeworkresult;

  factory AssignmentDetailDb.fromMap(Map<String, dynamic> json) => AssignmentDetailDb(
    id: json["id"],
    term: json["term"],
    name: json["name"],
    description: json["description"] == null ? '' : json["description"],
    addedOnDate: DateTime.parse(json["added_on_date"]),
    dueDate: DateTime.parse(json["due_date"]),
    submitted: json["submitted"],
    status: json["status"],
    marks: json["marks"],
    completed: json["completed"],
    mTeacher: json["m_teacher"],
    mDuedate: json["m_duedate"],
    mCreatedate: json["m_createdate"],
    mClassname: json["m_classname"],
    mResult: Result.fromMap(json["m_result"]),
    attachments: List<Attachment>.from(json["attachments"].map((x) => Attachment.fromMap(x))),
    course: Course.fromMap(json["course"]),
    assignmentDetailDbClass: Class.fromMap(json["class"]),
    homeworkresult: List<Result>.from(json["homeworkresult"].map((x) => Result.fromMap(x))),
  );
}

class Attachment {
  Attachment({
    required this.id,
    required this.filename,
    required this.link,
  });

  int id;
  String filename;
  String link;

  factory Attachment.fromMap(Map<String, dynamic> json) => Attachment(
    id: json["id"],
    filename: json["filename"],
    link: json["link"],
  );
}

class Class {
  Class({
    required this.roomno,
  });

  String roomno;

  factory Class.fromMap(Map<String, dynamic> json) => Class(
    roomno: json["roomno"] ?? '',
  );
}

class Course {
  Course({
    required this.name,
    required this.color,
  });

  String name;
  String color;

  factory Course.fromMap(Map<String, dynamic> json) => Course(
    name: json["name"],
    color: json["color"],
  );
}

class Result {
  Result({
    required this.id,
    this.remark,
    required this.score,
    required this.turnedin,
    this.turnedindate,
    required this.teacherComment,
    required this.mStatus,
    required this.submitStatus,
    required this.attachments,
  });

  int id;
  dynamic remark;
  int score;
  String turnedin;
  dynamic turnedindate;
  String teacherComment;
  String mStatus;
  String submitStatus;
  List<Attachment> attachments;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
    id: json["id"],
    remark: json["remark"] == null ? '' : json["remark"],
    score: json["score"],
    turnedin: json["turnedin"],
    turnedindate: json["turnedindate"],
    teacherComment: json["teacher_comment"] ?? '',
    mStatus: json["m_status"],
    submitStatus: json["submit_status"],
    attachments: List<Attachment>.from(json["attachments"].map((x) => Attachment.fromMap(x))),
  );
}
