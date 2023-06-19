class VersionDb {
  VersionDb({
    required this.id,
    required this.name,
    required this.value,
    this.link1,
    this.link2,
  });

  int id;
  String name;
  String value;
  dynamic link1;
  dynamic link2;

  factory VersionDb.fromMap(Map<String, dynamic> json) => VersionDb(
    id: json["id"],
    name: json["name"],
    value: json["value"],
    link1: json["link1"],
    link2: json["link2"],
  );
}


class HomeSlideDb {
  HomeSlideDb({
    required this.data,
  });

  List<Slide> data;

  factory HomeSlideDb.fromMap(Map<String, dynamic> json) => HomeSlideDb(
    data: List<Slide>.from(json["data"].map((x) => Slide.fromMap(x))),
  );
}

class Slide {
  Slide({
    required this.id,
    required this.name,
    required this.value,
    this.link1,
    this.link2,
  });

  int id;
  String name;
  String value;
  dynamic link1;
  dynamic link2;

  factory Slide.fromMap(Map<String, dynamic> json) => Slide(
    id: json["id"],
    name: json["name"],
    value: json["value"],
    link1: json["link1"],
    link2: json["link2"],
  );
}

