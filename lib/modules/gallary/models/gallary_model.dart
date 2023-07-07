class GallaryModel {
  List<Data>? data;

  GallaryModel({this.data});

  GallaryModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? yearMonth;
  List<Gallary>? gallary;

  Data({this.yearMonth, this.gallary});

  Data.fromJson(Map<String, dynamic> json) {
    yearMonth = json['year_month'];
    if (json['gallary'] != null) {
      gallary = <Gallary>[];
      json['gallary'].forEach((v) {
        gallary!.add(new Gallary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year_month'] = this.yearMonth;
    if (this.gallary != null) {
      data['gallary'] = this.gallary!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Gallary {
  int? id;
  String? title;
  String? image;
  String? date;

  Gallary({this.id, this.title, this.image, this.date});

  Gallary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['date'] = this.date;
    return data;
  }
}
