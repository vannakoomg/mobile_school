class CollectionCardDb {
  CollectionCardDb({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  Data data;

  factory CollectionCardDb.fromMap(Map<String, dynamic> json) => CollectionCardDb(
    status: json["status"],
    message: json["message"],
    data: Data.fromMap(json["data"]),
  );
}

class Data {
  Data({
    required this.name,
    required this.nameKh,
    required this.email,
    required this.guardian1,
    required this.guardian2,
    required this.guardian3,
    this.rfIdCard,
    required this.fullImage,
    required this.guardian1Photo,
    required this.guardian2Photo,
    required this.guardian3Photo,
    required this.dataClass,
  });

  String name;
  String nameKh;
  String email;
  String guardian1;
  String guardian2;
  String guardian3;
  dynamic rfIdCard;
  String fullImage;
  String guardian1Photo;
  String guardian2Photo;
  String guardian3Photo;
  Class dataClass;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
    name: json["name"],
    nameKh: json["namekh"] == null ? '' : json["namekh"],
    email: json["email"],
    guardian1: json["guardian1"] == null ? '' : json["guardian1"],
    guardian2: json["guardian2"] == null ? '' : json["guardian2"],
    guardian3: json["guardian3"] == null ? '' : json["guardian3"],
    rfIdCard: json["rfidcard"],
    fullImage: json["fullimage"],
    guardian1Photo: json["guardian1_photo"],
    guardian2Photo: json["guardian2_photo"],
    guardian3Photo: json["guardian3_photo"],
    dataClass: Class.fromMap(json["class"]),
  );
}

class Class {
  Class({
    required this.name,
  });

  String name;

  factory Class.fromMap(Map<String, dynamic> json) => Class(
    name: json["name"],
  );
}

