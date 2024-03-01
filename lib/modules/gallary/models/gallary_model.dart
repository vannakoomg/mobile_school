class GallaryModel {
  List<GalleryByMount>? data;
  List<Gallary>? data02;
  int? lastPage;

  GallaryModel({this.data, this.data02});

  GallaryModel.fromJson(Map<String, dynamic> json) {
    lastPage = json['last_page'];

    if (json['data'] != null) {
      data = <GalleryByMount>[];
      json['data'].forEach((v) {
        data!.add(new GalleryByMount.fromJson(v));
      });
    }
    if (json['data02'] != null) {
      data02 = <Gallary>[];
      json['data02'].forEach((v) {
        data02!.add(new Gallary.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['last_page'] = this.lastPage;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.data02 != null) {
      data['data02'] = this.data02!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GalleryByMount {
  String? yearMonth;
  List<Gallary>? gallary;

  GalleryByMount({this.yearMonth, this.gallary});

  GalleryByMount.fromJson(Map<String, dynamic> json) {
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
