class StudentReportModel {
  int? status;
  String? message;
  Data? data;

  StudentReportModel({this.status, this.message, this.data});

  StudentReportModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? schoolyear;
  String? term;
  String? classname;
  String? id;
  String? name;
  Language? language;
  List<Kh>? kh;
  List<En>? en;

  Data(
      {this.schoolyear,
      this.term,
      this.classname,
      this.id,
      this.name,
      this.language,
      this.kh,
      this.en});

  Data.fromJson(Map<String, dynamic> json) {
    schoolyear = json['schoolyear'];
    term = json['term'];
    classname = json['classname'];
    id = json['id'];
    name = json['name'];
    language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
    if (json['kh'] != null) {
      kh = <Kh>[];
      json['kh'].forEach((v) {
        kh!.add(new Kh.fromJson(v));
      });
    }
    if (json['en'] != null) {
      en = <En>[];
      json['en'].forEach((v) {
        en!.add(new En.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['schoolyear'] = this.schoolyear;
    data['term'] = this.term;
    data['classname'] = this.classname;
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.language != null) {
      data['language'] = this.language!.toJson();
    }
    if (this.kh != null) {
      data['kh'] = this.kh!.map((v) => v.toJson()).toList();
    }
    if (this.en != null) {
      data['en'] = this.en!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Language {
  Total? total;
  Count? count;

  Language({this.total, this.count});

  Language.fromJson(Map<String, dynamic> json) {
    total = json['total'] != null ? new Total.fromJson(json['total']) : null;
    count = json['count'] != null ? new Count.fromJson(json['count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.total != null) {
      data['total'] = this.total!.toJson();
    }
    if (this.count != null) {
      data['count'] = this.count!.toJson();
    }
    return data;
  }
}

class Total {
  var kh;
  var en;

  Total({this.kh, this.en});

  Total.fromJson(Map<String, dynamic> json) {
    kh = json['kh'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kh'] = this.kh;
    data['en'] = this.en;
    return data;
  }
}

class Count {
  int? kh;
  int? en;

  Count({this.kh, this.en});

  Count.fromJson(Map<String, dynamic> json) {
    kh = json['kh'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kh'] = this.kh;
    data['en'] = this.en;
    return data;
  }
}

class Kh {
  String? subject;
  String? totalwithletter;

  Kh({this.subject, this.totalwithletter});

  Kh.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    totalwithletter = json['totalwithletter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['totalwithletter'] = this.totalwithletter;
    return data;
  }
}

class En {
  String? subject;
  String? totalwithletter;

  En({this.subject, this.totalwithletter});

  En.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    totalwithletter = json['totalwithletter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['totalwithletter'] = this.totalwithletter;
    return data;
  }
}
