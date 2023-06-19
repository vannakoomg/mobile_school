
class AssignmentTextSubmitDb {
  AssignmentTextSubmitDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<dynamic> data;

  factory AssignmentTextSubmitDb.fromMap(Map<String, dynamic> json) => AssignmentTextSubmitDb(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? [] : List<dynamic>.from(json["data"].map((x) => x)),
  );
}
