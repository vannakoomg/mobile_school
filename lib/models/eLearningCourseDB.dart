class ELearningCourseDb {
  ELearningCourseDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory ELearningCourseDb.fromMap(Map<String, dynamic> json) => ELearningCourseDb(
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
    required this.lesson,
    required this.description,
    required this.url,
    required this.active,
    required this.course,
  });

  String lesson;
  String description;
  String url;
  int active;
  Course course;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    lesson: json["lesson"],
    description: json["description"],
    url: json["url"],
    active: json["active"],
    course: Course.fromMap(json["course"]),
  );
}

class Course {
  Course({
    required this.fullImage,
  });

  String fullImage;

  factory Course.fromMap(Map<String, dynamic> json) => Course(
    fullImage: json["fullimage"],
  );
}
