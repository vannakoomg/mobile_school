class AssignmentRemoveAttachmentDb {
  AssignmentRemoveAttachmentDb({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory AssignmentRemoveAttachmentDb.fromMap(Map<String, dynamic> json) => AssignmentRemoveAttachmentDb(
    status: json["status"],
    message: json["message"],
  );
}
