// To parse this JSON data, do
//
//     final assignmentListDb = assignmentListDbFromMap(jsonString);

class AssignmentListDb {
  AssignmentListDb({
    required this.assigned,
    required this.missing,
    required this.done,
  });

  List<Assigned> assigned;
  List<Assigned> missing;
  List<Assigned> done;

  factory AssignmentListDb.fromMap(Map<String, dynamic> json) =>
      AssignmentListDb(
        assigned: List<Assigned>.from(
            json["assigned"].map((x) => Assigned.fromMap(x))),
        missing: List<Assigned>.from(
            json["missing"].map((x) => Assigned.fromMap(x))),
        done: List<Assigned>.from(json["done"].map((x) => Assigned.fromMap(x))),
      );
}

class Assigned {
  Assigned({
    required this.id,
    required this.term,
    required this.name,
    required this.description,
    required this.submitted,
    required this.status,
    required this.marks,
    required this.completed,
    required this.language,
    required this.mTeacher,
    required this.mDuedate,
    required this.mCreatedate,
    required this.mClassname,
    required this.mResult,
    required this.course,
    required this.assignedClass,
    required this.homeworkresult,
  });

  int id;
  String term;
  String name;
  String description;
  int submitted;
  int status;
  int marks;
  int completed;
  String language;
  String mTeacher;
  String mDuedate;
  String mCreatedate;
  String mClassname;
  Result mResult;
  Course course;
  Class assignedClass;
  List<Result> homeworkresult;

  factory Assigned.fromMap(Map<String, dynamic> json) => Assigned(
        id: json["id"],
        term: json["term"],
        name: json["name"],
        description: json["description"] == null ? '' : json["description"],
        submitted: json["submitted"],
        status: json["status"],
        marks: json["marks"],
        completed: json["completed"],
        language: json["language"],
        mTeacher: json["m_teacher"],
        mDuedate: json["m_duedate"],
        mCreatedate: json["m_createdate"],
        mClassname: json["m_classname"],
        mResult: Result.fromMap(json["m_result"]),
        course: Course.fromMap(json["course"]),
        assignedClass: Class.fromMap(json["class"]),
        homeworkresult: List<Result>.from(
            json["homeworkresult"].map((x) => Result.fromMap(x))),
      );
}

class Class {
  Class({
    required this.id,
    required this.name,
    required this.campus,
    required this.roomno,
  });

  int id;
  String name;
  String campus;
  String roomno;

  factory Class.fromMap(Map<String, dynamic> json) => Class(
        id: json["id"],
        name: json["name"],
        campus: json["campus"],
        roomno: json["roomno"] ?? '',
      );
}

class Course {
  Course({
    required this.id,
    required this.userId,
    required this.name,
    required this.color,
  });

  int id;
  int userId;
  String name;
  String color;

  factory Course.fromMap(Map<String, dynamic> json) => Course(
        id: json["id"],
        userId: json["user_id"],
        name: json["name"],
        color: json["color"],
      );
}

class Result {
  Result({
    required this.id,
    required this.userId,
    required this.homeworkId,
    required this.studentId,
    required this.remark,
    required this.score,
    required this.turnedin,
    required this.mStatus,
  });

  int id;
  int userId;
  int homeworkId;
  int studentId;
  String remark;
  int score;
  String turnedin;
  String mStatus;

  factory Result.fromMap(Map<String, dynamic> json) => Result(
        id: json["id"],
        userId: json["user_id"],
        homeworkId: json["homework_id"],
        studentId: json["student_id"],
        remark: json["remark"] == null ? '' : json["remark"],
        score: json["score"],
        turnedin: json["turnedin"],
        mStatus: json["m_status"],
      );
}
