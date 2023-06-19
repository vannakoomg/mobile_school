class UpdateVersionDb {
  UpdateVersionDb({
    required this.status,
  });

  String status;

  factory UpdateVersionDb.fromMap(Map<String, dynamic> json) => UpdateVersionDb(
    status: json["status"],
  );
}
