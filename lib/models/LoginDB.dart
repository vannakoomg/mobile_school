class LoginDb {
  LoginDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory LoginDb.fromMap(Map<String, dynamic> json) => LoginDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.token,
    required this.studentId,
  });

  String token;
  String studentId;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    token: json["token"],
    studentId: json["student_id"],
  );
}
