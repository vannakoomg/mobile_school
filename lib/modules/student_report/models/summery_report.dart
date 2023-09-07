class SummeryReport {
  int? status;
  String? message;
  Data? data;

  SummeryReport({this.status, this.message, this.data});

  SummeryReport.fromJson(Map<String, dynamic> json) {
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
  List<En>? en;
  List<En>? kh;

  Data({this.en, this.kh});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['en'] != null) {
      en = <En>[];
      json['en'].forEach((v) {
        en!.add(new En.fromJson(v));
      });
    }
    if (json['kh'] != null) {
      kh = <En>[];
      json['kh'].forEach((v) {
        kh!.add(new En.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.en != null) {
      data['en'] = this.en!.map((v) => v.toJson()).toList();
    }
    if (this.kh != null) {
      data['kh'] = this.kh!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class En {
  String? term;
  String? total;

  En({this.term, this.total});

  En.fromJson(Map<String, dynamic> json) {
    term = json['term'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['term'] = this.term;
    data['total'] = this.total;
    return data;
  }
}
