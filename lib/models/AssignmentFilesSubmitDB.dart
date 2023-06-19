class AssignmentFilesSubmitDb {
  AssignmentFilesSubmitDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<Datum> data;

  factory AssignmentFilesSubmitDb.fromMap(Map<String, dynamic> json) => AssignmentFilesSubmitDb(
    status: json["status"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
  );
}

class Datum {
  Datum({
    required this.id,
    required this.filename,
    required this.link,
  });

  int id;
  String filename;
  String link;

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    id: json["id"],
    filename: json["filename"],
    link: json["link"],
  );
}
