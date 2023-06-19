class ProfileDb {
  ProfileDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory ProfileDb.fromMap(Map<String, dynamic> json) => ProfileDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.data,
  });

  List<Datum> data;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );
}

class Datum {
  Datum({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.classId,
    required this.className,
    required this.campus,
    required this.fullImage,
    required this.version,
  });

  String id;
  String name;
  String email;
  String phone;
  String classId;
  String className;
  String campus;
  String fullImage;
  String version;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"].toString(),
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    classId: json["class_id"].toString(),
    className: json["class_name"],
    campus: json["campus"],
    fullImage: json["fullimage"],
    version: json["version"] ?? '',
  );
}
