class AttandanceDetailDb {
  AttandanceDetailDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory AttandanceDetailDb.fromMap(Map<String, dynamic> json) => AttandanceDetailDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.date,
    required this.checkIn,
    required this.checkOut,
  });

  String date;
  String checkIn;
  String checkOut;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    date: json["date"],
    checkIn: json["check_in"],
    checkOut: json["check_out"],
  );
}
