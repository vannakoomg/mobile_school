class AbaQrDb {
  AbaQrDb({
    required this.data,
    required this.status,
  });

  List<ABA> data;
  bool status;

  factory AbaQrDb.fromMap(Map<String, dynamic> json) => AbaQrDb(
    data: List<ABA>.from(json["data"].map((x) => ABA.fromMap(x))),
    status: json["status"],
  );
}

class ABA {
  ABA({
    required this.amount,
    required this.image,
    required this.link,
  });

  int amount;
  String image;
  String link;

  factory ABA.fromMap(Map<String, dynamic> json) => ABA(
    amount: json["amount"],
    image: json["image"],
    link: json["link"],
  );
}
