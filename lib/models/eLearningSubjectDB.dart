class ELearningSubjectDb {
  ELearningSubjectDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory ELearningSubjectDb.fromMap(Map<String, dynamic> json) => ELearningSubjectDb(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    this.fullImage,
    this.firstVideo,
  });

  int id;
  int userId;
  String name;
  String description;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic fullImage;
  dynamic firstVideo;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    description: json["description"],
    image: json["image"] == null ? null : json["image"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    fullImage: json["fullimage"],
    firstVideo: json["firstvideo"],
  );
}
