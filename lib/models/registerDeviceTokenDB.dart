class RegisterDeviceTokenDb {
  RegisterDeviceTokenDb({
    required this.status,
    required this.message,
  });

  bool status;
  String message;

  factory RegisterDeviceTokenDb.fromMap(Map<String, dynamic> json) => RegisterDeviceTokenDb(
    status: json["status"],
    message: json["message"],
  );
}
