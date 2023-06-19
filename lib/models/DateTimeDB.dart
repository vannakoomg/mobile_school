class DateTimeDb {
  DateTimeDb({
    required this.status,
    required this.data,
  });

  bool status;
  Data data;

  factory DateTimeDb.fromMap(Map<String, dynamic> json) => DateTimeDb(
    status: json["status"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.date,
    required this.time,
  });

  String date;
  String time;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    date: json["date"],
    time: json["time"],
  );
}
